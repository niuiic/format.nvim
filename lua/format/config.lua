local Config = {}

function Config:new(config)
	local instance = {
		_config = config,
	}

	setmetatable(instance, {
		__index = Config,
	})

	return instance
end

function Config:set(config)
	self._config = vim.tbl_deep_extend("force", self._config, config)
end

function Config:get()
	return self._config
end

local default_config = {
	force_format = false,
	format_on_save = false,
	filetypes = {
		-- stylua
		lua = require("format.formatters.stylua"),
		-- biome
		javascript = require("format.formatters.biome"),
		typescript = require("format.formatters.biome"),
		javascriptreact = require("format.formatters.biome"),
		typescriptreact = require("format.formatters.biome"),
		css = require("format.formatters.biome"),
		json = require("format.formatters.biome"),
		jsonc = require("format.formatters.biome"),
		-- lsp
		glsl = require("format.formatters.lsp"),
		wgsl = require("format.formatters.lsp"),
		-- prettier,
		markdown = require("format.formatters.prettier"),
		scss = require("format.formatters.prettier"),
		less = require("format.formatters.prettier"),
		html = require("format.formatters.prettier"),
		graphql = require("format.formatters.prettier"),
		yaml = require("format.formatters.prettier"),
		dot = require("format.formatters.prettier"),
		tex = require("format.formatters.prettier"),
		plaintex = require("format.formatters.prettier"),
		vue = require("format.formatters.prettier"),
		-- rustfmt
		rust = require("format.formatters.rustfmt"),
		-- black
		python = require("format.formatters.black"),
		-- xmlformat
		svg = require("format.formatters.black"),
		-- taplo
		toml = require("format.formatters.taplo"),
		-- typstyle
		typst = require("format.formatters.typstyle"),
		-- shfmt
		sh = require("format.formatters.shfmt"),
		zsh = require("format.formatters.shfmt"),
		dockerfile = require("format.formatters.lsp"),
	},
}

return Config:new(default_config)
