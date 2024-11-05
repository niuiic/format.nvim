return function(context, apply_diff)
	vim.lsp.buf.format({ bufnr = context.bufnr })
	apply_diff()
end
