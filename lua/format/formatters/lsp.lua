return function(context, apply_change)
	vim.lsp.buf.format({ bufnr = context.bufnr })
	apply_change()
end
