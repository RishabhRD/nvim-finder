local popfix = require'popfix'
local preview = require'finder.previewer'
local action = require'finder.action'
local mappings = require'finder.mappings'
local M	= {}

function M.files(opts)
	local cmd = opts.cmd
	if not cmd then
		if vim.fn.executable("fd") then
			cmd = 'fd --type f'
		elseif vim.fn.executable("rg") then
			cmd = 'rg --files'
		elseif vim.fn.executable("find")
			cmd = 'find . -type f'
		end
	end
	if not cmd then
		print("You need fd, rg or find command to run file search. Otherwise
		provide yours with format cmd = <cmd>.")
	end
	local preview = opts.preview_disabled
	local sorter = opts.sorter
	local cwd = opts.cwd or vim.fn.getcwd()
	local mode = opts.mode or 'editor'
	local height = opts.height
	local width = opts.width
	local init_text = opts.init_text
	local previewFunction = preview.new_bat_preview(cwd)
	local fileActions = action.new_file_actions(cwd)
	local keymaps = mappings.new{
		close_selected = fileActions.edit,
		select = previewFunction,
		tab_close = fileActions.tab,
		split_close = fileActions.split,
		vert_split_close = fileActions.vert_split
	}
	local pop_opts = {
		height = height,
		width = width,
		callback = {
			select = previewFunction
		},
		keymaps = keymaps,
		list = {
			border = true
		},
		prompt = {
			prompt_command = 'Files',
			init_text = init_text,
			border = true
		},
		preview = {
			type = 'terminal',
			title = 'Preview',
			border = true,
		}
	}
	if opts.preview_disabled then
		pop_opts.preview = nil
	end
	popfix.new(pop_opts)
end

return M
