local popfix = require'popfix'
local preview = require'finder.previewer'
local action = require'finder.action'
local mappings = require'finder.mappings'
local util = require'finder.util'
local M	= {}

local function create_opts(opts)
	return {
		close_on_error = true,
		data = {
			cwd = opts.cwd
		},
		close_on_bufleave = true,
		mode = opts.mode or 'editor',
		height = opts.height,
		width = opts.width,
		callbacks = {},
		list = {
			border = true,
		},
		prompt = {
			init_text = opts.init_text,
			border = true,
		},
		preview = {
			type = 'terminal',
			title = 'Preview',
			border = true,
		},
		sorter = opts.sorter
	}
end

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
	local fileActions = action.new_file_action(opts.cwd)
	local keymaps = mappings.new{
		close_selected = fileActions.edit,
		select = previewFunction,
		tab_close = fileActions.tab,
		split_close = fileActions.split,
		vert_split_close = fileActions.vert_split
	}
	local pop_opts = create_opts(opts)
	pop_opts.data.cmd = cmd
	pop_opts.callbacks.select = previewFunction
	pop_opts.keymaps = keymaps
	pop_opts.prompt.title = 'Files'
	if opts.preview_disabled then
		pop_opts.preview = nil
	end
	popfix:new(pop_opts)
end

function M.git_files(opts)
	opts = opts or {}
	local cmd
	if opts.cmd then
		cmd = opts.cmd
	elseif vim.fn.executable("git") then
		cmd = 'git ls-files'
	end
	if not cmd then
		print("You need to install git for running this program")
	end
	opts.cwd = opts.cwd or vim.fn.getcwd()
	local previewFunction = preview.new_bat_preview(opts.cwd)
	local fileActions = action.new_file_action(opts.cwd)
	local keymaps = mappings.new{
		close_selected = fileActions.edit,
		select = previewFunction,
		tab_close = fileActions.tab,
		split_close = fileActions.split,
		vert_split_close = fileActions.vert_split
	}
	local pop_opts = create_opts(opts)
	pop_opts.data.cmd = cmd
	pop_opts.callbacks.select = previewFunction
	pop_opts.keymaps = keymaps
	pop_opts.prompt.title = 'Git Files'
	if opts.preview_disabled then
		pop_opts.preview = nil
	end
	popfix:new(pop_opts)
end

function M.fuzzy_grep(opts)
	opts = opts or {}
	local cmd = opts.cmd
	if not cmd then
		-- TODO: checkout if there are more commands that can help like grep.
		if vim.fn.executable("rg") then
			cmd = 'rg --color=never --no-heading --with-filename --line-number --column --smart-case .'
		end
	end
	if not cmd then
		print("Yoy need to install rg for this operation.")
	end
	opts.cwd = opts.cwd or vim.fn.getcwd()
	local previewFunction = preview.new_bat_location_preview(opts.cwd)
	local fileActions = action.new_file_location_action(opts.cwd)
	local keymaps = mappings.new{
		close_selected = fileActions.edit,
		select = previewFunction,
		tab_close = fileActions.tab,
		split_close = fileActions.split,
		vert_split_close = fileActions.vert_split
	}
	local pop_opts = create_opts(opts)
	pop_opts.data.cmd = cmd
	pop_opts.callbacks.select = previewFunction
	pop_opts.keymaps = keymaps
	pop_opts.prompt.title = 'Fuzzy Grep'
	if opts.preview_disabled then
		pop_opts.preview = nil
	end
	popfix:new(pop_opts)
end

-- To reqd about this new repeated fuzzy engine please refer popfix.
-- It may be unstable but is more async and have good performance for very
-- large directory.
function M.grep(opts)
	opts = opts or {}
	local cmd = opts.cmd
	if not cmd then
		-- TODO: checkout if there are more commands that can help like grep.
		if vim.fn.executable("rg") then
			cmd = 'rg --color=never --no-heading --with-filename --line-number --column --smart-case %s'
		end
	end
	if not cmd then
		print("Yoy need to install rg for this operation.")
	end
	opts.cwd = opts.cwd or vim.fn.getcwd()
	local previewFunction = preview.new_bat_location_preview(opts.cwd)
	local fileActions = action.new_file_location_action(opts.cwd)
	local keymaps = mappings.new{
		close_selected = fileActions.edit,
		select = previewFunction,
		tab_close = fileActions.tab,
		split_close = fileActions.split,
		vert_split_close = fileActions.vert_split
	}
	local pop_opts = create_opts(opts)
	pop_opts.data.cmd = cmd
	pop_opts.callbacks.select = previewFunction
	pop_opts.keymaps = keymaps
	pop_opts.prompt.title = 'Grep'
	pop_opts.fuzzyEngine =
	require'popfix.fuzzy_engine':new_RepeatedExecutionEngine()
	pop_opts.sorter =
	opts.sorter or require'popfix.sorter':new_fzy_sorter()
	if opts.preview_disabled then
		pop_opts.preview = nil
	end
	popfix:new(pop_opts)
end

function M.help_tags(opts)
	opts = opts or {}
	local actions = action.new_help_action()
	local keymaps = mappings.new{
		close_selected = actions.edit,
		tab_close = actions.tab,
		split_close = actions.split,
		vert_split_close = actions.vert_split
	}
	local pop_opts = create_opts(opts)
	local tags = {}
	-- help tags are stored in doc/tags file of RTP (runtimepath of neovim)
	for _, file in pairs(vim.fn.findfile('doc/tags', vim.o.runtimepath, -1)) do
		local f = assert(io.open(file, "rb"))
		for line in f:lines() do
			local splits = util.split(line, '\t')
			table.insert(tags, splits[1])
		end
		f:close()
	end
	pop_opts.preview = nil
	pop_opts.data = tags
	pop_opts.keymaps = keymaps
	pop_opts.prompt.title = 'Help Tags'
	popfix:new(pop_opts)
end

return M
