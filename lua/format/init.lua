local M = {
	_config = require("format.config"),
}

---@class format.Context
---@field bufnr number
---@field text string
---@field file_path string

---@param callback fun(context: format.Context) | nil
M.format = function(callback)
	local line_ending = require("format.diff").get_line_ending(0)
	---@type format.Context
	local context = {
		bufnr = vim.api.nvim_get_current_buf(),
		text = vim.iter(vim.api.nvim_buf_get_lines(0, 0, -1, false)):join(line_ending),
		file_path = vim.api.nvim_buf_get_name(0),
	}
	local changed_tick = vim.api.nvim_buf_get_changedtick(0)
	local apply_diff = vim.schedule_wrap(function(...)
		if M._config:get().force_format or changed_tick == vim.api.nvim_buf_get_changedtick(context.bufnr) then
			require("format.diff").apply_diff(...)
			if callback then
				callback(context)
			end
		end
	end)

	local formatter = M._config:get().filetypes[vim.bo.filetype]
	if not formatter then
		vim.notify("No formatter found for this filetype", vim.log.levels.WARN, {
			title = "format.nvim",
		})
		return
	end
	formatter(context, apply_diff)
end

M.setup = function(config)
	M._config:set(config)
end

return M
