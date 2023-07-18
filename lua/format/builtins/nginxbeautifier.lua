return function(file_path)
	return {
		{
			cmd = "nginxbeautifier",
			args = {
				"-o",
				file_path,
			},
		},
	}
end
