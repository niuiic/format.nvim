vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		local config = require("format")._config:get()
		if config.format_on_save and config.filetypes[vim.bo.filetype] then
			require("format").format()
		end
	end,
})
