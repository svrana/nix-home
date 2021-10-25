{ pkgs, lib, ... }:
let
  lua = text: ''
    lua << EOF
      ${text}
    EOF
  '';
  goimpl-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "goimpl";
    src = pkgs.fetchFromGitHub {
      owner = "edolphin-ydf";
      repo = "goimpl.nvim";
      rev = "06b19734077dbe79f6082f6e02b3ed197c444a9a";
      sha256 = "1vrhgm1z1x815zy50gmhdfzx72al5byx87r6xwnhylzvyg42wgq9";
    };
  };
  go-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "go-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "go.nvim";
      rev = "b09f8354bf6c209baf1cab52d8d0a78ed2f87af5";
      sha256 = "0mmalijp3yg5450bqp7llpa42h7aziabf7s1f9jz2vzqqc7p4q09";
    };
    configurePhase = ''
      rm Makefile
    '';
  };
  lspsaga-nvim-fork = pkgs.vimUtils.buildVimPlugin {
    name = "lspsaga-nvim-fork";
    src = pkgs.fetchFromGitHub {
      owner = "tami5";
      repo = "lspsaga.nvim";
      rev = "c884214b57fea2f5f6f04e1245a3e55cc19bbe96";
      sha256 = "0m2d0cy3bwff3frma2nyaacmxpxqssh3q6fv8813mflfc1c21r6l";
    };
  };
  lualine-nvim-fork = pkgs.vimUtils.buildVimPlugin {
    name = "lualine-nvim-fork";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "cd08f74bb7058270e9d3cd728f1ef7589dadfbee";
      sha256 = "1nrvmx9wz9jix0z0j3g907kfyw3hiikf5vr7bqxb5mcaz52x8vhj";
    };
    configurePhase = ''
      rm Makefile
    '';
  };
  nvim-tabline = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-tabline";
    src = pkgs.fetchFromGitHub {
      owner = "seblj";
      repo = "nvim-tabline";
      rev = "1c1927049a4bb0a33df384ad0187f9db8aeefbdb";
      sha256 = "1srv64rpx77swlq6ir3rxf8ycx6cl124fmkx3ajyngk3925fcl8n";
    };
  };
  luatab-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "luatab-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "alvarosevilla95";
      repo = "luatab.nvim";
      rev = "da6a8f709c2a9c133d232aa21147bcf25445a89d";
      sha256 = "13w4ryqsl3lxxxcrb2dyc0h9kql4cmx0hbhxingrc1cncwgldnj9";
    };
    configurePhase = ''
      rm Makefile
    '';
  };
  neosolarized-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "luatab-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "svrana";
      repo = "neosolarized.nvim";
      rev = "a0376ce234279c88e166e75331baf202b0039e42";
      sha256 = "18wqlc696kndnbci2gqcyhfq95w5mchxzjhnkd3bw8ddb0v27kcn";
    };
  };
in
{
  xdg.configFile."nvim/init.vim".text = lib.mkBefore ''
    let mapleader = ","
    set pumblend=10
    set scrolloff=1

    tnoremap <Esc> <C-\><C-n>

    lua << EOF
      require('svrana.globals')
    EOF
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
      goimports
      nixfmt
      nodePackages.prettier
      nodePackages.vim-language-server
      nodePackages.eslint_d
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
      nodePackages.dockerfile-language-server-nodejs
      #protocol-buffers-language-server
      rnix-lsp
      shfmt
      sumneko-lua-language-server
      luaformatter
    ];
    extraConfig = ''
      source $DOTFILES/home/nvim/init.vim
      set cursorline

      lua << EOF
      --n = require('neosolarized').setup({
      --    comment_italics = true,
      --})
      EOF
    '';
    plugins = with pkgs.vimPlugins; [
      colorbuddy-nvim
      {
        plugin = diffview-nvim;
        config = lua ''
          require('diffview').setup()
        '';
      }
      direnv-vim
      editorconfig-nvim
      # {
      #   plugin = neosolarized-nvim;
      #   config = lua ''
      #     require('neosolarized').setup({
      #         comment_italics = true,
      #     })
      #   '';
      # }
      lightspeed-nvim
      {
        plugin = go-nvim;
        config = lua ''
          vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
        '';
      }
      {
        plugin = glow-nvim;
        config = ''
          let g:glow_binary_path = "${pkgs.glow}/bin"
        '';
      }
      goimpl-nvim
      lualine-lsp-progress
      nvim-web-devicons
      plenary-nvim
      {
        plugin = null-ls-nvim;
        config = lua ''
          local null_ls = require('null-ls')
          local helpers = require('null-ls.helpers')

          local buf = {
            name = "buf",
            filetypes = { "proto" },
            method = null_ls.methods.DIAGNOSTICS,
            generator = null_ls.generator({
              command = "buf",
              args = { "lint", "--error-format", "text" },
              format = "line",
              to_stdin = true,
              check_exit_code = { 0, 100 },
              on_output = helpers.diagnostics.from_pattern(
                [[[%w/.]+:(%d+):(%d+):(.*)]],
                { "row", "col", "message" }
              ),
            })
          }
          --null_ls.register(buf)

          local prototool = helpers.make_builtin({
           method = null_ls.methods.FORMATTING,
           filetypes = { "proto" },
           generator_opts = {
             command = "prototool",
             args = {
               "format",
               "$FILENAME",
             },
             to_stdin = true,
             from_stderr = true,
           },
           factory = helpers.formatter_factory,
          })
          -- need a prototool.yaml in proto/ root for it to figure out paths
          --null_ls.register(prototool)

          null_ls.config({
            sources = {
              null_ls.builtins.diagnostics.eslint_d,
              null_ls.builtins.formatting.prettier.with({
                filetypes = { "typescript", "typescriptreact", "markdown", "json" },
              }),
              null_ls.builtins.formatting.lua_format.with({
                args = { "-i", "--no-keep-simple-function-one-line", "--no-break-after-operator",
                "--no-keep_simple_control_block_one_line", "--column-limit=130",
                "--break-after-table-lb" },
              }),
            },
            debug = true,
          })
        '';
      }
      {
        plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars));
        config = lua
          ''
            require('nvim-treesitter.configs').setup {
                highlight = {
                  enable = true,
                },
                -- see nvim-ts-context-commentstring
                context_commentstring = {
                  enable = true,
                }
              }
          '';
      }
      popup-nvim
      telescope-fzf-native-nvim
      {
        plugin = telescope-project-nvim;
        config = lua ''
          require('telescope').load_extension('project')
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
        config = lua ''
          local actions = require('telescope.actions')

          defaults =
          require('telescope').setup{
            defaults = {
             file_ignore_patterns = { 'vendor' },
             layout_strategy = 'vertical',
             set_env = { ['COLORTERM'] = 'truecolor' },
              mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<esc>"] = actions.close,
                    ["<C-u>"] = false,
                    ["<C-f>"] = actions.preview_scrolling_down,   -- remap of c-u, b/c I like emacs
                    ["<C-d>"] = actions.preview_scrolling_up, -- default
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
          require('telescope').load_extension('goimpl')
        '';
      }
      nvim-bqf
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
        config = lua ''
          -- vscode icons on lsp completion
          require('lspkind').init()
        '';
      }
      {
        plugin = lspsaga-nvim-fork;
        config = ''
          nnoremap <silent> K :Lspsaga hover_doc<CR>
          vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
          nnoremap <silent> [e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
          nnoremap <silent> ]e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>

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
      luasnip
      cmp_luasnip
      cmp-path
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      {
        plugin = nvim-cmp;
        config = lua ''
          local luasnip = require('luasnip')
          local cmp = require('cmp')
          cmp.setup {
            snippet = {
              expand = function(args)
                require('luasnip').lsp_expand(args.body)
              end,
            },
            mapping = {
              ['<C-p>'] = cmp.mapping.select_prev_item(),
              ['<C-n>'] = cmp.mapping.select_next_item(),
              ['<C-d>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.close(),
              ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              },
            },
            sources = {
              { name = 'nvim_lua' },
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
              { name = 'buffer', keyword_length = 5 },
              { name = 'path' },
            },
            experimental = {
              native_menu = false, -- default
              ghost_text = false, -- default
            },
            formatting = {
              format = require('lspkind').cmp_format(
                {
                  with_text = true,
                  menu = ({
                    path = "[path]",
                    buffer = "[buf]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[snip]",
                    nvim_lua = "[api]",
                    gh_issues = "[issue]",
                  })
                }),
            }
          }

          vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = {
                 prefix = "■ ",
                 spacing = 4,
            },
            signs = true,
            underline = false,
            update_in_insert = false,
          })
        '';
      }
      {
        plugin = nvim-lspconfig;
        config = lua ''
          local nvim_lsp = require('lspconfig')
          local protocol = require('vim.lsp.protocol')

          local diagnostic_map = function(bufnr)
            local opts = {noremap = true, silent = true}
            vim.api.nvim_buf_set_keymap(bufnr, "n", "]O", ":lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
          end

          -- Use an on_attach function to only map the following keys
          -- after the language server attaches to the current buffer
          local on_attach = function(client, bufnr)
            local function buf_set_keymap(...)
              vim.api.nvim_buf_set_keymap(bufnr, ...)
            end
            local function buf_set_option(...)
              vim.api.nvim_buf_set_option(bufnr, ...)
            end

            local uri = vim.uri_from_bufnr(bufnr)
            if uri == "file://" or uri == "file:///" or #uri < 11 then
              return {error = "invalid file", result = nil}
            end
            diagnostic_map(bufnr)

            -- Enable completion triggered by <c-x><c-o>
            buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Format prior to save if supported
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

            require('lsp_signature').on_attach()
          end

          local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

          -- Use a loop to conveniently call 'setup' on multiple servers and
          -- map buffer local keybindings when the language server attaches
          local servers = {
            'bashls',
            'yamlls',
            'rnix',
            'dockerls',
            'null-ls',
            'vimls',
          }
          for _, lsp in ipairs(servers) do
            nvim_lsp[lsp].setup({
              on_attach = on_attach,
              capabilities = capabilities,
              flags = {
                debounce_text_changes = 150,
              }
            })
          end

          require('go').setup({
            lsp_cfg = true, -- setup gopls for us
            lsp_on_attach = on_attach,
          })

          nvim_lsp.tsserver.setup({
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
            capabilities = capabilities,
          })

          local sumneko_root_path = "${pkgs.sumneko-lua-language-server}/extas"
          local sumneko_binary = "${pkgs.sumneko-lua-language-server}/bin/lua-language-server"
          local runtime_path = vim.split(package.path, ';')
          table.insert(runtime_path, "lua/?.lua")
          table.insert(runtime_path, "lua/?/init.lua")

          nvim_lsp.sumneko_lua.setup {
            on_attach = on_attach,
            capabilities = capabiltiies,
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
        '';
      }
      {
        plugin = lualine-nvim-fork;
        config = lua ''
          require('lualine').setup {
           options = {
             icons_enabled = true,
             theme = 'solarized_dark',
             section_separators = { left = '', right = '' },
             component_separators = { left = '', right = ''},
             disabled_filetypes = {}
           },
           sections = {
             lualine_a = {'mode'},
             lualine_b = {'branch'},
             lualine_c = {
               {
                 'filename',
                 file_status = true, -- displays file status (readonly status, modified status)
                 path = 1,           -- 0 = just filename, 1 = relative path, 2 = absolute path
                 'lsp_progress'
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
        config = ''
          let g:gitgutter_map_keys = 0
          nmap ]h <Plug>(GitGutterNextHunk)
          nmap [h <Plug>(GitGutterPrevHunk)
          let g:gitgutter_git_executable = "${pkgs.git}/bin/git"
        '';
      }
      minimap-vim
      {
        plugin = neogit;
        config = lua ''
          require('neogit').setup {
            disable_commit_confirmation = true,
            integrations = {
              diffview = true,
            }
          }
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

          let g:neomake_proto_maker = {
            \ 'exe': 'buf',
            \ 'args': ['lint', '--path'],
            \ 'errorformat': '%f:%l:%c:%m',
          \ }

          autocmd BufEnter,BufWritePost *.proto Neomake proto
        '';
      }
      tmux-complete-vim
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
          let g:nvim_tree_group_empty = 1
          lua << EOF
            require('nvim-tree').setup({
              -- needed for fugitive GBrowse
              disable_netrw = false,
              auto_close = true,
              hijack_cursor = true,
              tree_follow = 1,
            })
          EOF
        '';
      }
      {
        plugin = which-key-nvim;
        config = ''
          " uses NormalFloat by default
          "autocmd ColorScheme * highlight WhichKeyFloat guibg=#073642
          autocmd ColorScheme * highlight WhichKeyFloat guibg=#002b36
          lua << EOF
            wk = require("which-key")
            wk.setup{
              window = {
                border = "single"
              }
            }
            wk.register({
              ["<leader>"] = {
                c = {
                  name = "code",
                  -- buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                  d = { "<cmd>Lspsaga show_line_diagnostics<cr>", "show line Diagnostics"},
                  a = { "<cmd>Lspsaga code_action<cr>", "run Action" },
                  f = { "<cmd>Lspsaga lsp_finder<cr>", "Find usage" },
                  j = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Jump next diagnostic" },
                  p = { "<cmd>Lspsaga preview_definition<cr>", "Preview definition" },
                  r = { "<cmd>Lspsaga rename<cr>", "Rename" },
                  s = { "<cmd>lua require('lspsaga.signaturehelp').signature_help()<cr>", "Signature help" },
                  i = { "<cmd>lua require('telescope').extensions.goimpl.goimpl{}<cr>", "Implement interface" },
                  l = { "<cmd>GoFillStruct<cr>", "Fill golang struct" },
                },
                d = {
                  name = "display",
                  d = { "<cmd>DiffviewOpen<cr>", "Open diffview" },
                  h = { "<cmd>set invhls hls?<cr>", "search Highlight toggle" },
                  m = { "<cmd>MinimapToggle<cr>", "Minimap toggle" }, -- minimap-vim
                  n = { "<cmd>set relativenumber!<cr>", "Number toggle" },
                  t = { "<cmd>NvimTreeToggle<cr>", "Tree explorer" }, --nvim-tree-lua
                  g = { "<cmd>lua require('neogit').open()<cr>", "Toggle git" },
                },
                f = {
                  name = "file/fuzzy",
                  d = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers"}, -- hard for me to hit b
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
                  t = { "<cmd>lua require('neogit').open()<cr>", "Toggle git" },
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
                u = {
                  name = "quickfix",
                  c = { "<cmd>cclose<cr>", "Close" },
                  n = { "<cmd>cnext<cr>", "Next" },
                  p = { "<cmd>cprev<cr>", "Previous" },
                },
                z = { "<cmd>q!<cr>" },
                r = {
                  s = { "<cmd>lua require('svrana.repl').set_job_id()<cr>",       "Set job id" },
                  c = { "<cmd>lua require('svrana.repl').set_job_command()<cr>",  "set job Command" },
                  i = { "<cmd>lua require('svrana.repl').send_to_term()<cr>",     "send command"},
                },
              }
            })
          EOF
        '';
      }
    ];
  };
}
