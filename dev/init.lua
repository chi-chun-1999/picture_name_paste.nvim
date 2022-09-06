package.loaded['picture_name_paste'] = nil
package.loaded['picture_name_paste.insert_text'] = nil
package.loaded['dev'] = nil


vim.api.nvim_set_keymap('n',',r',':luafile dev/init.lua<cr>',{})

picture_name_paste = require('picture_name_paste')
vim.api.nvim_set_keymap('n',',c',':lua picture_name_paste.insert_text()<cr>',{})
