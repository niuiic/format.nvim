return function(context, apply_diff)
	vim.system({
		"rustfmt",
		"--emit=stdout",
		"--config",
		"imports_granularity=Crate,group_imports=StdExternalCrate",
		"--edition=2021",
	}, {
		cwd = vim.fs.root(0, "Cargo.toml"),
		stdin = context.text,
	}, function(result)
		if result.code == 0 then
			apply_diff(context.text, result.stdout, context.bufnr)
		end
	end)
end
