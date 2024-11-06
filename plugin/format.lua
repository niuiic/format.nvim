local bufs = {}

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function(args)
		local config = require("format")._config:get()
		if not config.format_on_save or not config.filetypes[vim.bo.filetype] then
			return
		end

		if bufs[args.buf] then
			bufs[args.buf] = false
			return
		end

		bufs[args.buf] = true
		require("format").format(function()
			pcall(function()
				vim.cmd("silent w")
			end)
		end)
	end,
})
