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
		print('not tex')
	end

	return text
end


function M.insert_text()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	print("current lined "..row)
	local text=M.filetype_text()
	--local text={'e','3'}
	vim.api.nvim_buf_set_lines(0,row,row,false,text)
end


return M
