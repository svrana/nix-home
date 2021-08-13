{ pkgs, lib, ... }:
let
  gopls = "${pkgs.gopls}/bin/gopls";
  initialConfig = ''

    " hack, hack, hack:  this is the first config written to init.vim, but I need these
    " defined before I start using them below..
    let mapleader = ","
    let maplocalleader = ","
  '';
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;
    coc = {
      enable = true;
      settings = {
        languageserver = {
          golang = {
            command = gopls;
            rootPatterns = [ "go.mod" ".git/" ];
            filetypes = [ "go" ];
          };
          nix = {
            command = "rnix-lsp";
            filetypes = [ "nix" ];
          };
        };
      };
    };
    extraPython3Packages = (ps: with ps; [ pynvim jedi ]);
    extraPackages = [
      pkgs.shfmt
      pkgs.nixfmt
    ];
    extraConfig = ''
        source $DOTFILES/home/nvim/init.vim
    '';
    #prototool', { 'rtp': 'vim/prototool' }
    plugins = with pkgs.vimPlugins; [
       nvim-web-devicons
       plenary-nvim
       {
         plugin = vim-colors-solarized;
         config = ''colorscheme solarized ${initialConfig} '';
       }
       {
        plugin = glow-nvim;
        config = "nnoremap <silent><LocalLeader>mg :Glow<CR>";
       }
       {
          plugin = vim-airline;
          config = ''
            let g:airline_powerline_fonts = 1
            let g:airline_section_b="" "Disable showing branch cause it crowds the filename
            let g:airline_section_y="" "Disable filetype cause it's mostly useless
            "let g:airline#extensions#tabline#fnamemod = ':t' "no path,only filename
            let g:airline_skip_empty_sections = 1
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#formatter = 'unique_tail'
            let g:airline#extensions#tabline#tab_min_count = 2
            let g:airline#extensions#tabline#show_tab_type = 0
            let g:airline#extensions#tabline#show_close_button = 0
            let g:airline#extensions#tabline#show_tab_nr = 0
            let g:airline#extensions#tabline#show_splits = 0
            let g:airline#extensions#tabline#show_buffers = 0
            let g:airline#extensions#tabline#buffer_min_count = 2
            let g:airline#extensions#virtualenv#enabled = 1
            let g:airline#extensions#coc#enabled = 0
          '';
       }
       vim-airline-themes
       vim-jsx-typescript
       vim-obsession
       {
         plugin = vim-peekaboo;
         config = "let g:peekaboo_delay=300";
       }
       quick-scope
       {
         plugin = vim-fugitive;
         config = ''
          nnoremap <silent><LocalLeader>gb :Git blame<CR>
          " Open visual selection in the browser (with rhubarb handler for github)
          xnoremap <silent> <LocalLeader>gh :'<,'>GBrowse<CR>
          nnoremap <silent> <LocalLeader>gh :GBrowse<CR>
         '';
       }
       rhubarb
       {
         plugin = vim-gitgutter;
         config = ''let g:gitgutter_git_executable = "${pkgs.git}/bin/git"'';
       }
       {
         plugin = vimagit;
         config = ''nnoremap <silent> <LocalLeader>gt :Magit<CR>'';
       }
       vim-surround
       {
         plugin = tcomment_vim;
         #Couldn't get vim-commentary to work with ts/react, but tcomment works with this line:
         config = "let g:tcomment#filetype#guess_typescriptreact = 1";
       }
       #vim-commentary
       vim-sort-motion
       vim-sneak
       {
         plugin = supertab;
         config = ''
            let g:SuperTabCrMapping = 0
            let g:SuperTabDefaultCompletionType = '<c-n>'
            let g:SuperTabClosePreviewOnPopupClose = 1
         '';
       }
       {
        plugin = coc-nvim;
        config = ''
          autocmd CursorHold * silent call CocActionAsync('highlight')

          function! s:show_documentation()
            if (index(['vim','help'], &filetype) >= 0)
              execute 'h '.expand('<cword>')
            elseif (coc#rpc#ready())
              call CocActionAsync('doHover')
            else
              execute '!' . &keywordprg . " " . expand('<cword>')
            endif
          endfunction

          nnoremap <silent> K :call <SID>show_documentation()<CR>
          " Show signature help on placeholder jump
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

          nmap <silent> <leader>cd <Plug>(coc-definition)
          nmap <silent> <leader>cc <Plug>(coc-references)
          nmap <silent> <leader>ci <Plug>(coc-implementation)
          nmap <silent> <leader>cp <Plug>(coc-diagnostic-prev)
          nmap <silent> <leader>cn <Plug>(coc-diagnostic-next
          nmap <silent> <leader>ct <Plug>(coc-type-definition)
          nmap <silent> <leader>cr <Plug>(coc-rename)
          nmap <silent> <leader>cl <esc>(coc-list-location)<CR><CR>
          nmap <silent> <leader>cs <esc>:CocRestart<CR><CR>
        '';
       }
       coc-json
       coc-yaml
       coc-python
       coc-git
       coc-tsserver
       coc-tslint-plugin
       {
          plugin = coc-snippets;
          config = ''
            vmap <C-j> <Plug>(coc-snippets-select)
            " Use <C-j> for jump to next placeholder, it's default of coc.nvim
            let g:coc_snippet_next = '<c-j>'
            " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
            let g:coc_snippet_prev = '<c-k>'
            " Use <C-j> for both expand and jump (make expand higher priority.)
            imap <C-j> <Plug>(coc-snippets-expand-jump)
            " Use <leader>sn for convert visual selected code to snippet (i.e., snippet new)
            xmap <leader>sn  <Plug>(coc-convert-snippet)
          '';
       }
       #coc-protobuf
       {
         plugin = neoformat;
         config = ''
            augroup fmt
              autocmd!
              autocmd BufWritePre *.tsx undojoin | Neoformat
              autocmd BufWritePre *.ts undojoin | Neoformat
              autocmd BufWritePre *.js undojoin | Neoformat
              autocmd BufWritePre *.jsx undojoin | Neoformat
            augroup END
         '';
       }
       {
         plugin = neomake;
         config = ''
           let g:neomake_javascript_enabled_makers = ['eslint']
           let g:neomake_verbose = 0

           function C1GolangCITweak()
               if (expand("$C1") == FindRootDirectory())
                   let g:neomake_go_golangci_lint_exe="lint.sh"
                   let g:neomake_go_golangci_lint_args="run --fast --modules-download-mode=vendor --out-format=line-number --print-issued-lines=false --timeout 3m0s"
                   let g:neomake_go_golangci_lint_cwd="$C1"
               endif
           endfunction

           autocmd BufNewFile,BufRead,BufEnter *.go call C1GolangCITweak()
           autocmd BufWritePost,BufAdd * Neomake
         '';
       }
       tmux-complete-vim
       vim-snippets
       vim-autoformat
       {
         plugin = vim-rooter;
         config = "let g:rooter_cd_cmd = 'lcd'";
       }
       {
         plugin = vim-go;
         config = ''
           let g:go_fmt_command = "goimports"
           let g:go_fmt_autosave = 1
           let g:go_metalinter_autosave_enabled = ['gopls', 'vet']
           let g:go_list_type = "quickfix"
           let g:go_def_mode='gopls'
           let g:go_info_mode='gopls'
           " disable mapping of K to godoc. We remap for coc for the same purpose but prettier
           let g:go_doc_keywordprg_enabled = 0

           " run :GoBuild or :GoTestCompile based on the go file
           function! s:build_go_files()
              let l:file = expand('%')
               if l:file =~# '^\f\+_test\.go$'
                   call go#cmd#Test(0, 1)
               elseif l:file =~# '^\f\+\.go$'
                   call go#cmd#Build(0)
               endif
           endfunction
          '';
       }
       vim-fetch
       {
         plugin = fzfWrapper;
         config = ''
          nnoremap <silent> <LocalLeader>ff :Files<cr>
          nnoremap <silent> <LocalLeader>fb :Buffers<cr>
          " root
          nnoremap <silent> <LocalLeader>fr :GFiles<cr>
          " nix configs
          nnoremap <silent> <LocalLeader>fn :FZF $DOTFILES<cr>

          nnoremap <silent> <LocalLeader>sf :Rg<cr>
         '';
       }
       fzf-vim
       {
         plugin = vim-polyglot;
         # delay loading until after vim-go or polyglot will override the nix patched
         # vim bin path in the vim-go plugin.
         optional = true;
         config = ''
           let g:polyglot_disabled = ['typescript']
           packadd vim-polyglot
         '';
       }
       vim-lastplace
       {
         plugin = vim-markdown-composer;
         config = ''
           let g:markdown_composer_autostart = 0
           let g:markdown_composer_browser="firefox"

           nnoremap <silent> <LocalLeader>ms :ComposerStart<cr>
         '';
       }
       vim-python-pep8-indent
       vim-packer
       vim-jsonnet
       vim-tmux
       vim-nix
       typescript-vim
       # {
       #   plugin = nvim-tree-lua;
       #   config = ''
       #     let g:nvim_tree_ignore = [ '.git', 'node_modules' ]
       #     let g:nvim_tree_auto_open = 1
       #     let g:nvim_tree_tab_open = 1
       #     let g:nvim_tree_auto_close = 1
       #     let g:nvim_tree_follow = 1
       #
       #     nnoremap <silent><leader>ft :NvimTreeToggle<CR>
       #   '';
       # }
       {
         plugin = vim-nerdtree-tabs;
         config = ''
            map <silent> <leader>ft <plug>NERDTreeTabsToggle<CR>
         '';
       }
       {
         plugin = nerdtree-git-plugin;
         config = ''
           let g:NERDTreeGitStatusConcealBrackets = 1
         '';
       }
       {
        plugin = nerdtree;
        config = ''
          let NERDTreeMinimalUI = 1
          let NERDTreeStatusline=""
        '';
      }
    ];
  };

  # xdg.configFile."nvim/init.vim" = lib.mkMerge [
  #   (lib.mkBefore {
  #     text = ''
  #       " prepend some config
  #     '';
  #   })
  #   (lib.mkAfter {
  #     text = ''
  #       " append some config
  #     '';
  #   })
  # ];
}
