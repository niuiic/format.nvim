local config = {
	allow_update_if_buf_changed = false,
	offset_encoding = "utf-8",
	temp_file = function(file_path)
		local core = require("core")
		local new_file_path = core.file.dir(file_path)
			.. "/_"
			.. core.file.name(file_path)
			.. "."
			.. core.file.extension(file_path)
		return new_file_path
	end,
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
		-- clang-format
		c = require("format.builtins.clang_format"),
		cpp = require("format.builtins.clang_format"),
		glsl = require("format.builtins.clang_format"),
		wgsl = require("format.builtins.clang_format"),
		-- golines
		go = require("format.builtins.golines"),
		-- nginxbeautifier
		nginx = require("format.builtins.nginxbeautifier"),
		elixir = require("format.builtins.mixformat"),
	},
}

return {
	config = config,
}
