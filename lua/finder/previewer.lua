local path = require'finder.path'
local M = {}

function M.new_bat_preview(cwd)
	return function(_, line)
		if line == nil then return end
		cwd = cwd or vim.fn.getcwd()
		line = cwd .. '/' .. line
		line = path.normalize(line)
		local cmd	= string.format('bat %s -p -n',line)
		return {
			cmd	= cmd,
			cwd = cwd
		}
	end
end

return M
