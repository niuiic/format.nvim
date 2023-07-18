return function(file_path)
	return {
		{
			cmd = "clang-format",
			args = {
				"-i",
				file_path,
			},
		},
	}
end
