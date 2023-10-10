return function(file_path)
	return {
		{
			cmd = "alejandra",
			args = { "-q", file_path },
		},
	}
end
