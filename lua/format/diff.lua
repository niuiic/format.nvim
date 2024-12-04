local M = {}

-- % apply_change %
---@param old string
---@param new string
---@param bufnr number
M.apply_change = function(old, new, bufnr)
	require("omega").diff_text(old, new, function(text_edits)
		pcall(vim.lsp.util.apply_text_edits, text_edits, bufnr, M._offset_encoding())
	end)
end

-- % get_line_ending %
M.get_line_ending = function(bufnr)
	local format_line_ending = {
		["unix"] = "\n",
		["dos"] = "\r\n",
		["mac"] = "\r",
	}

	local line_ending = format_line_ending[vim.api.nvim_get_option_value("fileformat", {
		buf = bufnr,
	})] or "\n"

	return line_ending
end

-- % offset_encoding %
M._offset_encoding = function()
	local clients = vim.lsp.get_clients()
	local target = vim.iter(clients):find(function(client)
		return client.offset_encoding
	end)
	if target then
		return target.offset_encoding
	end
	return "utf-16"
end

return M

