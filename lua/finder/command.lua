local M = {}

function M.run_command(args)
    local firstWhiteSpace = string.find(args, "%s")
    local command, init_text
    if firstWhiteSpace then
	command = string.sub(args, 1, firstWhiteSpace - 1)
	init_text = string.sub(args, firstWhiteSpace + 1)
    else
	command = args
    end
    local opts = {
	init_text = init_text
    }
    local func = require'finder'[command]
    if not func then
	print('No such function')
	return
    end
    func(opts)
end

return M
