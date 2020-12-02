local M = {}

function M.new_bat_preview(cwd)
	return function(_, line)
		return {
			cmd	= 'bat %s -p -n',
			cwd = cwd
		}
	end
end

return M
