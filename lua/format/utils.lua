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

local lists_are_same = function(list1, list2)
	if #list1 ~= #list2 then
		return false
	end
	local is_same = true
	for index, value in ipairs(list1) do
		if value ~= list2[index] then
			is_same = false
			break
		end
	end
	return is_same
end

local copy_buf_to_file = function(bufnr, file_path)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	vim.fn.writefile(lines, file_path)
end

return {
	buf_is_valid = buf_is_valid,
	lists_are_same = lists_are_same,
	copy_buf_to_file = copy_buf_to_file,
}
