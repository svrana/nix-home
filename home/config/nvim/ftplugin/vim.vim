if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

setlocal cindent
setlocal formatoptions+=croql

lua vim.treesitter.start()

" vim: sw=2 sts=2 et
