return function(file_path)
	return {
		{
			cmd = "taplo",
			args = {
				file_path,
			},
			ignore_err = function()
				return true
			end,
		},
	}
end
