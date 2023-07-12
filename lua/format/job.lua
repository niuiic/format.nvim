local core = require("niuiic-core")
local static = require("format.static")

---@class Config
---@field cmd string
---@field args string[]
---@field options {env?: table<string, any>, cwd?: string, uid?: number, gid?: number, verbatim?: boolean, detached?: boolean, hide?: boolean, timeout?: number} | nil
---@field on_success fun(err: string | nil, data: string | nil) | nil
---@field on_err fun(err: string | nil, data: string | nil) | nil
---@field ignore_err fun(err: string | nil, data: string | nil): boolean | nil

local job
---@param conf_list Config[]
---@param on_success fun(): boolean
---@param on_err fun()
job = function(conf_list, on_success, on_err)
	if #conf_list == 0 then
		return
	end

	-- set options
	local config = conf_list[1]
	config.options = config.options or {}

	-- set on_success
	local on_job_success
	if #conf_list > 1 then
		on_job_success = function()
			job(
				core.lua.list.filter(conf_list, function(_, i)
					return i > 1
				end),
				on_success,
				on_err
			)
		end
	else
		on_job_success = function(err, data)
			local success = on_success()
			if success then
				if config.on_success then
					config.on_success(err, data)
				else
					static.config.hooks.on_success(err, data)
				end
			else
				config.on_err(err, data)
			end
		end
	end

	-- set on_err
	local on_job_err = function(err, data)
		if config.ignore_err and config.ignore_err(err, data) then
			on_job_success(err, data)
		else
			on_err()
			if config.on_err then
				config.on_err(err, data)
			else
				static.config.hooks.on_err(err, data)
			end
		end
	end

	-- start job
	local handle = core.job.spawn(config.cmd, config.args, config.options, on_job_success, on_job_err)

	-- resolve timeout
	if config.options.timeout then
		core.timer.set_timeout(function()
			handle.terminate()
			static.config.hooks.on_timeout()
		end, config.options.timeout)
	end
end

return job
