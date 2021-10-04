local opt = vim.opt

opt.ttimeout = false
opt.ttimeoutlen = 100
opt.ignorecase = true
opt.wrap = false
opt.backspace = "indent,eol,start"
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false
opt.incsearch = true
opt.hlsearch = false
opt.inccommand = "split"
--g.backupcopy = true
opt.tags = "tags=tags,${GRUF_PROJECT}/tags"
opt.showmatch = true
opt.backupext  = ".bak"
opt.backupdir = "~/.config/nvim/bak"
opt.errorbells = false
opt.showmode = false
opt.visualbell = true
opt.ruler = true
opt.laststatus = 2
--g.go = "ia"
opt.equalalways = false
opt.updatetime = 100
opt.lazyredraw = true
opt.background = "dark"
opt.pyx = 3
opt.termguicolors = true
opt.clipboard = "unnamed,unnamedplus"

--local g = vim.g
--local cmd = vim.cmd
