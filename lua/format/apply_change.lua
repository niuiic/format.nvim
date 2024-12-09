local M = {}

-- % apply_change %
---@param old string
---@param new string
---@param bufnr number
---@param callback fun() | nil
M.apply_change = function(old, new, bufnr, callback)
	require("omega").diff_text(old, new, function(text_edits)
		vim.schedule(function()
			pcall(vim.lsp.util.apply_text_edits, text_edits, bufnr, require("omega").get_offset_encoding())
			if callback then
				callback()
			end
		end)
	end)
end

return M
