return function(file_path)
	return {
		{
			cmd = "mix",
			args = {
				"format",
				file_path,
			},
		},
	}
end
