set notimeout
set ttimeoutlen=100
set backspace=indent,eol,start
set nowrap
set ignorecase
set smartcase
set incsearch
set nohlsearch
set inccommand=split
set backupcopy=yes
set tags=tags,${GRUF_PROJECT}/tags
set showmatch
set backupext=.bak
set backupdir=~/.config/nvim/bak
set noerrorbells
set noshowmode
set visualbell
set ruler
set laststatus=2
set go=ia
set noequalalways
set updatetime=100
set lazyredraw
set rtp+=$RCS/nvim/vimsnips
set tagfunc=CocTagFunc
set background=dark

function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
        !cargo build --release
    endif
endfunction

" prefer leaf's typescript-vim syntax highlighting over polyglot
let g:polyglot_disabled = ['typescript']

call plug#begin('~/.local/share/nvim/plugged')

" Style
Plug 'svrana/solarize'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Vim functionality helpers
Plug 'tpope/vim-obsession'
Plug 'junegunn/vim-peekaboo'
Plug 'mhinz/vim-startify'
Plug 'unblevable/quick-scope'
" Git related plugins
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jreybert/vimagit'
Plug 'tpope/vim-rhubarb'
Plug 'stsewd/fzf-checkout.vim'
" Text processing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'christoomey/vim-sort-motion'
Plug 'vim-scripts/matchit.zip'
Plug 'justinmk/vim-sneak'
" Programming (general)
Plug 'ervandew/supertab'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'svrana/neomake'
Plug 'wellle/tmux-complete.vim'
Plug 'honza/vim-snippets'
Plug 'Chiel92/vim-autoformat'
Plug 'airblade/vim-rooter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'wsdjeg/vim-fetch'
Plug 'psf/black'
Plug 'stsewd/isort.nvim', { 'do': ':UpdateRemotePlugins' }
" File handling
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'farmergreg/vim-lastplace'
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'hynek/vim-python-pep8-indent'
Plug 'hashivim/vim-packer'
Plug 'google/vim-jsonnet'
Plug 'tmux-plugins/vim-tmux'
Plug 'LnL7/vim-nix'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-jdaddy'

call plug#end()

let mapleader = ","
let maplocalleader = ","
let g:autoswap_detect_tmux = 1
let g:markdown_composer_autostart = 0
let g:markdown_composer_browser="epiphany-browser"
let g:typescript_indent_disable = 1
" Statusline stetup
let g:airline_powerline_fonts = 1
let g:airline_section_b='' "Disable showing branch cause it crowds the filename
let g:airline_section_y='' "Disable filetype cause it's mostly useless
" Exclude overwrite statusline of list filetype
let g:airline_exclude_filetypes = ["list"]
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t' "no path,only filename
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#coc#enabled = 0
" virtualenv for neovim, has neovim python package installed
let g:python3_host_prog = expand("$WORKON_HOME/neovim3/bin/python")
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_verbose = 0
let g:peekaboo_delay=300
let g:formatterpath = ["/home/shaw/Projects/aws-infra/node_modules/.bin"]
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:SuperTabCrMapping = 0
let g:SuperTabDefaultCompletionType = '<c-n>'
let g:SuperTabClosePreviewOnPopupClose = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1
let g:go_metalinter_autosave_enabled = ['gopls', 'vet']
let g:go_list_type = "quickfix"
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:coc_global_extensions = ['coc-json', 'coc-yaml', 'coc-python', 'coc-git', 'coc-tsserver', 'coc-tslint-plugin', 'coc-snippets']
let g:netrw_banner=0
let g:netrw_winsize=20
let g:netrw_liststyle=3
let g:netrw_localrmdir='rm -r'

colorscheme solarized
highlight IncSearch ctermbg=LightYellow ctermfg=Red
highlight WhiteOnRed ctermfg=white ctermbg=red

autocmd! BufWritePre * :%s/\s\+$//e
"autocmd BufWritePre *.py execute ':Black'
autocmd BufWrite *.ts :Autoformat

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd CursorHold * silent call CocActionAsync('highlight')
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
autocmd BufWritePost,BufEnter * Neomake
autocmd FileType terraform setlocal commentstring=#%s
autocmd! FileType fzf
autocmd FileType json syntax match Comment +\/\/.\+$+

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary ctermfg=81 cterm=underline
augroup END

cmap w!! %!sudo tee > /dev/null %

noremap  <leader>w :w<CR>
noremap  <leader>q :q<CR>
noremap  <leader>e :wq<CR>
noremap  <leader>z :q!<CR>
nnoremap Q @@
nnoremap <leader>nt :tabnew<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>
nnoremap \th :set invhls hls?<CR>
nnoremap <silent> <LocalLeader>t :Files<cr>
nnoremap <silent> <LocalLeader>p :FZF $DOTFILES<cr>
nnoremap <silent> <LocalLeader>f :call FZFGitRoot()<cr>
nnoremap <silent> <LocalLeader>r :RG<cr>
nnoremap <silent> <LocalLeader>ms :ComposerStart<cr>
nnoremap <silent> <LocalLeader>hs :!home-manager -f $DOTFILES/hosts/$HOSTNAME.nix switch<cr>
nnoremap <silent> n n:call HLNext(0.4)<cr>
nnoremap <silent> N N:call HLNext(0.4)<cr>
nnoremap <leader>gs :Magit<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gl :Gbrowse<CR>
nnoremap <leader>dn :set relativenumber!<CR>

nmap <silent> <leader>cd <Plug>(coc-definition)
nmap <silent> <leader>cc <Plug>(coc-references)
nmap <silent> <leader>ci <Plug>(coc-implementation)
nmap <silent> <leader>cp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>cn <Plug>(coc-diagnostic-next
nmap <silent> <leader>ct <Plug>(coc-type-definitio)
nmap <silent> <leader>cr <Plug>(coc-rename)
nmap <silent> <leader>cs <esc>:CocRestart<CR><CR>

vnoremap <leader>jf <esc>:'<,'> !echo "`cat`" \| jq <CR>
" Open visual selection in the browser
vnoremap <Leader>gl :Gbrowse<CR>

map <c-d> <c-b>
map <m-n> :cn<CR>
map <m-p> :cp<CR>
map <m-f> :cfirst<CR>
map <m-l> :clist<CR>
map <m-o> :copen<CR>
map <c-x> :bdelete<CR>
map <c-s> :tabp<CR>
map <c-h> :tabn<CR>
map <c-c> :make<CR>
map - <C-W>-
map + <C-W>+

imap jj <ESC>

function FZFGitRoot()
    let root = trim(system('git rev-parse --show-toplevel 2>/dev/null || pwd'))
    call fzf#vim#files(root)
endfunction

" Make the 81st column standout; used by all ftplugins.
function FTPluginSetupCommands()
    call matchadd('ColorColumn', '\%81v', 100)
endfunction

function! HLNext(blinktime)
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#'.@/
    let ring = matchadd('WhiteOnRed', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#cmd#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction

function! s:show_documentation()
    if &filetype == 'vim'
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

if !empty($GRUF_CONFIG)
    source ${GRUF_CONFIG}/gruf.vimrc
end

function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
