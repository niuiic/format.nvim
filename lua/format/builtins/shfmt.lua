return function(file_path)
	return {
		{
			cmd = "shfmt",
			args = {
				"-w",
				file_path,
			},
		},
	}
end
