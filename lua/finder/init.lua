local popfix = require'popfix'
local preview = require'finder.previewer'
local action = require'finder.action'
local mappings = require'finder.mappings'
local path = require'finder.path'
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
	    coloring = true,
	    border = true,
	    border_highlight = 'FinderListBorder',
	    highlight = 'FinderListHighlight',
	    selection_highlight = 'FinderListSelection',
	    matching_highlight = 'FinderListMatch'
	},
	prompt = {
	    init_text = opts.init_text,
	    border = true,
	    border_highlight = 'FinderPromptBorder',
	    highlight = 'FinderPromptHighlight',
	    prompt_highlight = 'FinderPromptCommand',
	},
	preview = {
	    type = 'terminal',
	    title = 'Preview',
	    border = true,
	    border_highlight = 'FinderPreviewBorder',
	    highlight = 'FinderPreviewHighlight',
	    preview_highlight = 'FinderPreviewLine'
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

function M.colorschemes(opts)
    opts = opts or {}
    local actions = action.new_colorscheme_action()
    local keymaps = mappings.new{
	close_selected = actions.edit,
    }
    local pop_opts = create_opts(opts)
    -- getcompletion vimscript function returns all colorscheme for color
    -- completion
    pop_opts.data = vim.fn.getcompletion('', 'color')
    pop_opts.preview = nil
    pop_opts.keymaps = keymaps
    pop_opts.prompt.title = 'colorschemes'
    popfix:new(pop_opts)
end

function M.filetypes(opts)
    opts = opts or {}
    local actions = action.new_filetype_action()
    local keymaps = mappings.new{
	close_selected = actions.edit,
    }
    local pop_opts = create_opts(opts)
    pop_opts.data = vim.fn.getcompletion('', 'filetype')
    pop_opts.preview = nil
    pop_opts.keymaps = keymaps
    pop_opts.prompt.title = 'filetypes'
    popfix:new(pop_opts)
end

function M.commands(opts)
    opts = opts or {}
    local actions = action.new_command_action()
    local keymaps = mappings.new{
	close_selected = actions.edit,
    }
    local pop_opts = create_opts(opts)
    pop_opts.data = vim.fn.getcompletion('', 'command')
    pop_opts.preview = nil
    pop_opts.keymaps = keymaps
    pop_opts.prompt.title = 'Commands'
    popfix:new(pop_opts)
end

function M.command_history(opts)
    opts = opts or {}
    local actions = action.new_command_action()
    local keymaps = mappings.new{
	close_selected = actions.edit,
    }
    local pop_opts = create_opts(opts)
    local history = vim.fn.execute('history cmd')
    local historyTable = vim.split(history, "\n")
    local len = #historyTable
    pop_opts.data = {}
    local dataLen = 1
    -- Here comes the regex magic. First entry is handled differently because
    -- first entry is different.
    pop_opts.data[dataLen] = string.gsub(historyTable[len], '^>%s*%d*%s*', '')
    for i = len - 1, 2, -1 do
	dataLen = dataLen + 1
	pop_opts.data[dataLen] = string.gsub(historyTable[i], '^%s*%d*%s*', '')
    end
    pop_opts.preview = nil
    pop_opts.keymaps = keymaps
    pop_opts.prompt.title = 'Command History'
    popfix:new(pop_opts)
end

function M.file_history(opts)
    opts = opts or {}
    local previewFunction = preview.new_bat_preview('/')
    local fileActions = action.new_file_action('/')
    local keymaps = mappings.new{
	close_selected = fileActions.edit,
	select = previewFunction,
	tab_close = fileActions.tab,
	split_close = fileActions.split,
	vert_split_close = fileActions.vert_split
    }
    local pop_opts = create_opts(opts)
    pop_opts.data = {}
    local dataLen = 0
    for _,file in ipairs(vim.v.oldfiles) do
	if util.file_readable(file) then
	    dataLen = dataLen + 1
	    pop_opts.data[dataLen] = file
	end
    end
    pop_opts.callbacks.select = previewFunction
    pop_opts.keymaps = keymaps
    pop_opts.prompt.title = 'File History'
    if opts.preview_disabled then
	pop_opts.preview = nil
    end
    popfix:new(pop_opts)
end

function M.buffers(opts)
    opts = opts or {}
    local previewFunction = preview.new_buffer_preview()
    local fileActions = action.new_buffer_action()
    local keymaps = mappings.new{
	close_selected = fileActions.edit,
	select = previewFunction,
	tab_close = fileActions.tab,
	split_close = fileActions.split,
	vert_split_close = fileActions.vert_split
    }
    local cwd = vim.fn.getcwd()
    local pop_opts = create_opts(opts)
    local buffers = vim.fn.getcompletion('', 'buffer')
    local current = vim.fn.bufnr('%')
    local alternate = vim.fn.bufnr('#')
    local dataLen = 0
    pop_opts.data = {}
    for _, buffer in ipairs(buffers) do
	local bufnr = vim.fn.bufnr(buffer)
	if util.file_readable(buffer) then
	    buffer = path.make_relative(buffer, cwd)
	end
	local tag = ''
	local lnum = vim.fn.getbufinfo(bufnr)[1].lnum
	if bufnr == current then tag = '%' end
	if bufnr == alternate then tag = '#' end
	dataLen = dataLen + 1
	pop_opts.data[dataLen] = string.format('[%d] %s %s:%s', bufnr, tag,
	buffer, lnum)
    end
    pop_opts.callbacks.select = previewFunction
    pop_opts.keymaps = keymaps
    pop_opts.preview.type = 'buffer'
    pop_opts.preview.numbering = true
    pop_opts.prompt.title = 'Buffers'
    if opts.preview_disabled then
	pop_opts.preview = nil
    end
    popfix:new(pop_opts)
end

return M
