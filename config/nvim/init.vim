" MACRO HOWTO
"
" q + <letter> starts recording a macro
" then q stops it
" then @<letter> to use it
"
"
function! BuildComposer(info)
	if a:info.status != 'unchanged' || a:info.force
		!cargo build --release
	endif
endfunction

call plug#begin('~/.local/share/nvim/plugged')

" Style
Plug 'svrana/solarize'			" solarize everything
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'edkolev/tmuxline.vim'

" Vim functionality helpers
Plug 'tpope/vim-obsession'		" auto-session handling

Plug 'junegunn/vim-peekaboo'		" show contents of copy buffer
Plug 'mhinz/vim-startify'
"Plug 'gioele/vim-autoswap' 		" swap to the active tmux pane instead of annoying swap file msg
Plug 'unblevable/quick-scope'

" Git related plugins
Plug 'tpope/vim-fugitive'		" mostly for blame
Plug 'airblade/vim-gitgutter'		" showing and staging chunks
Plug 'jreybert/vimagit'			" project wide git
Plug 'tpope/vim-rhubarb'		" sharing git urls

" Text processing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'		" auto-commenting
Plug 'christoomey/vim-sort-motion'
Plug 'vim-scripts/matchit.zip'

" Programming (general)
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ervandew/supertab'
"Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
"Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ternjs/tern_for_vim'
Plug 'svrana/neomake'
Plug 'majutsushi/tagbar'		" ide
Plug 'wellle/tmux-complete.vim'		" completion from other tmux panes
"Plug 'SirVer/ultisnips'			" snippet handler
"Plug 'honza/vim-snippets'		" Snippets are separated from the engine.
Plug 'Chiel92/vim-autoformat'
Plug 'airblade/vim-rooter' 		" Automatically go to the project root (i.e., .git, etc)

" Language specific functionality
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' } " mostly for identifier jumping
Plug 'wsdjeg/vim-fetch'			" open file:lineno:colno see sf()
"Plug 'fatih/gomodifytags'
"Plug 'zchee/deoplete-go'
"Plug 'zchee/deoplete-jedi'
"Plug 'fishbullet/deoplete-ruby'
Plug 'psf/black'			" python formatting
Plug 'stsewd/isort.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'LnL7/vim-nix'

" File handling
Plug 'junegunn/fzf.vim'
Plug 'farmergreg/vim-lastplace'		" open file at last position
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

" Language specific visual effects:  ftplugins, highlighting, etc
Plug 'tpope/vim-jdaddy'			" json formatting
Plug 'cespare/vim-toml'			" toml formatting
Plug 'othree/html5.vim'
Plug 'fs111/pydoc.vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'ingydotnet/yaml-vim'
Plug 'hashivim/vim-terraform'
Plug 'hashivim/vim-packer'
Plug 'google/vim-jsonnet'
Plug 'posva/vim-vue'
Plug 'justinmk/vim-sneak'
Plug 'tmux-plugins/vim-tmux'		" editing .tmux.conf
Plug 'leafgarland/typescript-vim'


call plug#end()				" All of your Plugins must be added before the following line
set mouse=a
set rtp+=$RCS/nvim/vimsnips

let mapleader = ","
let maplocalleader = ","

"set relativenumber
"set number
"toggle display of numbers
nnoremap <leader>dn :set relativenumber!<CR>

" vim-autoswap
set title titlestring=
let g:autoswap_detect_tmux = 1

"remove trailing whitespace on save
autocmd! BufWritePre * :%s/\s\+$//e
"autoformat python code with black on save
"autocmd BufWritePre *.py execute ':Black'
"
let g:typescript_indent_disable = 1

let g:markdown_composer_autostart = 0
let g:markdown_composer_browser="epiphany-browser"

" Statusline stetup
let g:airline_powerline_fonts = 1
let g:airline_section_b='' "Disable showing branch cause it crowds the filename
let g:airline_section_y='' "Disable filetype cause it's mostly useless
" exclude overwrite statusline of list filetype
let g:airline_exclude_filetypes = ["list"]
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t' "no path,only filename
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline_skip_empty_sections = 1
let g:airline#extensions#virtualenv#enabled = 1

let g:tagbar_autofocus = 0

" virtualenv for neovim, has neovim python package installed
let g:python3_host_prog = expand("$WORKON_HOME/neovim3/bin/python")
"let g:python_host_prog  = expand("$WORKON_HOME/neovim2/bin/python")

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_verbose = 0

let g:peekaboo_delay=300

au BufWrite *.ts :Autoformat

" Whitespace related
"
" To disable showing trailing whitespace:
" let g:ShowTrailingWhitespace = 0
" Auto-delete whitespace automatically, no ask
let g:DeleteTrailingWhitespace = 1
let g:DeleteTrailingWhitespace_Action = 'delete'

"let g:deoplete#enable_at_startup = 1
" let g:deoplete#disable_auto_complete = 1
"set completeopt=longest,menuone,preview
"let g:deoplete#sources = {}
"let g:deoplete#sources['javascript.jsx'] = ['file', 'ultisnips', 'ternjs']
"let g:deoplete#sources['python.py'] = ['file', 'ultisnips']
"et g:tern#command = ['tern']
"et g:tern#arguments = ['--persistent']
"

" call deoplete#custom#source('omni', 'functions', {
"     \ 'python':  'ultisnips',
"     \})

" Snippet configuration (not working)
let g:UltiSnipsExpandTrigger="<c-;>"
"let g:UltiSnipsExpandTrigger=";"
"let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsSnippetsDir="/home/shaw/.dotfiles/configs/nvim/vimsnips"

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Source the vimrc file after saving it
"
augroup VimReload
autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

set completeopt+=menu
set notimeout
set ttimeout
set ttimeoutlen=100
set backspace=indent,eol,start
set directory^=.config/nvim/swp
set nowrap
set nosol
" show nothing in window frame on exit
set titleold=
set scrollopt=ver
set ic
set smartcase
set incsearch
set nohlsearch
set inccommand=split
" placed here for webpack hmr
set backupcopy=yes

" make asterick search work in visual mode
vmap * "yy:let @/='\(' . @y . '\'<cr>n

if !empty($GRUF_CONFIG)
	source ${GRUF_CONFIG}/gruf.vimrc
end

set tags=tags,${GRUF_PROJECT}/tags

set comments=sr:/*,mb:*,exl:*/,://,b:#,:%:XCOMM,n:>,fb:-
set comments+=b:\"

" Turn on continuation of comment characters for all file types
"autocmd FileType * setlocal formatoptions+=caroq
autocmd FileType * setlocal formatoptions+=croq
autocmd BufRead gitcommit setlocal spell spelllang=en_US textwidth=72
autocmd BufRead gitcommit setlocal fo+=t
autocmd BufRead *.md setlocal spell spelllang=en_US textwidth=90 " z= for suggestions
autocmd BufRead *.txt setlocal spell spelllang=en_US textwidth=90
autocmd BufRead *.eml setlocal spell spelllang=en_US textwidth=90
autocmd BufNewFile,BufRead,BufEnter *.erb setf ruby
autocmd BufNewFile,BufRead,BufEnter *.feature setf ruby
autocmd BufNewFile,BufRead,BufEnter *.gradle setf groovy
autocmd BufNewFile,BufRead,BufEnter *.json setf json
autocmd BufNewFile,BufRead,BufEnter *.gjs setf javascript
autocmd BufNewFile,BufRead,BufEnter BUILD.fs setf python
autocmd BufWritePost,BufEnter * Neomake
autocmd FileType terraform setlocal commentstring=#%s
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
			\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

"remove current line highlight in unfocused window
"au VimEnter,WinEnter,BufWinEnter,FocusGained,CmdwinEnter * set relativenumber
"au WinLeave,FocusLost,CmdwinLeave * set norelativenumber

" When editing a file that requires root, try to save using sudo
cmap w!! %!sudo tee > /dev/null %

" ignore .pyc, .o, and .git in command-t and :e
set wildignore+=*.pyc,*.o,.git
set showmatch
set backupext=.bak
set backupdir=~/.config/nvim/bak
set sessionoptions=buffers,options,winpos,winsize,help,blank,globals,resize
set noerrorbells
set noshowmode "airline/powerline shows mode, so no need to show it
set showcmd
set helpheight=0
set visualbell
set t_vb=
set ruler
set laststatus=2
set go=ia
set noequalalways
set mousehide
set mousefocus
set mousemodel=extend

" vim -b: edit binary using xxd-format
augroup Binary
	au!
	au BufReadPre  *.bin let &bin=1
	au BufReadPost *.bin if &bin | %!xxd
	au BufReadPost *.bin set ft=xxd | endif
	au BufWritePre *.bin if &bin | %!xxd -r
	au BufWritePre *.bin endif
	au BufWritePost *.bin if &bin | %!xxd
	au BufWritePost *.bin set nomod | endif
augroup END

function! GotoDotfiles()
	cd $DOTFILES
endfun

map  \cf :call GetFile(expand("$DOTFILES"))<CR>
map! \cf <ESC>:call GetFile(expand("$DOTFILES"))<CR>

map  \gc :call GotoDotfiles()<CR>
map! \gc <ESC>:call GotoDotfile()<CR>

map \sp :split<CR>
map! \sp <ESC>:split<CR>
nmap <silent> \ts :ts<CR>

noremap  <leader>w :w<CR>
noremap! <leader>w <ESC>:w<CR>
noremap  <leader>q :q<CR>
noremap! <leader>q <ESC>:q<CR>
noremap  <leader>e :wq<CR>
noremap! <leader>e <ESC>:wq<CR>
noremap  <leader>z :q!<CR>
noremap! <leader>z <ESC>:q!<CR>

" map  <F3> :Explore<CR>
" map! <F3> <ESC>:Explore<CR>
" map  <F7> :!tlc<CR><CR>
" map! <F7> <ESC>:!tlc<CR><CR>
" map  <F12> :q<CR>
" map! <F12> <ESC>:q<CR>

map  <m-n> :cn<CR>
map! <m-n> <ESC>:cn<CR>
map  <m-p> :cp<CR>
map! <m-p> <ESC>:cp<CR>
map  <m-f> :cfirst<CR>
map! <m-f> <ESC>:cfirst<CR>
map  <m-l> :clist<CR>
map! <m-l> <ESC>:clist<CR>
map  <m-o> :copen<CR>
map! <m-o> <ESC>:copen<CR>

imap jj <ESC>

nmap n nmzz.`z
nmap N Nmzz.`z
nmap * *mzz.`z
nmap # #mzz.`z
nmap g* g*mzz.`z
nmap g# g#mzz.`z

" buffers
map  <c-p> :bp<CR>
map! <c-p> <esc>:bp<CR>
map  <c-n> :bn<CR>
map! <c-n> <esc>:bn<CR>
map  <c-j> :buffers<CR>
map! <c-j> <esc>:buffers<CR>
map  <c-x> :bdelete<CR>
map! <c-x> <esc>:bdelete<CR>
map  <c-/> :bdelete<CR>
map! <c-/> <esc>:bdelete<CR>

" tabs
map  <c-s> :tabp<CR>			" goto previous tab
map! <c-s> <ESC>tabp<CR>
map  <c-h> :tabn<CR>			" goto next tab
map! <c-h> <ESC>tabn<CR>
nnoremap <leader>nt :tabnew<CR>		" create new tab

map <c-c> :make<CR>
map - <C-W>-
map + <C-W>+

noremap <silent> <leader>zz :TagbarToggle<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>

" jump between erros in quickfix list
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" goto next tag in taglist
map	<c-=> :tnext<CR>
map!	<c-=> <ESC>:tnext<CR>
" map pageup to something reasonable
map <c-d> <c-b>
map <c-r> :'a,'bs/^/#/<CR>
nnoremap \rcb :'a,'bs/^#//<CR>

" toggle highlighting when searching
nnoremap \th :set invhls hls?<CR>
" toggle paste mapping to avoid things like autoindent causing 'stepped' text
nnoremap \tp :set invpaste paste?<CR>

set background=dark

augroup qs_colors
	autocmd!
	autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
	autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END

colorscheme solarized

map  <M-Esc>[62~ <MouseDown>
map! <M-Esc>[62~ <MouseDown>
map  <M-Esc>[63~ <MouseUp>
map! <M-Esc>[63~ <MouseUp>
map  <M-Esc>[64~ <S-MouseDown>
map! <M-Esc>[64~ <S-MouseDown>
map  <M-Esc>[65~ <S-MouseUp>
map! <M-Esc>[65~ <S-MouseUp>

nnoremap <silent> <LocalLeader>ms :ComposerStart<cr>
nnoremap <silent> <LocalLeader>t :FZF<cr>
nnoremap <silent> <LocalLeader>r :Rg<cr>
nnoremap <silent> <LocalLeader>hs :!home-manager -f $DOTFILES/hosts/$HOSTNAME.nix switch<cr>

nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
nmap \m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>

" Make the 81st column standout
" Used by all ftplugins
function FTPluginSetupCommands()
	call matchadd('ColorColumn', '\%81v', 100)
endfunction

"====[ Highlight matches when jumping to next ]====
" OR ELSE just highlight the match in red... (Damian Conway)
nnoremap <silent> n     n:call HLNext(0.4)<cr>
nnoremap <silent> N     N:call HLNext(0.4)<cr>
highlight WhiteOnRed ctermfg=white ctermbg=red
function! HLNext (blinktime)
	let [bufnum, lnum, col, off] = getpos('.')
	let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
	let target_pat = '\c\%#'.@/
	let ring = matchadd('WhiteOnRed', target_pat, 101)
	redraw
	exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
	call matchdelete(ring)
	redraw
endfunction

" Don't use vim's keyword completion on <tab>
"let g:SuperTabDefaultCompletionType = 'context'
" Not sure why I need this, but it prevents an extra <cr> after selecting a
" completion option
let g:SuperTabCrMapping = 0
let g:SuperTabDefaultCompletionType = '<c-n>'
let g:SuperTabClosePreviewOnPopupClose = 1

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
	let l:file = expand('%')
	if l:file =~# '^\f\+_test\.go$'
		call go#cmd#Test(0, 1)
	elseif l:file =~# '^\f\+\.go$'
		call go#cmd#Build(0)
	endif
endfunction

au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
au FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
au FileType go nmap <leader>e <Plug>(go-rename)
au FileType go nmap <leader>r :GoTest<CR>
au FileType go nmap <leader>s <Plug>(go-implements)
au FileType go nmap <leader>o <Plug>(go-test)

let g:go_fmt_command = "goimports"
"let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_metalinter_autosave_enabled = ['gopls', 'vet']

" v-- nice but long info causes a 'press any key' and also overwrites errors
" let g:go_auto_type_info = 1
set updatetime=100 	" update every 100ms
let g:go_fmt_autosave = 1
let g:go_list_type = "quickfix"
"let g:go_def_mode='godef'
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Enables debug logging
"let g:neomake_logfile = '/tmp/neomake.log'
"

" For macros
"
" only rerender at the end of the macro
set lazyredraw
" repeat last macro
nnoremap Q @@

" === coc.nvim ===
set tagfunc=CocTagFunc
let g:airline#extensions#coc#enabled = 0
let g:coc_global_extensions = ['coc-json', 'coc-yaml', 'coc-python', 'coc-git', 'coc-tsserver', 'coc-tslint-plugin']
nmap <silent> <leader>cd <Plug>(coc-definition)
nmap <silent> <leader>cc <Plug>(coc-references)
nmap <silent> <leader>ci <Plug>(coc-implementation)
nmap <silent> <leader>cp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>cn <Plug>(coc-diagnostic-next)
nmap <silent> <leader>ct <Plug>(coc-type-definition)
nmap <silent> <leader>cr <Plug>(coc-rename)
nmap <silent> <leader>cs <esc>:CocRestart<CR><CR>


""===end coc.nvim settings
""
" git
" " Jump between hunks
nmap <Leader>gn <Plug>GitGutterNextHunk  " git next
nmap <Leader>gp <Plug>GitGutterPrevHunk  " git previous
nnoremap <leader>gs :Magit<CR>		 " git status
nnoremap <leader>gP :! git push<CR>      " git push
nnoremap <Leader>gb :Gblame<CR>          " git blame

nnoremap <Leader>gl :.Gbrowse<CR>	 " Open current line in the browser (i.e., get link)
vnoremap <Leader>gl :Gbrowse<CR>	 " Open visual selection in the browser
nnoremap <Leader>gsf :Gw<CR>             " git stage file
" Hunk-add and hunk-revert for chunk staging
nmap <Leader>ga <Plug>GitGutterStageHunk " git add (chunk)
nmap <Leader>gu <Plug>GitGutterUndoHunk  " git undo (chunk)

" Enable deletion of untracked files in Magit
let g:magit_discard_untracked_do_delete=1

" Use K for show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if &filetype == 'vim'
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

hi IncSearch ctermbg=LightYellow ctermfg=Red

" map f <Plug>Sneak_f
" map F <Plug>Sneak_F
" map t <Plug>Sneak_t
" map T <Plug>Sneak_T


" File explorer settings
"
"toggle netrw on the left side of the editor
let g:netrw_banner=0
let g:netrw_winsize=20
let g:netrw_liststyle=3
let g:netrw_localrmdir='rm -r'
nnoremap <leader>fe :Lexplore<CR>
"map <leader>nt :NERDTreeToggle<CR>
