local popfix = require'popfix'
local preview = require'finder.previewer'
local action = require'finder.action'
local mappings = require'finder.mappings'
local M	= {}

function M.files(opts)
	opts = opts or {}
	local cmd = opts.cmd
	if not cmd then
		if vim.fn.executable("fd") then
			cmd = 'fd --type f'
		elseif vim.fn.executable("rg") then
			cmd = 'rg --files'
		elseif vim.fn.executable("find") then
			cmd = 'find . -type f'
		end
	end
	if not cmd then
		print("You need fd, rg or find command to run file search. Otherwise provide yours with format cmd = <cmd>.")
	end
	opts.cwd = opts.cwd or vim.fn.getcwd()
	local previewFunction = preview.new_bat_preview(opts.cwd)
	local fileActions = action.new_file_actions(opts.cwd)
	local keymaps = mappings.new{
		close_selected = fileActions.edit,
		select = previewFunction,
		tab_close = fileActions.tab,
		split_close = fileActions.split,
		vert_split_close = fileActions.vert_split
	}
	local pop_opts = {
		data = {
			cmd = cmd,
			cwd = opts.cwd
		},
		mode = opts.mode or 'editor',
		height = opts.height,
		width = opts.width,
		callbacks = {
			select = previewFunction
		},
		keymaps = keymaps,
		list = {
			border = true,
		},
		prompt = {
			init_text = opts.init_text,
			border = true,
			title = 'Files'
		},
		preview = {
			type = 'terminal',
			title = 'Preview',
			border = true,
		},
		sorter = opts.sorter
	}
	if opts.preview_disabled then
		pop_opts.preview = nil
	end
	popfix:new(pop_opts)
end

return M
