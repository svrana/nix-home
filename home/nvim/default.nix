{ pkgs, lib, ... }:
{
  xdg.configFile."nvim/init.vim".text = lib.mkBefore ''
    let mapleader = ","
  '';

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;
    extraPython3Packages = (ps: with ps; [ pynvim jedi ]);
    extraPackages = with pkgs; [
      buf
      code-minimap
      gopls
      nixfmt
      nodePackages.vim-language-server
      nodePackages.eslint_d
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
      nodePackages.json-server
      nodePackages.dockerfile-language-server-nodejs
      rnix-lsp
      shfmt
      sumneko-lua-language-server
    ];
    extraConfig = ''
      source $DOTFILES/home/nvim/init.vim
    '';
    plugins = with pkgs.vimPlugins; [
      diffview-nvim
      direnv-vim
      editorconfig-nvim
      glow-nvim
      nvim-web-devicons
      plenary-nvim
      {
        plugin = null-ls-nvim;
        config = ''
          lua << EOF
          local null_ls = require('null-ls')
          local methods = require('null-ls.methods')
          local helpers = require('null-ls.helpers')

          generator_opts = {
              command = "buf",
              args = { "lint", "--error-format", "text", "--path", "$FILENAME" },
              format = "line",
              to_stderr = true,
              check_exit_code = function(code)
                 return code <= 1
              end,
              on_output = helpers.diagnostics.from_pattern(
                 [[[%w/.]+:(%d+):(%d+):(.*)]],
                 { "row", "col", "message" }
              ),
          }

          local buflint = {
            name = "buf",
            filetypes = { "proto" },
            method = methods.DIAGNOSTICS,
            generator = null_ls.generator(generator_opts),
          }
          -- filetypes not set error?
          -- null_ls.register(buflint)

          local prototool = helpers.make_builtin({
            method = methods.FORMATTING,
            filetypes = { "proto" },
            generator_opts = {
              command = "prototool",
              args = {
                "format",
                "$FILENAME",
                "--fix",
              },
              to_stdin = true,
            },
            factory = helpers.formatter_factory,
          })
          --null_ls.register(prototool)

          null_ls.config({
            sources = {
              null_ls.builtins.diagnostics.eslint_d,
              null_ls.builtins.formatting.prettier.with({
                filetypes = { "typescript", "typescriptreact", "markdown", "json" },
              }),
            },
            debug = false,
          })
          EOF
        '';
      }
      {
        plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars));
        config = ''
          lua << EOF
             require('nvim-treesitter.configs').setup {
                 ensure_installed = "maintained",
                 highlight = {
                   enable = true,
                 },
                 -- see nvim-ts-context-commentstring
                 context_commentstring = {
                   enable = true,
                 }
               }
          EOF
        '';
      }
      popup-nvim
      telescope-fzf-native-nvim
      {
        plugin = telescope-project-nvim;
        config = ''
          lua << EOF
            require('telescope').load_extension('project')
          EOF
        '';
      }
      {
        plugin = vim-rooter;
        config = ''
          let g:rooter_cd_cmd = 'lcd'";
          let g:rooter_silent_chdir = 1
        '';
      }
      {
        plugin = telescope-nvim;
        config = ''
          lua << EOF
          local actions = require('telescope.actions')

          require('telescope').setup{
            defaults = {
             layout_strategy = 'vertical',
             set_env = { ['COLORTERM'] = 'truecolor' },
              mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<esc>"] = actions.close,
                    ["<C-u>"] = false,
                },
                n = {
                  ["q"] = actions.close
                },
              },
            },
            pickers = {
              buffers = {
                sort_lastused = true,
                theme = "dropdown",
                previewer = false,
                mappings = {
                  i = {
                    ["<c-d>"] = actions.delete_buffer,
                  },
                  n = {
                    ["<c-d>"] = actions.delete_buffer,
                  }
                }
              }
            },
            extensions = {
              fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = false, -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
              }
            }
          }
          require('telescope').load_extension('fzf')
          EOF
        '';
      }
      {
        plugin = nvim-colorizer-lua;
        config = ''
          set termguicolors
          lua << EOF
            require('colorizer').setup();
          EOF
        '';
      }
      {
        plugin = lspkind-nvim;
        config = ''
          lua << EOF
            require('lspkind').init()
          EOF
        '';
      }
      {
        plugin = lsp-colors-nvim;
        config = ''
          lua << EOF
          require('lsp-colors').setup({
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
          vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>

          lua << EOF
          require('lspsaga').init_lsp_saga({
            error_sign = '',
            warn_sign = '',
            hint_sign = '',
            infor_sign = '',
            border_style = "round",
          })
          EOF
        '';
      }
      lsp_signature-nvim
      {
        plugin = nvim-compe;
        config = ''
          lua << EOF
          require('compe').setup {
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
              --max_width = 120,
              --min_width = 60,
              --max_height = math.floor(vim.o.lines * 0.3),
              --min_height = 1,
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

              vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)

              if not vim.api.nvim_buf_is_loaded(bufnr) then
                return
              end

              -- don't mutate the original diagnostic because it would interfere with
              -- code action (and probably other stuff, too)
              local prefixed_diagnostics = vim.deepcopy(diagnostics)
              for i, v in ipairs(diagnostics) do
                diagnostics[i].message = string.format("%s: %s", v.source, v.message)
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
          local protocol = require('vim.lsp.protocol')

          -- Use an on_attach function to only map the following keys
          -- after the language server attaches to the current buffer
          local on_attach = function(client, bufnr)
            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

            -- Enable completion triggered by <c-x><c-o>
            buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Format prior to save if supported
            -- TODO: add ability to disable this on the fly.
            if client.resolved_capabilities.document_formatting then
               vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
             end

            -- Mappings.
            local opts = { noremap=true, silent=true }

            -- See `:help vim.lsp.*` for documentation on any of the below functions
            buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
            buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
            buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
            buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap('n', '<leader>cn', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

            --buf_set_keymap('n', '<leader>cd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
            --buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            --buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
            --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
            --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
            --buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            --buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            -- this is nice
            --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
            --buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

            require('lsp_signature').on_attach({
              bind = true,
              toggle_key='<C-x>'
            })
          end

          -- Use a loop to conveniently call 'setup' on multiple servers and
          -- map buffer local keybindings when the language server attaches
          local servers = {
            'gopls',
            'bashls',
            'yamlls',
            'rnix',
            'dockerls',
            'jsonls',
            'null-ls',
            'vimls',
          }
          for _, lsp in ipairs(servers) do
            nvim_lsp[lsp].setup({
              on_attach = on_attach,
              flags = {
                debounce_text_changes = 150,
              }
            })
          end

          nvim_lsp.tsserver.setup {
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
            flags = {
                debounce_text_changes = 150,
            },
            -- let null-ls (w/ prettier) handle formatting. This stops lsp
            -- from prompting which lsp client should handle the formatting.
            on_attach = function(client)
                client.resolved_capabilities.document_formatting = false
                client.resolved_capabilities.document_range_formatting = false
                on_attach(client)
            end,
          }

          local sumneko_root_path = "${pkgs.sumneko-lua-language-server}/extas"
          local sumneko_binary = "${pkgs.sumneko-lua-language-server}/bin/lua-language-server"
          local runtime_path = vim.split(package.path, ';')
          table.insert(runtime_path, "lua/?.lua")
          table.insert(runtime_path, "lua/?/init.lua")

          require('lspconfig').sumneko_lua.setup {
            on_attach = on_attach,
            flags = {
              debounce_text_changes = 150,
            },
            cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
            settings = {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT',
                  -- Setup your lua path
                  path = runtime_path,
                },
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = {'vim'},
                },
                workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                  enable = false,
                },
              },
            },
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
      {
        plugin = vim-peekaboo;
        config = "let g:peekaboo_delay=300";
      }
      {
        plugin = vim-fugitive;
        config = ''
          " Open visual selection in the browser (with rhubarb handler for github)
          xnoremap <silent> <Leader>gh :'<,'>GBrowse<CR>
        '';
      }
      # for fugitive, opening github links in browser
      rhubarb
      {
        plugin = vim-gitgutter;
        config = ''let g:gitgutter_git_executable = "${pkgs.git}/bin/git"'';
      }
      minimap-vim
      {
        plugin = neogit;
        config = ''
          lua << EOF
            require('neogit').setup {
              disable_commit_confirmation = true,
              integrations = {
                diffview = true,
              }
            }
          EOF
        '';
      }
      vim-surround
      nvim-ts-context-commentstring
      vim-commentary
      vim-sort-motion
      # vim-sneak
      {
        plugin = neomake; # move to null-ls
        config = ''
          let g:neomake_verbose = 0

          function C1GolangCITweak()
              if (expand("$C1") == FindRootDirectory())
                  let g:neomake_go_golangci_lint_exe="lint.sh"
                  let g:neomake_go_golangci_lint_args="run --fast --modules-download-mode=vendor --out-format=line-number --print-issued-lines=false --timeout 3m0s"
                  let g:neomake_go_golangci_lint_cwd="$C1"
              endif
          endfunction

          autocmd BufNewFile,BufRead,BufEnter *.go call C1GolangCITweak()
        '';
      }
      tmux-complete-vim
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
      quick-scope
      vim-fetch
      fzfWrapper
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
        '';
      }
      vim-tmux
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
        '';
      }
      {
        plugin = which-key-nvim;
        config = ''
          lua << EOF
            wk = require("which-key")
            wk.setup{}
            wk.register({
              ["<leader>"] = {
                c = {
                  name = "code",
                  -- buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
                  -- buf_set_keymap('n', '<leader>cd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
                  a = { "<cmd>Lspsaga code_action<cr>", "run Action" },
                  -- d = { taken by buffer map lsp }
                  f = { "<cmd>Lspsaga lsp_finder<cr>", "Find usage" },
                  j = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Jump next diagnostic" },
                  p = { "<cmd>Lspsaga preview_definition<cr>", "Preview definition" },
                  r = { "<cmd>Lspsaga rename<cr>", "Rename" },
                  s = { "<cmd>lua require('lspsaga.signaturehelp').signature_help()<cr>", "Signature help" },
                },
                d = {
                  name = "display",
                  h = { "<cmd>set invhls hls?<cr>", "search Highlight toggle" },
                  m = { "<cmd>MinimapToggle<cr>", "Minimap toggle" }, -- minimap-vim
                  n = { "<cmd>set relativenumber!<cr>", "Number toggle" },
                  t = { "<cmd>NvimTreeToggle<cr>", "Tree explorer" }, --nvim-tree-lua
                },
                f = {
                  name = "file/fuzzy",
                  b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers"},
                  f = { "<cmd>lua require('svrana.telescope').project_files()<cr>", "Find" },
                  h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Help" },
                  n = { "<cmd>lua require('svrana.telescope').dots()<cr>", "dotfiles" },
                  p = { "<cmd>lua require('telescope').extensions.project.project({})<cr>", "Project change" },
                  r = { "<cmd>Rg<cr>", "Search file contents" }, -- fzf
                  s = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Search file contents" },
                  z = { "<cmd>lua require('telescope.builtin').git_branches()<cr>", "brancheZ" },
                },
                g = {
                  name = "git",
                  t = { "<cmd>lua require('neogit').open({ kind='vsplit' })<cr>", "Toggle git" },
                  h = { "<cmd>GBrowse<cr>", "gitHub view" }, -- fugitive
                  b = { "<cmd>Git blame<cr>", "Blame" }, -- fugitive
                },
                h = {
                  name = "home-manager",
                  s = { "<cmd>make home<cr>", "Switch" },
                },
                m = {
                  name = "markdown",
                  s = { "<cmd>ComposerStart<cr>", "Start composer" }, --vim-markdown-composer
                  g = { "<cmd>Glow<cr>", "Glow" }, -- glow-nvim
                },
                n = {
                  name = "new",
                  t = { "<cmd>tabnew<cr>", "Tab" },
                },
                s = {
                  name = "source",
                  v = { "<cmd>source $XDG_CONFIG_HOME/nvim/init.vim<cr>", "Vimrc" },
                },
                w = { "<cmd>w<cr>", "Write file" },
                q = { "<cmd>q<cr>", "Quit" },
                z = { "<cmd>q!<cr>" },
              }
            })
          EOF
        '';
      }
    ];
  };
}