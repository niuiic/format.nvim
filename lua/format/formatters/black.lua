return function(context, apply_diff)
	vim.system({
		"black",
		"--stdin-filename",
		context.file_path,
		"--quiet",
		"-",
	}, {
		stdin = context.text,
	}, function(result)
		if result.code == 0 then
			apply_diff(context.text, result.stdout, context.bufnr)
		end
	end)
end
