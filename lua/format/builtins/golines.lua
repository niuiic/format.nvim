return function(file_path)
	return {
		{
			cmd = "golines",
			args = {
				"-w",
				file_path,
			},
		},
	}
end
