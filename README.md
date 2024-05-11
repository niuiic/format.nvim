# format.nvim

An asynchronous, multitasking, and highly configurable formatting plugin.

[More neovim plugins](https://github.com/niuiic/awesome-neovim-plugins)

## Dependencies

- [niuiic/core.nvim](https://github.com/niuiic/core.nvim)

## Features

### Format entire file

Call `require("format").format()`.

The plugin only modifies changed parts, thus the buffer's folding, highlighting, etc, will not be affected.

### Format range

Call `require("format").format_range()`.

Only format selected area.

Only work in `v` mode, not `V` or `C-v`.

<img src="https://github.com/niuiic/assets/blob/main/format.nvim/format-range.gif" />

### Multitasking

1. What is multitasking?

That means you can use more than one tools to "format" code at one time.

2. Why do you need this feature?

The most common need, if you are writing js/ts, `prettier` may cause eslint error, if `eslint fix` is called after `prettier`, everything goes well.

## How it works

1. Copy buffer content into a temp file.
2. Apply commands to this file.
3. Read the file and write back to the buffer.
4. Remove the file.

> Why create a temp file?
>
> This plugin is designed to apply various commands to the buffer. Some commands, like `cargo fix`, cannot work if file does not exist.

## Config

See builtins at `lua/format/builtins`.

> There are no much builtins, but you can add your favorite formatting tools easily, as long as you know how to format files with the command line.

Default configuration here.

> See the full configuration at `lua/format/static.lua`

```lua
require("format").setup({
	allow_update_if_buf_changed = false,
	-- function to calculate path of the temp file
	temp_file = function(file_path)
		local core = require("core")
		local new_file_path = core.file.dir(file_path)
			.. "/_"
			.. core.file.name(file_path)
			.. "."
			.. (core.file.extension(file_path) or "")
		return new_file_path
	end,
	hooks = {
		---@type fun(code: integer, signal: integer) | nil
		on_success = function()
			vim.notify("Formatting Succeed", vim.log.levels.INFO, { title = "Format" })
		end,
		---@type fun(err: string | nil, data: string | nil) | nil
		on_err = function()
			vim.notify("Formatting Failed", vim.log.levels.ERROR, { title = "Format" })
		end,
		on_timeout = function()
			vim.notify("Formatting Timeout", vim.log.levels.ERROR, { title = "Format" })
		end,
	},
	filetypes = {
		-- see format configuration below
		lua = require("format.builtins.stylua"),
		rust = require("format.builtins.rustfmt"),
		javascript = require("format.builtins.prettier"),
		typescript = require("format.builtins.prettier"),
		-- ...
	},
})
```

Format configuration sample.

> You can debug your configuration with `on_err` option.

```lua
javascript = function(file_path)
	return {
		-- the first task
		---@class format.config
		---@field cmd string
		---@field args string[]
		---@field options {env?: table<string, any>, cwd?: string, uid?: number, gid?: number, verbatim?: boolean, detached?: boolean, hide?: boolean, timeout?: number} | nil
		---@field on_success fun(code: integer, signal: integer) | nil
		---@field on_err fun(err: string | nil, data: string | nil) | nil
		---@field ignore_err (fun(err: string | nil, data: string | nil): boolean) | nil
		{
			cmd = "prettier",
			args = {
				-- this plugin copies content of current buffer to a temporary file, and format this file, then write back to the buffer, thus, you need to make sure the formatter can write to the file
				"-w",
				file_path,
			},
			-- some formatters may output to stderr when formatted successfully, use this function to ignore these errors
			ignore_err = function(err, data)
				return err == nil and data == nil
			end,
		},
		-- the second task
		{
			cmd = "eslint",
			args = {
				"--fix",
				file_path,
			},
			-- just try to fix error with eslint, ignore the errors whether it succeed or not
			ignore_err = function()
				return true
			end,
			-- only the last task's `on_success` works
			-- all tasks's `on_err` works
			on_success = function()
				print("format success")
			end,
		},
	}
end
```

## Example to use with lsp format

This plugin has no lsp formatting feature built in. You can configure it like this to use both formatting functions at the same time.

```lua
local filetypes_use_lsp_format = {
	"c",
	"cpp",
}
local format = function()
	local core = require("core")
	if
		core.lua.list.includes(filetypes_use_lsp_format, function(filetype)
			return filetype == vim.bo.filetype
		end)
	then
		vim.lsp.buf.format()
	else
		require("format").format()
	end
end
```
