local util = require'finder.util'
local path = require'finder.path'
local M = {}

function M.new_bat_preview(cwd)
    return function(_, line)
	if line == nil then return end
	cwd = cwd or vim.fn.getcwd()
	line = cwd .. '/' .. line
	line = path.normalize(line)
	local cmd   = string.format([[bat %s -p --paging=always --pager "less -RS"]],line)
	return {
	    cmd	= cmd,
	    cwd = cwd
	}
    end
end

function M.new_bat_location_preview(cwd)
    return function(_, line)
	if line == nil then return end
	local splits = util.split(line, ':')
	local filename = splits[1]
	local lnum = splits[2]
	cwd = cwd or vim.fn.getcwd()
	line = cwd .. '/' .. line
	line = path.normalize(line)
	local startPoint = lnum - 3
	if startPoint <= 0 then
	    startPoint = lnum
	end
	local cmd   = string.format('bat %s -p --paging=always --pager "less -RS" -H %s -r %s:',filename, lnum,
	startPoint)
	return {
	    cmd	= cmd,
	    cwd = cwd
	}
    end
end

function M.new_buffer_preview()
    local function getBufferFromLine(line)
	local bracesOpen = 1
	local bracesClose = string.find(line, ']')
	return string.sub(line, bracesOpen + 1, bracesClose - bracesOpen)
    end
    local function getLineNumber(line)
	local splits = util.split(line, ':')
	return splits[#splits]
    end
    return function(_, line)
	if line == nil then return {} end
	local buf = getBufferFromLine(line)
	return {
	    bufnr = buf,
	    line = tonumber(getLineNumber(line))
	}
    end
end

return M
