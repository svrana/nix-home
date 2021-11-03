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
-- opt.clipboard = "unnamed,unnamedplus"
-- opt.clipboard = "unnamed"
-- local g = vim.g
-- local cmd = vim.cmd

-- move lines (and blocks of lines in visual mode) up and down using alt-j/k
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true})
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true})
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true})
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true})
vim.api.nvim_set_keymap('v', '<A-j>', ':m \'>+1<CR>gv=gv', { noremap = true})
vim.api.nvim_set_keymap('v', '<A-k>', ':m \'<-2<CR>gv=gv', { noremap = true})

--Do not save when switching buffers (note: this is now a default on master)
vim.o.hidden = true
