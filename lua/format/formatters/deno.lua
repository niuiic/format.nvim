return function(context, apply_change)
	vim.system({
		"deno",
		"fmt",
		"--no-semicolons",
		"--single-quote",
		"--unstable-component",
		"--unstable-sql",
		"-",
	}, {
		stdin = context.text,
	}, function(result)
		if result.code == 0 then
			apply_change(context.text, result.stdout, context.bufnr)
		end
	end)
end
