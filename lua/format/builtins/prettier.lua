return function(file_path)
	return {
		{
			cmd = "prettier",
			args = {
				"-w",
				file_path,
			},
		},
	}
end
