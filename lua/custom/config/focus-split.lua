vim.cmd [[
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set relativenumber
    autocmd WinLeave * set norelativenumber
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END
]]
return {}
