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
      rev = "0bc7abace67efb0eabc06b6a2ad11da14f43e8a6";
      sha256 = "x6d2W3Da8uCgELfmjy+tqp9l4FQvtCgIsDmJVFCcNyc=";
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
      rev = "4c9f232376fcf7d581e137a4f809527e41e4176c";
      sha256 = "sha256-VQeAS7j/XsWT+ZR1vvcWWOx50B3olIOFweZ89PiT3J4=";
    };
  };
  lualine-nvim-pin = pkgs.vimUtils.buildVimPlugin {
    name = "lualine-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "1e3cfc691f7faf24ca819770754056eb13a8f7ad";
      sha256 = "akyL/V7t4n3B/3+LNjhWRvGY1JRU6rN5d1A7HSFdIEw=";
      # this works too v--
      #rev = "d2e0ac595b8e315b454f4384edb2eba7807a8401";
      #sha256 = "akyL/V7t4n3B/3+LNjhWRvGY1JRU6rN5d1A7HSFdIEw=";
      #sha256 = "7XIx0ElpCX0e8R2xPp3K7r6jaIRWTnd55PgWFkh2mM1=";
      # these work v--
      #rev = "016a20711ee595a11426f9c1f4ab3e04967df553";
      #sha256 = "7F6ci4QwTQNggkWVFOjInboQ8tXpGijZ6JAACqtyeXg=";
    };
    configurePhase = ''
      rm Makefile
    '';
  };

  # neosolarized-nvim = pkgs.vimUtils.buildVimPlugin {
  #   name = "neosolarized-nvim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "svrana";
  #     repo = "neosolarized.nvim";
  #     rev = "a0376ce234279c88e166e75331baf202b0039e42";
  #     sha256 = "18wqlc696kndnbci2gqcyhfq95w5mchxzjhnkd3bw8ddb0v27kcn";
  #   };
  # };
in
{
  xdg.configFile."nvim/init.vim".text = lib.mkBefore ''
    let mapleader = ","
    set pumblend=10
    set foldmethod=marker

    tnoremap <Esc> <C-\><C-n>
    au TermOpen term://* startinsert
    au InsertEnter * setlocal nocursorline
    au InsertLeave * setlocal cursorline

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
      gotools
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
      #haskellPackages.haskell-language-server
      #haskellPackages.ormolu
    ];
    extraConfig = ''
      source $DOTFILES/home/nvim/init.vim

      "set tabline=%!MyTabLine()

      lua << EOF
      n = require('neosolarized').setup({
          comment_italics = true,
      })
      EOF
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = harpoon;
        config = ''
          lua << EOF
            require("harpoon").setup({
              global_settings = {
                enter_on_sendcmd = true,
                save_on_toggle = true,
              },
              projects = {
                ["$DOTFILES"] = {
                  term = {
                    cmds = {
                      "make home"
                    }
                  }
                }
              }
            })
          EOF
        '';
      }
      colorbuddy-nvim
      {
        plugin = diffview-nvim;
        config = lua ''
          require('diffview').setup()
        '';
      }
      {
        plugin = nvim-tabline;
        config = lua ''
          require('tabline').setup({
            no_name = '[No Name]',    -- Name for buffers with no name
            modified_icon = '',      -- Icon for showing modified buffer
            close_icon = "";
            separator = "▌",          -- Separator icon on the left side
            padding = 2,              -- Prefix and suffix space
            color_all_icons = false,  -- Color devicons in active and inactive tabs
            right_separator = false,  -- Show right separator on the last tab
            show_index = false,       -- Shows the index of tab before filename
            show_icon = true,         -- Shows the devicon
          })
          vim.opt.showtabline = 2
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
      #}
      {
        plugin = git-worktree-nvim;
        config = lua ''
          require("git-worktree").setup({})
        '';
      }
      {
        plugin = hop-nvim;
        config = lua ''
          require('hop').setup({})
          vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
          vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
          vim.api.nvim_set_keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
          vim.api.nvim_set_keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
          vim.api.nvim_set_keymap("", 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
          vim.api.nvim_set_keymap("", 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
        '';
      }
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
      {
        plugin = neorg;
        config = lua ''
           require('neorg').setup {
             load = {
               ["core.defaults"] = {},              -- Load all the default modules
               ["core.norg.concealer"] = {},        -- Allows for use of icons
               ["core.norg.dirman"] = {             -- Manage your directories with Neorg
               ["core.norg.completion"] = {
                config = {
                   engine = "nvim-cmp"
                 },
               },
               ["core.keybinds"] = {
                 config = {
                   default_keybinds = true,         -- Generate the default keybinds
                   neorg_leader = "<Leader>o"       -- This is the default if unspecified
                 },
               },
               config = {
                 workspaces = {
                   my_workspace = "~/Documents/neorg"
                 }
               }
             }
           },
          }
        '';
      }
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

          null_ls.setup({
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
              --null_ls.builtins.code_actions.gitsigns, -- got annoying seeing the code action on each line for blame :(
            },
            debug = true,
          })
        '';
      }
      {
        plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars));
        config = lua ''
          require('nvim-treesitter.configs').setup {
              highlight = {
                enable = true,
                disable = { "markdown" }, -- getting an error so disable for now
              },
              -- see nvim-ts-context-commentstring
              context_commentstring = {
                enable = true,
                enable_autocmd = false, -- turn on manually with comment plugin, see docs
              },
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
                    --["<esc>"] = actions.close, -- can't really get to normal mode if you do this, use c-c to exit
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
      {
        plugin = nvim-bqf;
        config = lua ''
          require('bqf').setup({
            func_map = {
              pscrollup = '<c-d>',
            },
          })
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
        config = lua ''
          -- vscode icons on lsp completion
          require('lspkind').init()
        '';
      }
      {
        plugin = lspsaga-nvim;
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
      {
        plugin = vim-latex-live-preview;
        config = ''
          let g:livepreview_previewer = '${pkgs.zathura}/bin/zathura'
          let g:livepreview_cursorhold_recompile = 0
        '';
      }
      lsp_signature-nvim
      friendly-snippets
      {
        plugin = luasnip;
        config = lua ''
          require("luasnip/loaders/from_vscode").lazy_load()
        '';
      }
      cmp_luasnip
      cmp-path
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-latex-symbols
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
              { name = 'luasnip'  },
              { name = 'buffer', keyword_length = 5 },
              { name = 'path'     },
              { name = 'neorg'    },
              { name = 'latex_symbols' },
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
          local wk = require("which-key")

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

            require('lsp_signature').on_attach()

            -- See `:help vim.lsp.*` for documentation on any of the below functions
            wk.register({
              [ '<C-k>' ]   = { "<cmd>lua vim.lsp.buf.signature_help()<cr>",    "method signature",     buffer = bufnr },
              [ '<C-]>' ]   = { "<cmd>lua vim.lsp.buf.definition()<cr>",        "goto definition",      buffer = bufnr },
              [ "[d" ]      = { "<cmd>lua vim.diagnostic.goto_prev()<cr>",  "prev diagnostic", buffer = bufnr },
              [ "]d" ]      = { "<cmd>lua vim.diagnostic.goto_next()<cr>",  "next diagnostic", buffer = bufnr },
              ["<leader>"]  = {
                c = {
                  n = { "<cmd>lua vim.lsp.buf.references()<cr>",      "show callers", buffer = bufnr },
                  D = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "show type definition", buffer = bufnr },
                },
              },
              ['gi'] = {  "<cmd>lua vim.lsp.buf.implementation()<cr>", "goto implementation", buffer = bufnr },
            })
          end

          local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

          -- Use a loop to conveniently call 'setup' on multiple servers and
          -- map buffer local keybindings when the language server attaches
          local servers = {
            'bashls',
            'yamlls',
            'rnix',
            'dockerls',
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

          nvim_lsp.hls.setup({
            --cmd = { "${pkgs.haskellPackages.haskell-language-server}/bin/haskell-language-server", "--lsp" },
            cmd = { "haskell-language-server", "--lsp" },
            on_attach = on_attach,
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
        plugin = lualine-nvim-pin;
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
               },
               {
                 'lsp_progress'
               }
             },
             lualine_x = {
               {
                 'diagnostics',
                 sources = {"nvim_diagnostic"},
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
        plugin = gitsigns-nvim;
        config = lua ''
          require('gitsigns').setup({
            current_line_blame = false,
            -- redefining some of the defaults to remove the ones that override <leader>h which I use for harpoon
            keymaps = {
              noremap = true,
              ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
              ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},
            },
          })
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
      {
        plugin = comment-nvim;
        config = lua ''
          require('Comment').setup({
            -- delegate to nvim-ts-context-commentstring for figuring out commentstring type
            pre_hook = function(ctx)
              local U = require 'Comment.utils'

              local location = nil
              if ctx.ctype == U.ctype.block then
                location = require('ts_context_commentstring.utils').get_cursor_location()
              elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                location = require('ts_context_commentstring.utils').get_visual_start_location()
              end

              return require('ts_context_commentstring.internal').calculate_commentstring {
                key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
                location = location,
              }
            end,
          })
        '';
      }
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
          lua << EOF
            require('nvim-tree').setup({
              disable_netrw = false,  -- needed for fugitive GBrowse
              auto_close = true,
              hijack_cursor = true,
              tree_follow = 1,
              tree_gitignore = 1,
              tree_group_empty = 1,
            })
          EOF
        '';
      }
      {
        plugin = which-key-nvim;
        config = ''
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
                  d = { "<cmd>Lspsaga show_line_diagnostics<cr>", "show line Diagnostics"},
                  a = { "<cmd>Lspsaga code_action<cr>", "run Action" },
                  f = { "<cmd>Lspsaga lsp_finder<cr>", "Find usage" },
                  j = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Jump next diagnostic" },
                  p = { "<cmd>Lspsaga preview_definition<cr>", "Preview definition" },
                  r = { "<cmd>Lspsaga rename<cr>", "Rename" },
                  s = { "<cmd>lua require('lspsaga.signaturehelp').signature_help()<cr>", "Signature help" },
                  i = { "<cmd>lua require('telescope').extensions.goimpl.goimpl{}<cr>", "Implement interface" },
                  l = { "<cmd>GoFillStruct<cr>", "Fill golang struct" },
                  g = {
                    name = "go",
                    f = {
                      name = "fill",
                      s = { "<cmd>GoFillStruct<cr>",  "Struct" },
                      w = { "<cmd>GoFillSwitch<cr>",  "sWitch" },
                      t = { "<cmd>GoAddTag<cr>",      "Tags" }
                    }
                  }
                },
                d = {
                  name = "display",
                  d = { "<cmd>DiffviewOpen<cr>", "Open diffview" },
                  m = { "<cmd>MinimapToggle<cr>", "Minimap toggle" }, -- minimap-vim
                  n = {
                    name = "number",
                    r = { "<cmd>set relativenumber!<cr>", "Relative line numbers" },
                    l = { "<cmd>set number!<cr>", "Line numbers" },
                  },
                  t = { "<cmd>NvimTreeToggle<cr>", "Tree explorer" }, --nvim-tree-lua
                  g = { "<cmd>lua require('neogit').open()<cr>", "Toggle git" },
                },
                f = {
                  name = "file/fuzzy",
                  d = { "<cmd>lua require('telescope.builtin').buffers()<cr>",                "Buffers"}, -- hard for me to hit b
                  b = { "<cmd>lua require('telescope.builtin').buffers()<cr>",                "Buffers"},
                  f = { "<cmd>lua require('svrana.telescope').project_files()<cr>",           "Find" },
                  h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>",              "Help" },
                  n = { "<cmd>lua require('svrana.telescope').dots()<cr>",                    "dotfiles" },
                  p = { "<cmd>lua require('telescope').extensions.project.project({})<cr>",   "Project change" },
                  r = { "<cmd>Rg<cr>",                                                        "Search file contents (rg)" }, -- fzf
                  s = { "<cmd>lua require('telescope.builtin').live_grep()<cr>",              "Search file contents" },
                  z = { "<cmd>lua require('telescope.builtin').git_branches()<cr>",           "brancheZ" },
                },
                g = {
                  name = "git",
                  b = {
                    name = "Blame",
                    f = { "<cmd>Git blame<cr>",                                                 "File" },        -- fugitive
                    l = { "<cmd>lua require('gitsigns').blame_line{full=true}<cr>",             "Line" },
                  },
                  t = { "<cmd>lua require('neogit').open()<cr>",                              "Toggle git" },
                  h = { "<cmd>GBrowse<cr>",                                                   "gitHub view" },  -- fugitive
                  s = { "<cmd>lua require('telescope.builtin').git_status()<cr>",             "Status"},
                  z = { "<cmd>lua require('telescope.builtin').git_branches()<cr>",           "brancheZ" },
                },
                h = {
                  name = "harpoon",
                  s = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Show" },
                  a = { "<cmd>lua require('harpoon.mark').add_file()<cr>",        "Add file" },
                  r = { "<cmd>lua require('harpoon.term').sendCommand('{bottom-right}', 1)<cr>", "Run command"},
                  e = { "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<cr>", "Edit command" },
                  ["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "goto file 1" },
                  ["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "goto file 2" },
                  ["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "goto file 3" },
                  ["4"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "goto file 4" },
                },
                j = {
                  name = "jump",
                  w = { "<cmd>HopWord<cr>", "Word" },
                  l = { "<cmd>HopLine<cr>", "Line" },
                  c = { "<cmd>HopChar1<cr>", "Character" },
                },
                p = {
                  name = "preview",
                  l = { "<cmd>LLPStartPreview<cr>", "laTEX preview" },  -- vim-latex-live-preview
                  g = { "<cmd>Glow<cr>",          "Glow (markdown)" },                   -- glow-nvim
                  s = { "<cmd>ComposerStart<cr>", "Start markdown composer" },         --vim-markdown-composer
                },
                n = {
                  name = "new",
                  t = { "<cmd>tabnew<cr>", "Tab" },
                },
                s = {
                  name = "source",
                  v = { "<cmd>source $XDG_CONFIG_HOME/nvim/init.vim<cr>", "Vimrc" },
                },
                t = {
                  name = "toggle",
                  c = { "<cmd>set cursorline!<cr>", "Cursorline" },
                  n = { "<cmd>set relativenumber!<cr>", "Number" },
                  h = { "<cmd>set invhls hls?<cr>", "search Highlight toggle" },
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
