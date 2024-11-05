return function(context, apply_diff)
	vim.system({
		"stylua",
		"--stdin-filepath",
		context.file_path,
		"--search-parent-directories",
		"-",
	}, {
		stdin = context.text,
	}, function(result)
		if result.code == 0 then
			apply_diff(context.text, result.stdout, context.bufnr)
		end
	end)
end
