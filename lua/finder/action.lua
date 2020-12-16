local util = require'finder.util'
local path = require'finder.path'
local M = {}

local function getBufferFromLine(line)
	local bracesOpen = 1
	local bracesClose = string.find(line, ']')
	return string.sub(line, bracesOpen + 1, bracesClose - bracesOpen)
end

local function openBuffer(bufnr, line, option)
	if option == 'edit' then
		vim.cmd(string.format('buffer %s', bufnr))
		vim.cmd(string.format('%d',line))
	elseif option == 'split' then
		vim.cmd(string.format('sbuffer %s', bufnr))
		vim.cmd(string.format('%d',line))
	elseif option == 'vert_split' then
		vim.cmd(string.format('vert sbuffer %s', bufnr))
		vim.cmd(string.format('%d',line))
	elseif option == 'tab' then
		vim.cmd(string.format('tab sb %s', bufnr))
		vim.cmd(string.format('%d',line))
	end
	vim.cmd(':normal! zz')
end

local function openFile(filename, cwd, option)
	if filename == nil then return end
	cwd = cwd or vim.fn.getcwd()
	filename = cwd .. '/' .. filename
	filename = path.normalize(filename)
	if option == 'edit' then
		vim.cmd(string.format('e %s', filename))
	elseif option == 'split' then
		vim.cmd(string.format('new %s', filename))
	elseif option == 'vert_split' then
		vim.cmd(string.format('vnew %s', filename))
	elseif option == 'tab' then
		vim.cmd(string.format('tabnew %s', filename))
	end
	vim.cmd(':normal! zz')
end

local function openFileLocation(filename, line, cwd, option)
	if filename == nil then return end
	cwd = cwd or vim.fn.getcwd()
	filename = cwd .. '/' .. filename
	filename = path.normalize(filename)
	if option == 'edit' then
		vim.cmd(string.format('e %s', filename))
	elseif option == 'split' then
		vim.cmd(string.format('new %s', filename))
	elseif option == 'vert_split' then
		vim.cmd(string.format('vnew %s', filename))
	elseif option == 'tab' then
		vim.cmd(string.format('tabnew %s', filename))
	end
	vim.cmd(string.format('%d', line))
	vim.cmd(':normal! zz')
end

function M.new_file_action(cwd)
	cwd = cwd or vim.fn.getcwd()
	return{
		edit = function(_, line)
			if line == nil then return end
			openFile(line, cwd, 'edit')
		end,
		vert_split = function(_, line)
			if line == nil then return end
			openFile(line, cwd, 'vert_split')
		end,
		split = function(_, line)
			if line == nil then return end
			openFile(line, cwd, 'split')
		end,
		tab =  function(_, line)
			if line == nil then return end
			openFile(line, cwd, 'tab')
		end
	}
end

function M.new_file_location_action(cwd)
	cwd = cwd or vim.fn.getcwd()
	return{
		edit = function(_, line)
			if line == nil then return end
			local splits = util.split(line, ':')
			local filename = splits[1]
			local lnum = splits[2]
			openFileLocation(filename, lnum, cwd, 'edit')
		end,
		vert_split = function(_, line)
			if line == nil then return end
			local splits = util.split(line, ':')
			local filename = splits[1]
			local lnum = splits[2]
			openFileLocation(filename, lnum, cwd, 'vert_split')
		end,
		split = function(_, line)
			if line == nil then return end
			local splits = util.split(line, ':')
			local filename = splits[1]
			local lnum = splits[2]
			openFileLocation(filename, lnum, cwd, 'split')
		end,
		tab =  function(_, line)
			if line == nil then return end
			local splits = util.split(line, ':')
			local filename = splits[1]
			local lnum = splits[2]
			openFileLocation(filename, lnum, cwd, 'tab')
		end
	}
end

function M.new_help_action()
	local function helpOpen(line, command)
		if command == 'edit' then
			vim.cmd(string.format('help %s', line))
		elseif command == 'split' then
			vim.cmd(string.format('help %s', line))
		elseif command == 'vert_split' then
			vim.cmd(string.format('vert help %s', line))
		elseif command == 'tab' then
			vim.cmd(string.format('tab help %s', line))
		end
	end
	return{
		edit = function(_, line)
			if line == nil then return end
			helpOpen(line, 'edit')
		end,
		vert_split = function(_, line)
			if line == nil then return end
			helpOpen(line, 'vert_split')
		end,
		split = function(_, line)
			if line == nil then return end
			helpOpen(line, 'split')
		end,
		tab =  function(_, line)
			if line == nil then return end
			helpOpen(line, 'tab')
		end
	}
end

function M.new_colorscheme_action()
	return {
		edit = function (_, line)
			if line == nil then return end
			vim.cmd(string.format('colorscheme %s', line))
		end
	}
end

function M.new_filetype_action()
	return {
		edit = function (_, line)
			if line == nil then return end
			vim.cmd(string.format('setfiletype %s', line))
		end
	}
end

function M.new_command_action()
	return {
		edit = function (_, line)
			if line == nil then return end
			vim.cmd(line)
		end
	}
end

function M.new_buffer_action()
	local function getLineNumber(line)
		local splits = util.split(line, ':')
		return splits[#splits]
	end
	return{
		edit = function(_, line)
			if line == nil then return end
			openBuffer(getBufferFromLine(line), getLineNumber(line), 'edit')
		end,
		vert_split = function(_, line)
			if line == nil then return end
			openBuffer(getBufferFromLine(line), getLineNumber(line), 'vert_split')
		end,
		split = function(_, line)
			if line == nil then return end
			openBuffer(getBufferFromLine(line), getLineNumber(line), 'split')
		end,
		tab =  function(_, line)
			if line == nil then return end
			openBuffer(getBufferFromLine(line), getLineNumber(line), 'tab')
		end
	}
end

return M
