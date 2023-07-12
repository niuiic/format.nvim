local config = {
	update_same = false,
	hooks = {
		---@type fun(err: string | nil, data: string | nil) | nil
		on_success = function()
			vim.notify("Formatting Succeed", vim.log.levels.INFO, { title = "Format" })
		end,
		---@type fun(err: string | nil, data: string | nil) | nil
		on_err = function()
			vim.notify("Formatting Failed", vim.log.levels.ERROR, { title = "Format" })
		end,
		on_timeout = function()
			vim.notify("Formatting Timeout", vim.log.levels.ERROR, { title = "Format" })
		end,
	},
	filetypes = {
		lua = require("format.builtins.stylua"),
		javascript = require("format.builtins.prettier"),
		typescript = require("format.builtins.prettier"),
		rust = require("format.builtins.rustfmt"),
	},
}

return {
	config = config,
}
