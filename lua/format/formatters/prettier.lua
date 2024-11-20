return function(context, apply_change)
	vim.system({
		"prettier",
		"--stdin-filepath",
		context.file_path,
	}, {
		stdin = context.text,
	}, function(result)
		if result.code == 0 then
			apply_change(context.text, result.stdout, context.bufnr)
		end
	end)
end
