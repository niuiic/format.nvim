return function(file_path)
	return {
		{
			cmd = "rustfmt",
			args = {
				file_path,
				"--edition=2021",
			},
			ignore_err = function(err, data)
				return err == nil and data == nil
			end,
		},
	}
end
