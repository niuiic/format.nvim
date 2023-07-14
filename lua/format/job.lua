local core = require("core")
local static = require("format.static")

---@class format.config
---@field cmd string
---@field args string[]
---@field options {env?: table<string, any>, cwd?: string, uid?: number, gid?: number, verbatim?: boolean, detached?: boolean, hide?: boolean, timeout?: number} | nil
---@field on_success fun(code: integer, signal: integer) | nil
---@field on_err fun(err: string | nil, data: string | nil) | nil
---@field ignore_err fun(err: string | nil, data: string | nil): boolean | nil

local running = false
local is_running = function()
	return running
end

local spawn
---@param conf_list format.config[]
---@param on_success fun(): boolean
---@param on_err fun()
spawn = function(conf_list, on_success, on_err)
	if #conf_list == 0 then
		return
	end

	-- set options
	local config = conf_list[1]
	config.options = config.options or {}

	-- set on exit
	---@type fun(code: integer, signal: integer)
	local on_job_exit
	if #conf_list > 1 then
		on_job_exit = function()
			spawn(
				core.lua.list.filter(conf_list, function(_, i)
					return i > 1
				end),
				on_success,
				on_err
			)
		end
	else
		on_job_exit = function(code, signal)
			if not running then
				return
			end

			local success = on_success()
			if success then
				if config.on_success then
					config.on_success(code, signal)
				else
					static.config.hooks.on_success(code, signal)
				end
			else
				if config.on_err then
					config.on_err(nil, nil)
				end
			end
			running = false
		end
	end

	-- set on_err
	local on_job_err = function(err, data)
		if not running then
			return
		end

		if config.ignore_err and config.ignore_err(err, data) then
			return
		end

		on_err()
		if config.on_err then
			config.on_err(err, data)
		else
			static.config.hooks.on_err(err, data)
		end
		running = false
	end

	-- start job
	local handle = core.job.spawn(config.cmd, config.args, config.options, on_job_exit, on_job_err)
	running = true

	-- resolve timeout
	if config.options.timeout then
		core.timer.set_timeout(function()
			handle.terminate()
			on_err()
			static.config.hooks.on_timeout()
			running = false
		end, config.options.timeout)
	end
end

return {
	is_running = is_running,
	spawn = spawn,
}
