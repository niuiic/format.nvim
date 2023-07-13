return function(file_path)
	return {
		{
			cmd = "rustfmt",
			args = {
				file_path,
			},
		},
	}
end
