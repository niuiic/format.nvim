local bufs = {}
vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function(args)
		if bufs[args.buf] then
			bufs[args.buf] = nil
			return
		end

		local config = require("format")._config:get()
		if not config.format_on_save or not config.filetypes[vim.bo.filetype] then
			return
		end

		bufs[args.buf] = true
		require("format").format(function()
			vim.cmd("silent! write")
		end)
	end,
})
