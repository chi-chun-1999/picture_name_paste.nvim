--- Check if a file or directory exists in this path
local function exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

--- Check if a directory exists in this path
local function isdir(path)
   -- "/" works on both Unix and Windows
   return exists(path.."/")
end

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

M ={}
local vim_open_path = os.capture("pwd",true)

function M.convert_clipboard_to_png()

end

function M.get_relative_path()
	local file_path = vim.fn.expand('%:p:h')
	local end_num=nil
	 --file_path = file_path..'/bin'
	print(#vim_open_path)
	print(file_path)
	--local start_num,end_num = string.find(vim_open_path,file_path,1)
	--local start_num,end_num = string.find(file_path,vim_open_path,1)
	--local start_num,end_num = string.find('/home/chi-chun/home','-',1)
	--
	for i=1,#file_path do
		local char_file = string.sub(file_path,i,i)
		local char_vim = string.sub(vim_open_path,i,i)
		if char_file ~= char_vim then
			end_num = i
			break
		elseif i==#file_path then
			end_num = i+1
		end
	end

	print(end_num)
	print(string.sub(vim_open_path,end_num))
	--
end

print(M.vim_open_path)

return M
