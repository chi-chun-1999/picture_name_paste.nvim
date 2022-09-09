--- Check if a file or directory exists in this path
local function exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists return true
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

local function random_pic_name()
	local pic_name=""
	local char_table = {
		'0','1','2','3','4','5','6','7','8','9',
		'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
		'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
	}
	math.randomseed(os.time())
	for i = 1,10 do
		local select_char = math.random(1,62)
		pic_name = pic_name..char_table[select_char]
	end
	pic_name = pic_name..'.png'
	return pic_name
end

local function find_file_name_from_all_path(all_path)
	local file_name = ""
	for i = #all_path,1,-1 do
		local stop_char = string.sub(all_path,i,i)
		if stop_char == '/' then
			file_name = string.sub(all_path,i+1)
			return file_name
		end
	end
	return all_path
end


M ={}
local vim_open_path = vim.api.nvim_command_output("pwd")
local home_path = os.getenv("HOME")
vim.g.PictureNamePaste_pic_ori_path = home_path..'/Pictures/'
vim.g.PictureNamePaste_search_priority={"svg","png","jpg","jpeg"}


--function M.get_relative_path()
--	local file_path = vim.fn.expand('%:p:h')
--	local end_num=nil
--	 --file_path = file_path..'/bin'
--	--print(#vim_open_path)
--	print(vim_open_path)
--	print(file_path)
--	--local start_num,end_num = string.find(vim_open_path,file_path,1)
--	--local start_num,end_num = string.find(file_path,vim_open_path,1)
--	--local start_num,end_num = string.find('/home/chi-chun/home','-',1)
--	--
--	for i=1,#file_path do
--		local char_file = string.sub(file_path,i,i)
--		local char_vim = string.sub(vim_open_path,i,i)
--		if char_file ~= char_vim then
--			print('x char_vim ->'..char_vim..'| char_file ->'..char_file)
--			end_num = i-1
--			break
--		elseif i==#file_path then
--			print('full char_vim ->'..char_vim..'| char_file ->'..char_file)
--			end_num = i
--		end
--	end
--
--	print(end_num)
--	print(string.sub(file_path,end_num+1))
--	--
--end

local function get_pic_store_path()
	local store_path=nil
	if vim.bo.filetype == 'tex' then
		store_path = vim.api.nvim_command_output("pwd")
	elseif vim.bo.filetype == 'markdown' then
		store_path = vim.fn.expand('%:p:h') 
	else
		store_path = vim.api.nvim_command_output("pwd")
	end
	store_path = store_path..'/pic/'

	--print(store_path)

	return store_path

end

function M.store_pic()

	local pic_store_path = get_pic_store_path()
	local exist,_ = isdir(pic_store_path)
	local return_file_name = nil
	--print(exist)

	if exist == nil then
		--print('mkdir'..pic_store_path)
		local mkdir_command = 'mkdir '..pic_store_path
		--print(mkdir_command)
		os.execute(mkdir_command)
	end

	local store_method = vim.g.PictureNamePaste_Method
	--store_method = 'CopyFromPicName'
	--store_method = 'Clipboard'

	---- Store From Clipboard ----
	if store_method == 'Clipboard' then
		local pic_name = random_pic_name()
		local pic_store_command = 'xclip -selection clipboard -t image/png -o > '..pic_store_path..pic_name..' &> /dev/null'
		local execute_output = os.execute(pic_store_command)
		if os.execute(pic_store_command)/256 == 1 then
			local remove_command = 'rm '..pic_store_path..pic_name
			os.execute(remove_command)
			vim.api.nvim_err_writeln("Clipboard is not pic")
			return nil
		else
			local pic_store_command = 'xclip -selection clipboard -t image/png -o > '..pic_store_path..pic_name
			os.execute(pic_store_command)
			return_file_name = pic_name
			return return_file_name
		end
	---- Copy from Picture Original Store Path to the Text directory ----
	elseif store_method == 'CopyFromPicName' then
		local search_priority = vim.g.PictureNamePaste_search_priority 
		local clipboard_content =os.capture('xclip -selection clipboard -o',true)
		for _,v in pairs(search_priority) do
			local picture_name =clipboard_content
			local picture_name_with_file_type = picture_name..'.'..v
			local ori_path = vim.g.PictureNamePaste_pic_ori_path..picture_name_with_file_type
			local pic_exists,_ = exists(ori_path)
			if pic_exists then
				local copy_command = 'cp '..ori_path..' '..pic_store_path..picture_name_with_file_type
				--print(copy_command)
				os.capture(copy_command)
				if v == 'svg' then
					local convert_pic = picture_name..'.eps'
					local transfer_command = 'inkscape -o '..pic_store_path..convert_pic..' '..pic_store_path..picture_name_with_file_type..' &> /dev/null'
					--print(transfer_command)
					os.execute(transfer_command)
					return_file_name = convert_pic
					return return_file_name
				end
				return_file_name = picture_name_with_file_type
				return return_file_name
			end
		end
		--- copy from all path ----
		local pic_exists,_ = exists(clipboard_content)
		if pic_exists then
			local copy_command = 'cp '..clipboard_content..' '..pic_store_path
			os.capture(copy_command)
			return_file_name = find_file_name_from_all_path(clipboard_content)
			return return_file_name
		end
		vim.api.nvim_err_writeln("The File Not Found")
	end
end


---print(M.vim_open_path)

return M
