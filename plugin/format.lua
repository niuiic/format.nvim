local bufs = {}

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function(args)
		local config = require("format")._config:get()
		if config.format_on_save and config.filetypes[vim.bo.filetype] then
			if bufs[args.buf] then
				bufs[args.buf] = nil
				return
			end
			require("format").format(function()
				bufs[args.buf] = true
				vim.cmd("silent w")
			end)
		end
	end,
})
