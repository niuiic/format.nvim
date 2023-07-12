return function(file_path)
	return {
		{
			cmd = "stylua",
			args = {
				file_path,
			},
			ignore_err = function(err, data)
				return err == nil and data == nil
			end,
			timeout = 1,
		},
	}
end
