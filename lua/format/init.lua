local static = require("format.static")
local core = require("core")
local job = require("format.job")
local utils = require("format.utils")
local uv = vim.loop
local diff = require("format.diff")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

local cp_file = function(bufnr, file_path)
	local new_file_path = static.config.temp_file(file_path)
	utils.copy_buf_to_file(bufnr, new_file_path)
	return new_file_path
end

local use_on_job_success = function(temp_file, bufnr, changed_tick)
	return function()
		local valid, err = utils.buf_is_valid(bufnr, changed_tick)
		if not valid then
			vim.notify(err, vim.log.levels.ERROR, { title = "Format" })
			uv.fs_unlink(temp_file)
			return false
		end

		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		local new_lines = vim.fn.readfile(temp_file)
		local success, result = pcall(diff.compute_diff, lines, new_lines)
		if not success then
			uv.fs_unlink(temp_file)
			return false
		end
		if diff.has_diff(result) then
			vim.lsp.util.apply_text_edits({ result }, bufnr, "utf-8")
		end

		uv.fs_unlink(temp_file)
		return true
	end
end

local format = function()
	if job.is_running() then
		vim.notify("Previous formatting job is running", vim.log.levels.WARN, { title = "Format" })
		return
	end

	local supported_filetypes = core.lua.table.keys(static.config.filetypes)
	if not core.lua.list.find(supported_filetypes, function(ft)
		return ft == vim.bo.filetype
	end) then
		vim.notify("This filetype is not supported", vim.log.levels.ERROR, { title = "Format" })
		return
	end

	local changed_tick = vim.api.nvim_buf_get_changedtick(0)
	local bufnr = vim.api.nvim_win_get_buf(0)
	local file_path = vim.api.nvim_buf_get_name(0)
	local temp_file = cp_file(bufnr, file_path)
	local conf_list = static.config.filetypes[vim.bo.filetype](temp_file)
	local on_job_success = use_on_job_success(temp_file, bufnr, changed_tick)
	job.spawn(conf_list, on_job_success, function()
		uv.fs_unlink(temp_file)
	end)
end

return { setup = setup, format = format }
