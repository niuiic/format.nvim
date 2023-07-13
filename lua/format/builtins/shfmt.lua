return function(file_path)
	return {
		{
			cmd = "shfmt",
			args = {
				"-w",
				file_path,
			},
			ignore_err = function(err, data)
				return err == nil and data == nil
			end,
		},
	}
end
