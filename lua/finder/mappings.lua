local M = {}

function M.new(opts)
	-- Initial interface for mappings
	local map = {
		n = {},
		i = {}
	}

	-- Some mendatory mappings. These mappings define the general behaviour how
	-- plugin's interface keymaps would work and will be called on any case if
	-- module is using this new function. If no callback is provided, it would
	-- null callback would be passed. (No problem with null callback)
	local close_cancelled = function(self)
		self:close(opts.close_cancelled)
	end
	local close_selected = function(self)
		self:close(opts.close_selected)
	end
	map.i['<C-c>'] = close_cancelled
	map.n['q'] = close_cancelled
	map.n['<Esc>'] = close_cancelled
	map.i['<Cr>'] = close_selected
	map.n['<Cr>'] = close_selected
	local select_next = function(self)
		self:select_next(opts.select)
	end
	local select_prev = function(self)
		self:select_prev(opts.select)
	end
	map.i['<C-n>'] = select_next
	map.i['<C-p>'] = select_prev
	map.i['<C-j>'] = select_next
	map.i['<C-k>'] = select_prev
	map.i['<Down>'] = select_next
	map.i['<Up>'] = select_prev
	map.n['j'] = select_next
	map.n['k'] = select_prev
	map.i['<Down>'] = select_next
	map.i['<Up>'] = select_prev

	-- Some optional mappings.

	-- tab
	if opts.tab_close then
		local tab_close = function(self)
			self:close(tab_close)
		end
		map.n['<C-t>'] = tab_close
		map.i['<C-t>'] = tab_close
	end
	-- split
	if otps.split_close then
		local split_close = function(self)
			self:close(split_close)
		end
		map.n['<C-x>'] = split_close
		map.i['<C-x>'] = split_close
	end
	-- vert_split mapping
	if opts.vert_split_close then
		local split_close = function(self)
			self:close(vert_split_close)
		end
		map.n['<C-v>'] = split_close
		map.i['<C-v>'] = split_close
	end
	return map
end

return M
