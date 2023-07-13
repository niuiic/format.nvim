return function(file_path)
	return {
		{
			cmd = "sqlfluff",
			args = {
				"format",
				file_path,
				"--dialect",
				"mysql",
			},
		},
	}
end
