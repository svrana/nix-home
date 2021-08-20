{ pkgs, lib, ... }:
let
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
    extraPython3Packages = (ps: with ps; [ pynvim jedi ]);
    extraPackages = [
      pkgs.shfmt
      pkgs.nixfmt
      pkgs.gopls
      pkgs.nodePackages.bash-language-server
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.yaml-language-server
      pkgs.nodePackages.json-server
      pkgs.nodePackages.dockerfile-language-server-nodejs
    ];
    extraConfig = ''
        source $DOTFILES/home/nvim/init.vim
    '';
    #prototool', { 'rtp': 'vim/prototool' }
    plugins = with pkgs.vimPlugins; [
       {
        plugin = nvim-web-devicons;
        config = ''colorscheme NeoSolarized ${initialConfig} '';
        #config = ''${initialConfig} '';
       }
       plenary-nvim
       {
        plugin = glow-nvim;
        config = "nnoremap <silent><LocalLeader>mg :Glow<CR>";
       }
       {
         plugin = nvim-treesitter;
         config = ''
          lua << EOF
          require'nvim-treesitter.configs'.setup {
            ensure_installed = "maintained",
            highlight = {
              enable = false,
            },
          }
          local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
          parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
          EOF
         '';
       }
       {
         plugin = telescope-nvim;
         config = ''
           nnoremap <silent>fh <cmd>Telescope help_tags<cr>
           " default bindings overlap the emacs command line bindings,
           "nnoremap <silent> <leader>ff <cmd>Telescope find_files<cr>
           " too slow
           " nnoremap <silent> ;r <cmd>Telescope live_grep<cr>
           "nnoremap <silent> <leader>fb <cmd>Telescope buffers<cr>

           lua << EOF
           local actions = require('telescope.actions')
           require('telescope').setup{
             defaults = {
               mappings = {
                 n = {
                   ["q"] = actions.close
                 },
               },
             }
           }
           EOF
         '';
       }
       {
         plugin = lsp-colors-nvim;
         config = ''
         lua << EOF
         require("lsp-colors").setup({
           Error = "#db4b4b",
           Warning = "#e0af68",
           Information = "#0db9d7",
           Hint = "#10B981"
         })
         EOF
         '';
       }
       {
       plugin = lspsaga-nvim;
       config = ''
         nnoremap <silent> K :Lspsaga hover_doc<CR>
         nnoremap <silent><leader>cr :Lspsaga rename<CR>
         nnoremap <silent><leader>cp :Lspsaga preview_definition<CR>
         nnoremap <silent><leader>cf :Lspsaga lsp_finder<CR>
         nnoremap <silent><leader>ca :Lspsaga code_action<CR>
         vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
         lua << EOF
         local saga = require 'lspsaga'
         saga.init_lsp_saga {
           error_sign = '',
           warn_sign = '',
           hint_sign = '',
           infor_sign = '',
           border_style = "round",
         }
         EOF
       '';
       }
       lsp_signature-nvim
       {
         plugin = nvim-compe;
         config = ''
          lua << EOF
          require'compe'.setup {
            enabled = true;
            autocomplete = true;
            debug = false;
            min_length = 1;
            preselect = 'enable';
            throttle_time = 80;
            source_timeout = 200;
            resolve_timeout = 800;
            incomplete_delay = 400;
            max_abbr_width = 100;
            max_kind_width = 100;
            max_menu_width = 100;
            documentation = {
              border = { ''', ''' ,''', ' ', ''', ''', ''', ' ' }, -- the border option is the same as `|help nvim_open_win|`
              winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
              max_width = 120,
              min_width = 60,
              max_height = math.floor(vim.o.lines * 0.3),
              min_height = 1,
            };
            source = {
              path = true;
              buffer = true;
              nvim_lsp = true;
              nvim_lua = true;
              tmux = true;
            };
          }

          local t = function(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
          end

          local check_back_space = function()
              local col = vim.fn.col('.') - 1
              if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                  return true
              else
                  return false
              end
          end

          -- Use (s-)tab to:
          --- move to prev/next item in completion menuone
          --- jump to prev/next snippet's placeholder
          _G.tab_complete = function()
            if vim.fn.pumvisible() == 1 then
              return t "<C-n>"
            elseif check_back_space() then
              return t "<Tab>"
            else
              return vim.fn['compe#complete']()
            end
          end
          _G.s_tab_complete = function()
            if vim.fn.pumvisible() == 1 then
              return t "<C-p>"
            else
              return t "<S-Tab>"
            end
          end

          vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
          vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
          vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
          vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

          --This line is important for auto-import
          vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
          vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })
          EOF

          lua << EOF
          -- show the source of the diagnostic, useful if you have more than
          -- one lsp server for the filetype, i.e., a linter as well as a compiler
          -- (typescript)
          vim.lsp.handlers["textDocument/publishDiagnostics"] =
            function(_, _, params, client_id, _)
              local config = { -- your config
                underline = true,
                virtual_text = {
                  prefix = "■ ",
                  spacing = 4,
                },
                signs = true,
                update_in_insert = false,
              }
              local uri = params.uri
              local bufnr = vim.uri_to_bufnr(uri)

              if not bufnr then
                return
              end

              local diagnostics = params.diagnostics

              for i, v in ipairs(diagnostics) do
                diagnostics[i].message = string.format("%s: %s", v.source, v.message)
              end

              vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)

              if not vim.api.nvim_buf_is_loaded(bufnr) then
                return
              end

              vim.lsp.diagnostic.display(diagnostics, bufnr, client_id, config)
          end
          EOF
         '';
       }
       {
       plugin = nvim-lspconfig;
       config = ''
        lua << EOF
        local nvim_lsp = require('lspconfig')
        local protocol = require'vim.lsp.protocol'

        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
          local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
          local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

          --Enable completion triggered by <c-x><c-o>
          buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings.
          local opts = { noremap=true, silent=true }

          -- See `:help vim.lsp.*` for documentation on any of the below functions
          buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
          buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          --buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
          buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
          buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
          buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
          buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
          buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
          buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
          --buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
          buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
          buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
          buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
          buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

          require "lsp_signature".on_attach({
            bind = true,
            toggle_key='<C-x>'
          })

          protocol.CompletionItemKind = {
            '', -- Text
            '', -- Method
            '', -- Function
            '', -- Constructor
            '', -- Field
            '', -- Variable
            '', -- Class
            'ﰮ', -- Interface
            '', -- Module
            '', -- Property
            '', -- Unit
            '', -- Value
            '', -- Enum
            '', -- Keyword
            '﬌', -- Snippet
            '', -- Color
            '', -- File
            '', -- Reference
            '', -- Folder
            '', -- EnumMember
            '', -- Constant
            '', -- Struct
            '', -- Event
            'ﬦ', -- Operator
            '', -- TypeParameter
           }
        end

        -- Use a loop to conveniently call 'setup' on multiple servers and
        -- map buffer local keybindings when the language server attaches
        local servers = { 'gopls', 'bashls', 'yamlls', 'rnix', 'dockerls'}
        for _, lsp in ipairs(servers) do
          nvim_lsp[lsp].setup {
            on_attach = on_attach,
            flags = {
              debounce_text_changes = 150,
            }
          }
        end

        nvim_lsp.tsserver.setup {
          on_attach = on_attach,
          filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
          flags = {
              debounce_text_changes = 150,
          }
        }
        EOF
       '';
       }
       {
         plugin = lualine-nvim;
         config = ''
         lua << EOF
           require('lualine').setup {
            options = {
              icons_enabled = true,
              theme = 'solarized_dark',
              section_separators = {'', ''},
              component_separators = {'', ''},
              disabled_filetypes = {}
            },
            sections = {
              lualine_a = {'mode'},
              lualine_b = {'branch'},
              lualine_c = {
                {
                  'filename',
                  file_status = true, -- displays file status (readonly status, modified status)
                  path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
                }
              },
              lualine_x = {
                {
                  'diagnostics',
                  sources = {"nvim_lsp"},
                  symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '}
                },
                'encoding',
                'filetype'
              },
              lualine_y = {'progress'},
              lualine_z = {'location'}
            },
            tabline = {},
            extensions = {'nvim-tree', 'fugitive', 'fzf'}
           }
         EOF
          '';
       }
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
       {
         plugin = minimap-vim;
         config = ''nnoremap <silent> <LocalLeader>fm :MinimapToggle<cr>'';
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
       #vim-autoformat
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
           let g:go_info_mode='gopls'
           " let lsp handle ctrl-]
           let g:go_def_mapping_enabled=0
           " pin our versions with nix
           let g:go_get_update=0
           " disable mapping of K to godoc
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
          nnoremap <silent> <leader>ff :Files<cr>
          nnoremap <silent> <leader>fb :Buffers<cr>
          " root
          nnoremap <silent> <leader>fr :GFiles<cr>
          " nix configs
          nnoremap <silent> <leader>fn :FZF $DOTFILES<cr>

          nnoremap <silent> <leader>fs :Rg<cr>
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
       {
         plugin = nvim-tree-lua;
         config = ''
           let g:nvim_tree_ignore = [ '.git', 'node_modules' ]
           let g:nvim_tree_gitignore = 1
           "let g:nvim_tree_lsp_diagnostics = 1
           "let g:nvim_tree_auto_open = 1
           " unforunately takes control of the cursor too
           " let g:nvim_tree_tab_open = 1
           let g:nvim_tree_group_empty = 1
           let g:nvim_tree_auto_close = 1
           " needed for fugitive GBrowse
           let g:nvim_tree_disable_netrw = 0
           let g:nvim_tree_follow = 1

           nnoremap <silent><leader>ft :NvimTreeToggle<CR>
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
