local insert_text = require('picture_name_paste.insert_text')
local picture_process = require('picture_name_paste.picture_process')

vim.api.nvim_create_user_command('InsertText',function()
	insert_text.insert_text()
end
	,{nargs = '*'})



vim.api.nvim_create_user_command('PicStore',function() picture_process.store_pic()
end
	,{nargs = '*'})

return{
	insert_text = insert_text,
	picture_process = picture_process,
}

