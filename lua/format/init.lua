local static = require("format.static")
local job = require("format.job")
local utils = require("format.utils")
local uv = vim.loop
local diff = require("format.diff")
local core = require("core")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

local create_temp_file = function(file_path, bufnr, selection)
	local new_file_path = static.config.temp_file(file_path)
	utils.copy_to_file(new_file_path, bufnr, selection)
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
			vim.lsp.util.apply_text_edits({ result }, bufnr, static.config.offset_encoding)
		end

		uv.fs_unlink(temp_file)
		return true
	end
end

local format = function()
	if not utils.ready() then
		return
	end

	local changed_tick = vim.api.nvim_buf_get_changedtick(0)
	local bufnr = vim.api.nvim_win_get_buf(0)
	local file_path = vim.api.nvim_buf_get_name(0)

	local temp_file = create_temp_file(file_path, bufnr)

	local conf_list = static.config.filetypes[vim.bo.filetype](temp_file)
	local on_job_success = use_on_job_success(temp_file, bufnr, changed_tick)

	job.spawn(conf_list, on_job_success, function()
		uv.fs_unlink(temp_file)
	end)
end

local format_range = function()
	if not utils.ready() then
		return
	end

	local mode = vim.fn.mode()
	if mode ~= "v" then
		vim.notify("Cannot work in mode " .. mode, vim.log.levels.ERROR, {
			title = "Format",
		})
		return
	end

	local changed_tick = vim.api.nvim_buf_get_changedtick(0)
	local bufnr = vim.api.nvim_win_get_buf(0)
	local file_path = vim.api.nvim_buf_get_name(0)

	local selection = core.text.selection()
	local pos = core.text.selected_area(bufnr)
	if not pos then
		return false
	end
	core.text.cancel_selection()
	local s_start = pos.s_start
	local s_end = pos.s_end

	local first_line = vim.api.nvim_buf_get_lines(bufnr, s_start.row - 1, s_start.row, false)[1]
	local last_line = vim.api.nvim_buf_get_lines(bufnr, s_end.row - 1, s_end.row, false)[1]
	local before_start = string.sub(first_line, 0, s_start.col - 1)
	local after_end = string.sub(last_line, s_end.col + 1)

	local temp_file = create_temp_file(file_path, bufnr, selection)

	local conf_list = static.config.filetypes[vim.bo.filetype](temp_file)
	local on_job_success = use_on_job_success(temp_file, bufnr, changed_tick)

	job.spawn(conf_list, function()
		local file_lines = vim.fn.readfile(temp_file)
		if #file_lines == 1 then
			file_lines[1] = string.format("%s%s%s", before_start, file_lines[1], after_end)
		else
			file_lines[1] = string.format("%s%s", before_start, file_lines[1])
			file_lines[#file_lines] = string.format("%s%s", file_lines[#file_lines], after_end)
		end
		local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		local new_lines = {}
		for i = 1, s_start.row - 1, 1 do
			table.insert(new_lines, buf_lines[i])
		end
		core.lua.list.each(file_lines, function(line)
			table.insert(new_lines, line)
		end)
		for i = s_end.row + 1, #buf_lines, 1 do
			table.insert(new_lines, buf_lines[i])
		end
		vim.fn.writefile(new_lines, temp_file)

		return on_job_success()
	end, function()
		uv.fs_unlink(temp_file)
	end)
end

return { setup = setup, format = format, format_range = format_range }
