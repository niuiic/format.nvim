local static = require("format.static")
local core = require("core")
local job = require("format.job")

local buf_is_valid = function(bufnr, changed_tick)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false, "Buffer is not valid"
	end
	if not static.config.allow_update_if_buf_changed and changed_tick ~= vim.api.nvim_buf_get_changedtick(bufnr) then
		return false, "Buffer has changed during formatting"
	end
	return true
end

local copy_to_file = function(file_path, bufnr, selection)
	local lines
	if selection then
		lines = core.lua.string.split(selection, "\n")
	else
		lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	end
	vim.fn.writefile(lines, file_path)
end

local ready = function()
	if job.is_running() then
		vim.notify("Previous formatting job is running", vim.log.levels.WARN, { title = "Format" })
		return false
	end

	local supported_filetypes = core.lua.table.keys(static.config.filetypes)
	if not core.lua.list.find(supported_filetypes, function(ft)
		return ft == vim.bo.filetype
	end) then
		vim.notify("This filetype is not supported", vim.log.levels.ERROR, { title = "Format" })
		return false
	end

	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	if #lines == 1 and lines[1] == "" then
		vim.notify("Nothing to format", vim.log.levels.WARN, { title = "Format" })
		return false
	end

	return true
end

return {
	buf_is_valid = buf_is_valid,
	copy_to_file = copy_to_file,
	ready = ready,
}
