local static = require("format.static")

local buf_is_valid = function(bufnr, changed_tick)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false, "Buffer is not valid"
	end
	if not static.config.allow_update_if_buf_changed and changed_tick ~= vim.api.nvim_buf_get_changedtick(bufnr) then
		return false, "Buffer has changed during formatting"
	end
	return true
end

local copy_buf_to_file = function(bufnr, file_path)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	vim.fn.writefile(lines, file_path)
end

return {
	buf_is_valid = buf_is_valid,
	copy_buf_to_file = copy_buf_to_file,
}
