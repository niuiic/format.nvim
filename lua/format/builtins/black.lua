return function(file_path)
	return {
		{
			cmd = "black",
			args = {
				file_path,
			},
			ignore_err = function()
				return true
			end,
		},
	}
end
