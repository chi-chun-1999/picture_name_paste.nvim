local insert_text = require('picture_name_paste.insert_text')

vim.api.nvim_create_user_command('InsertText',function()
	insert_text.insert_text()
end
	,{nargs = '*'})



vim.api.nvim_create_user_command('FiletypeText',function()
	insert_text.filetype_text()
end
	,{nargs = '*'})

return{
	insert_text = insert_text,
}

