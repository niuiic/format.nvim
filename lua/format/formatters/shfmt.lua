return function(context, apply_diff)
	vim.system({
		"shfmt",
		"-filename",
		context.file_path,
	}, {
		stdin = context.text,
	}, function(result)
		if result.code == 0 then
			apply_diff(context.text, result.stdout, context.bufnr)
		end
	end)
end
