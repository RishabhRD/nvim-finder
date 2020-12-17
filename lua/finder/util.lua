local function split(inputstr, sep)
    if sep == nil then
	sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	table.insert(t, str)
    end
    return t
end

local function p(t)
    print(vim.inspect(t))
end

local function file_readable(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

return {
    split = split,
    p = p,
    file_readable = file_readable
}
