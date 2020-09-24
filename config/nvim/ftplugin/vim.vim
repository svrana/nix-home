if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

setlocal cindent
setlocal formatoptions+=croql
setlocal expandtab
setlocal shiftwidth=4
setlocal tabstop=4

call FTPluginSetupCommands()

" vim: sw=2 sts=2 et
