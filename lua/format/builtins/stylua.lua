return function(file_path)
	return {
		{
			cmd = "stylua",
			args = {
				file_path,
			},
		},
	}
end
