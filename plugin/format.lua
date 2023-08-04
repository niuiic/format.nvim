local job = require("format.job")
local utils = require("format.utils")

vim.api.nvim_create_autocmd({ "VimLeave" }, {
	pattern = { "*" },
	callback = function()
		if job.is_running() then
			pcall(vim.loop.fs_unlink, utils.get_temp_file())
		end
	end,
})
