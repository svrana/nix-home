luafile $DOTFILES/home/nvim/init.lua

set backupdir=~/.config/nvim/bak

set go=ia
set rtp+=$RCS/nvim/vimsnips
set backupcopy=yes
let g:autoswap_detect_tmux = 1

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

highlight IncSearch ctermbg=LightYellow ctermfg=Red
highlight WhiteOnRed ctermfg=white ctermbg=red

autocmd! BufWritePre * :%s/\s\+$//e

"autocmd CursorHold * silent call CocActionAsync('highlight')
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

autocmd BufRead Tiltfile set filetype=python
autocmd FileType terraform setlocal commentstring=#%s
autocmd! FileType fzf
autocmd FileType json syntax match Comment +\/\/.\+$+

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary gui=underline ctermfg=81 cterm=underline
augroup END

cmap w!! %!sudo tee > /dev/null %

noremap! <leader>w <ESC>:w<CR>
noremap! <leader>q <ESC>:q<CR>
noremap! <leader>e <ESC>:wq<CR>
noremap! <leader>z <ESC>:q!<CR>
nnoremap Q @@
nnoremap \th :set invhls hls?<CR>
nnoremap <silent> n n:call HLNext(0.4)<cr>
nnoremap <silent> N N:call HLNext(0.4)<cr>
vnoremap <leader>jf <esc>:'<,'> !echo "`cat`" \| jq <CR>

inoremap <c-e> <esc>$a
inoremap <c-a> <esc>^i
map <c-d> <c-b>
map <m-n> :cn<CR>
map <m-p> :cp<CR>
map <m-f> :cfirst<CR>
map <m-l> :clist<CR>
map <m-o> :copen<CR>
map <c-x> :bdelete<CR>
map <c-s> :tabp<CR>
map <c-h> :tabn<CR>
"map <c-c> :make<CR>
map - <C-W>-
map + <C-W>+

imap jj <ESC>

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

if !empty($GRUF_CONFIG)
    source ${GRUF_CONFIG}/gruf.vimrc
end

" https://github.com/neoclide/coc-tsserver/issues/244
function! OpenZippedFile(f)
  " get number of new (empty) buffer
  let l:b = bufnr('%')
  " construct full path
  let l:f = substitute(a:f, '.zip/', '.zip::', '')
  let l:f = substitute(l:f, '/zip:', 'zipfile:', '')

  " swap back to original buffer
  b #
  " delete new one
  exe 'bd! ' . l:b
  " open buffer with correct path
  sil exe 'e ' . l:f
  " read in zip data
  call zip#Read(l:f, 1)
endfunction

au BufReadCmd /zip:*.yarn/cache/*.zip/* call OpenZippedFile(expand('<afile>'))

" Courtesy Takuya @
" https://blog.inkdrop.app/how-to-set-up-neovim-0-5-modern-plugins-lsp-treesitter-etc-542c3d9c9887
function MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '

    if i + 1 == tabpagenr()
      let s .= '%#TabLineSep#'
    elseif i + 2 == tabpagenr()
      let s .= '%#TabLineSep2#'
    else
      let s .= ''
    endif
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999X'
  endif

  return s
endfunction

function MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let name = bufname(buflist[winnr - 1])
  let label = fnamemodify(name, ':t')
  return len(label) == 0 ? '[No Name]' : label
endfunction

set tabline=%!MyTabLine()
set completeopt=menuone,noselect
highlight TelescopeMatching guifg=orange
""colorscheme NeoSolarized
