local picture_process = require('picture_name_paste.picture_process')

local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

M = {}

function M.set_image_path()
	local image_path ='./pic/xxxx.png'
	vim.g.PictureNamePaste_image_path=image_path
end

function M.filetype_text()
	local text =nil
	local image_path = vim.g.PictureNamePaste_image_path

	if vim.bo.filetype == 'tex' then
	local text_image_line = '\t\\includegraphics[height=5cm]{'..image_path..'}'
		--print('type ----> '..vim.bo.filetype)
		text={
			'\\begin{figure}[h]',
			'\t\\centering',
			text_image_line,
			'\t\\caption{}',
			'\t\\label{fig:}',
			'\\end{figure}'
		}
	elseif vim.bo.filetype == 'markdown' then
	local text_image_line = '![]('..image_path..')'
		text={
			text_image_line
		}
	else
		return nil
	end

	return text
end


function M.insert_text()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	print("current lined "..row)
	local text=M.filetype_text()
	if text ~=nil then
		vim.api.nvim_buf_set_lines(0,row,row,false,text)
	end
end

function M.insert_text_from_clipboard()
	vim.g.PictureNamePaste_Method = 'Clipboard'
	local pic_name = picture_process.store_pic()
	if pic_name ~= nil then
		vim.g.PictureNamePaste_image_path = './pic/'..pic_name
		M.insert_text()
	end
end

function M.insert_text_from_pic_name()
	vim.g.PictureNamePaste_Method = 'CopyFromPicName'
	local pic_name = picture_process.store_pic()
	if pic_name ~= nil then
		vim.g.PictureNamePaste_image_path = './pic/'..pic_name
		M.insert_text()
	end
end

function M.insert_only_pic_name_from_clipboard()
	vim.g.PictureNamePaste_Method = 'Clipboard'
	local pic_name = picture_process.store_pic()
	if pic_name ~= nil then
		vim.g.PictureNamePaste_image_path = './pic/'..pic_name
		local pos = vim.api.nvim_win_get_cursor(0)[2]
		local line = vim.api.nvim_get_current_line()
		local nline = line:sub(0, pos) ..vim.g.PictureNamePaste_image_path.. line:sub(pos + 1)
		vim.api.nvim_set_current_line(nline)
	end
end

function M.insert_only_pic_name_from_pic_name()
	vim.g.PictureNamePaste_Method = 'CopyFromPicName'
	local pic_name = picture_process.store_pic()
	if pic_name ~= nil then
		vim.g.PictureNamePaste_image_path = './pic/'..pic_name
		local pos = vim.api.nvim_win_get_cursor(0)[2]
		local line = vim.api.nvim_get_current_line()
		local nline = line:sub(0, pos) ..vim.g.PictureNamePaste_image_path.. line:sub(pos + 1)
		vim.api.nvim_set_current_line(nline)
	end
end

return M
