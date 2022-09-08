local insert_text = require('picture_name_paste.insert_text')
local picture_process = require('picture_name_paste.picture_process')

vim.api.nvim_create_user_command('InsertText',function()
	insert_text.insert_text()
end
	,{nargs = '*'})



vim.api.nvim_create_user_command('GetRelativePath',function()
	picture_process.get_relative_path()
end
	,{nargs = '*'})

return{
	insert_text = insert_text,
	picture_process = picture_process,
}

