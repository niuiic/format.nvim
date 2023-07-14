local config = {
	allow_update_if_buf_changed = false,
	hooks = {
		---@type fun(code: integer, signal: integer) | nil
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
		-- stylua
		lua = require("format.builtins.stylua"),
		-- rustfmt
		rust = require("format.builtins.rustfmt"),
		-- prettier
		javascript = require("format.builtins.prettier"),
		typescript = require("format.builtins.prettier"),
		markdown = require("format.builtins.prettier"),
		javascriptreact = require("format.builtins.prettier"),
		typescriptreact = require("format.builtins.prettier"),
		vue = require("format.builtins.prettier"),
		css = require("format.builtins.prettier"),
		scss = require("format.builtins.prettier"),
		less = require("format.builtins.prettier"),
		html = require("format.builtins.prettier"),
		json = require("format.builtins.prettier"),
		graphql = require("format.builtins.prettier"),
		yaml = require("format.builtins.prettier"),
		dot = require("format.builtins.prettier"),
		tex = require("format.builtins.prettier"),
		plaintex = require("format.builtins.prettier"),
		-- black
		python = require("format.builtins.black"),
		-- shfmt
		sh = require("format.builtins.shfmt"),
		zsh = require("format.builtins.shfmt"),
		-- sqlfluff
		sql = require("format.builtins.sqlfluff"),
		-- taplo
		toml = require("format.builtins.taplo"),
	},
}

return {
	config = config,
}
