local file_name = function(file_path)
	return string.match(file_path, "([^/]+)$")
end

local parent_path = function(file_path)
	return string.match(file_path, "^(.+)/[^/]+$")
end

local on_not_support = function()
	vim.notify("This filetype is not supported", vim.log.levels.ERROR, { title = "Format" })
end

local buf_is_valid = function(bufnr, changed_tick)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false, "Buffer is not valid"
	end
	if changed_tick ~= vim.api.nvim_buf_get_changedtick(bufnr) then
		return false, "Buffer has changed during formatting"
	end
	return true
end

local lists_are_same = function(list1, list2)
	if #list1 ~= list2 then
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
	file_name = file_name,
	parent_path = parent_path,
	on_not_support = on_not_support,
	buf_is_valid = buf_is_valid,
	lists_are_same = lists_are_same,
	copy_buf_to_file = copy_buf_to_file,
}
