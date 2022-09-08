local insert_text = require('picture_name_paste.insert_text')
local picture_process = require('picture_name_paste.picture_process')

vim.api.nvim_create_user_command('InsertText',function()
	insert_text.insert_text()
end
	,{nargs = '*'})



vim.api.nvim_create_user_command('PicStore',function() picture_process.store_pic()
end
	,{nargs = '*'})

vim.api.nvim_create_user_command('PictureNamePasteTextClipboard',function() 
	insert_text.insert_text_from_clipboard()
end
	,{nargs = '*'})

vim.api.nvim_create_user_command('PictureNamePasteTextPicName',function() 
	insert_text.insert_text_from_pic_name()
end
	,{nargs = '*'})

vim.api.nvim_create_user_command('PictureNamePasteOnlyClipboard',function() 
	insert_text.insert_only_pic_name_from_clipboard()
end
	,{nargs = '*'})

vim.api.nvim_create_user_command('PictureNamePasteOnlyPicName',function() 
	insert_text.insert_only_pic_name_from_pic_name()
end
	,{nargs = '*'})

return{
	insert_text = insert_text,
	picture_process = picture_process,
}

