local path = require'finder.path'
local M = {}

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
end

function M.new_file_actions(cwd)
	cwd = cwd or vim.fn.getcwd()
	return{
		edit = function(_, line)
			openFile(line, cwd, 'edit')
		end,
		vert_split = function(_, line)
			openFile(line, cwd, 'vert_split')
		end,
		split = function(_, line)
			openFile(line, cwd, 'split')
		end,
		tab =  function(_, line)
			openFile(line, cwd, 'tab')
		end
	}
end

return M
