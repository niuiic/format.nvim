return function(file_path)
	return {
		{
			cmd = "taplo",
			args = {
				"format",
				file_path,
			},
			ignore_err = function()
				return true
			end,
		},
	}
end
