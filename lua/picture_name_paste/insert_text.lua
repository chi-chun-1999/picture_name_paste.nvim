local function insert_text()
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(0, pos) .. 'hello' .. line:sub(pos + 1)
  vim.api.nvim_set_current_line(nline)
  --vim.api.nvim_set_current_line('sssss')
  print("current line "..nline)
end

return insert_text
