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
		lua = require("format.formatters.stylua"),
		javascript = require("format.formatters.biome"),
		typescript = require("format.formatters.biome"),
		javascriptreact = require("format.formatters.biome"),
		typescriptreact = require("format.formatters.biome"),
		css = require("format.formatters.biome"),
		json = require("format.formatters.biome"),
		jsonc = require("format.formatters.biome"),
		glsl = require("format.formatters.lsp"),
	},
}

return Config:new(default_config)
