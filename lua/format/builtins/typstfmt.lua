return function(file_path)
	return {
		{
			cmd = "typstfmt",
			args = {
				file_path,
			},
		},
	}
end
