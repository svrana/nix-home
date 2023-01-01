{ pkgs, lib, ... }:

let
  goimpl-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "goimpl";
    version = "2022-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "edolphin-ydf";
      repo = "goimpl.nvim";
      rev = "06b19734077dbe79f6082f6e02b3ed197c444a9a";
      sha256 = "1vrhgm1z1x815zy50gmhdfzx72al5byx87r6xwnhylzvyg42wgq9";
    };
  };
  go-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "go-nvim";
    version = "2022-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "go.nvim";
      rev = "399a3a834e03a635583d24d771dad93074afda0b";
      sha256 = "sha256-q55ggD2IiIXHWgyZ4HcJr7+CVEaVvuL/4uSdILlO41w=";
    };
    configurePhase = ''
      rm Makefile
    '';
  };
  guihua-lua = pkgs.vimUtils.buildVimPlugin {
    pname = "guihua-lua";
    version = "2022-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "guihua.lua";
      rev = "4459ce73db68bb3ad5ef789d03e6ea4adeeafa86";
      sha256 = "sha256-H4lBJaGnpQVD+aq3A7hBGupINqMxpwfFc0TFF46eqss=";
    };
    configurePhase = ''
      rm Makefile
    '';
  };
  nvim-tabline = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-tabline";
    version = "2022-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "seblj";
      repo = "nvim-tabline";
      rev = "7e2df8d1f2bc0bb4575848901d628005ef181a3d";
      sha256 = "sha256-0J1EVKCcxH47wHH//jwUDhHtNJnMkB/oOtYWrWr6BH8=";
    };
  };
  neosolarized-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "neosolarized-nvim";
    version = "2022-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "svrana";
      repo = "neosolarized.nvim";
      rev = "f5feccedfa3028a5065104477affc31a39b6e8b1";
      sha256 = "sha256-QzcsukujedORwSriTu3yiz88Xf+48CRDZ0/b9TuJhi0=";
    };
  };
  gh-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "gh-nvim";
    version = "2022-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "ldelossa";
      repo = "gh.nvim";
      rev = "bc731bb53909481995ac2edb4bf6418c051fec1a";
      sha256 = "sha256-BjzQe8wCNAx31vN9/RzF75U8ec5bytnaRrM0OHm1fpI=";
    };
  };
in {
  xdg.configFile."nvim/init-home-manager.vim".text = lib.mkBefore ''
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
      buf-language-server
      code-minimap
      iferr
      nixfmt
      nodePackages.prettier
      nodePackages.vim-language-server
      nodePackages.eslint_d
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
      nodePackages.dockerfile-language-server-nodejs
      rnix-lsp
      shfmt
      sumneko-lua-language-server
      luaformatter
      rust-analyzer
      stylua
      terraform-lsp
    ];
    extraConfig = ''
      lua << EOF
        require('svrana.globals')

        local opt = vim.opt
        opt.ttimeout = false
        opt.ttimeoutlen = 100
        opt.wrap = false
        opt.backspace = "indent,eol,start"
        opt.smartcase = true
        opt.ignorecase = true
        opt.incsearch = true
        opt.hlsearch = false
        opt.incsearch = true
        opt.inccommand = "split"
        opt.showmatch = true
        opt.backupext  = ".bak"
        opt.errorbells = false
        opt.showmode = false
        opt.visualbell = true
        opt.ruler = true
        opt.laststatus = 2
        opt.equalalways = false
        opt.updatetime = 100
        opt.lazyredraw = true
        opt.background = "dark"
        opt.pyx = 3
        opt.termguicolors = true
        opt.cursorline = true
        opt.number = true
        opt.relativenumber = true
        -- opt.clipboard = "unnamed,unnamedplus"
        -- opt.clipboard = "unnamed"
        opt.pumblend    = 10
        opt.foldmethod  = "marker"
        opt.completeopt = "menu,menuone,noselect"
        opt.undofile = true;
        --opt.rtp:append(vim.env.RCS .. '/nvim')

        local g = vim.g
        g.autoswap_detect_tmux = 1

        -- always show the signcolumn for no page jump on first change
        vim.wo.signcolumn = 'yes'

        local map = vim.api.nvim_set_keymap
        local options = { noremap = true, silent = true }

        map('i', 'jj', '<esc>', {})

        -- center after movements so as not get lost
        map('n', '<c-u>', '<c-u>zz', options)
        map('n', '<c-d>', '<c-d>zz', options)
        map('n', 'N', 'Nzz', options)
        map('n', 'n', 'nzz', options)

        -- move lines (and blocks of lines in visual mode) up and down using alt-j/k
        -- I rarely use this, but it's kinda cool
        map('n', '<A-j>', ':m .+1<CR>==', options)
        map('n', '<A-k>', ':m .-2<CR>==', options)
        map('i', '<A-j>', '<Esc>:m .+1<CR>==gi', options)
        map('i', '<A-k>', '<Esc>:m .-2<CR>==gi', options)
        map('v', '<A-j>', ':m \'>+1<CR>gv=gv', options)
        map('v', '<A-k>', ':m \'<-2<CR>gv=gv', options)

        -- TODO: quitting help. waste of letters, rework
        map('n', '<leader>q', '<esc>:q<cr>', options)
        map('n', '<leader>w', '<esc>:w<cr>', options)
        map('c', 'w!!', '%!sudo tee > /dev/null %', {})

        map('n', 'Q', '@@', options)
        map('n', '\th', ':set invhls hls?<cr>', options)
        map('n', '<c-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<cr>', options)
        map('n', '<c-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<cr>', options)

        --map('i', '<c-a>', '<esc>^i', options)
        --map('n', '<c-d>', '<c-b>', {})

        --map('n', '<c-x>', ':tabclose<cr>', options)
        --map('n', '<c-s>', ':tabp<cr>', options)
        --map('n', '<c-h>', ':tabn<cr>', options)
        map('n', '-', '<c-w>-', options)
        map('n', '+', '<c-w>+', options)

        map('t', '<esc>', [[<c-\><c-n>]], {})

        -- tab mappings, looking for some good ones..
        map('n', '<leader>t1', '1gt', options)
        map('n', '<leader>t2', '2gt', options)
        map('n', '<leader>t3', '3gt', options)
        map('n', '<leader>t4', '4gt', options)
        map('n', '<leader>t5', '5gt', options)
        map('n', '<leader>t6', '6gt', options)
        map('n', '<a-9>', ':tabprev<cr>', options)
        map('n', '<a-0>', ':tabnext<cr>', options)

        --amap = require('svrana.utils').amap
        --amap('c-[', '<esc>') -- my escape key requires hitting a function key, remap to ctrl-[ in all modes.. wrong,
        --alacritty forces you to configure that. this was causing some problems in telescope
        vim.cmd [[
          autocmd FileType harpoon    nnoremap <buffer> <C-c> <cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>
        ]]
        --set spelllang=en_us region not supported  uh oh
        vim.cmd [[
          set spell
        ]]

        --Remap for dealing with word wrap
        vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
        vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

        vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

        autocmd = require('svrana.utils').autocmd
        autocmd('TextYankPost', '*', 'lua vim.highlight.on_yank{timeout=40}')
        autocmd('BufWritePre', '*', [[:%s/\s\+$//e]])
        autocmd('BufNewFile,BufRead', [[*.tsx,*.jsx]], 'set filetype=typescriptreact')
        autocmd('FileType', '*',          'setlocal formatoptions+=croq')
        autocmd('BufRead', 'gitcommit',   'setlocal textwidth=72')
        autocmd('BufRead', 'gitcommit',   'setlocal fo+=t')
        autocmd('BufRead', '*.md',        'setlocal textwidth=90')
        autocmd('BufRead', '*.txt',       'setlocal textwidth=90')
        autocmd('BufRead', '*.eml',       'setlocal textwidth=90')
        autocmd('BufNewFile,BufRead,BufEnter', [[*.erb, *.feature]],       'setf ruby')
        autocmd('BufNewFile,BufRead,BufEnter', '*.gradle',    'setf groovy')
        autocmd('BufNewFile,BufRead,BufEnter', '*.json',      'setf json')
        autocmd('BufNewFile,BufRead,BufEnter', '*.gjs',       'setf javascript')
        autocmd('BufRead', 'Tiltfile',    'set filetype=python')
        autocmd('FileType', 'terraform',  'setlocal commentstring=#%s')
        autocmd('FileType', 'json',       [[syntax match Comment +\/\/.\+$+]])
        autocmd('TermOpen', 'term://*',   'startinsert')
        autocmd('InsertEnter', '*',       'setlocal nocursorline')
        autocmd('InsertLeave', '*',       'setlocal cursorline')
        --turn off numbers when not active window.... but need per file adjustments which these seem to override
        --autocmd('FocusGained', '*', 'set relativenumber number')
        --autocmd('FocusLost', '*', 'set norelativenumber nonumber')

      -- uncomment and add link to neosolarized.nvim from /home/shaw/.config/nvim/after/pack/foo/start
      -- and remove from plugin section below
      --[[ local ns = require('neosolarized').setup({ ]]
      --[[      comment_italics = true, ]]
      --[[      background_set = true, ]]
      --[[ }) ]]
      --[[ -- haskell goes overboard with warnings and is distracting ]]
      --[[ -- and for some reason some code actions appear to use this highlight group, which makes no sense to me. ]]
      --[[ ns.Group.link('WarningMsg', ns.groups.Comment) ]]

      -- [[ Highlight on yank ]]
      -- See `:help vim.highlight.on_yank()`
      local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
      vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
          vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = '*',
      })
      EOF

      " Make the 120th column standout iff there is text there
      call matchadd('ColorColumn', '\%120v', 100)

      set expandtab
      set shiftwidth=4
      set tabstop=4
      set scrolloff=8
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''

          -- so init.lua gets some space after the source of init-home-manager.vim
          require('indent_blankline').setup {
            char = '┊',
            show_trailing_blankline_indent = false,
          }
        '';
      }
      {
        plugin = fidget-nvim;
        type = "lua";
        config = ''
          require("fidget").setup()
        '';
      }
      vim-sleuth
      vim-numbertoggle
      litee-nvim
      {
        plugin = guihua-lua;
        type = "lua";
      }
      {
        plugin = gh-nvim;
        type = "lua";
        config = ''
          require('litee.lib').setup()
          require('litee.gh').setup({
            debug_logging = true,
          })
        '';
      }
      {
        plugin = harpoon;
        type = "lua";
        config = ''
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
              },
              [ "$PROJECTS/tests/go" ] = {
                term = {
                  cmds = {
                    "go run main.go"
                  }
                },
              },
              [ "$PROJECTS/nucleus/mgmt-api" ] = {
                term = {
                  cmds = {
                    "make"
                  }
                }
              },
            }
          })
        '';
      }
      colorbuddy-nvim
      {
        plugin = diffview-nvim;
        type = "lua";
        config = ''
          require('diffview').setup()
        '';
      }
      {
        plugin = nvim-tabline;
        type = "lua";
        config = ''
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
      {
        plugin = neosolarized-nvim;
        type = "lua";
        config = ''
          local n = require('neosolarized').setup({
             comment_italics = true,
             background_set = true, -- set this to false if you use transparency in your terminal window
          })
          -- for some reason some code actions get highlighted with WarningMsg and it's too much for me
          n.Group.link('WarningMsg', n.groups.Comment)
        '';
      }
      {
        plugin = git-worktree-nvim;
        type = "lua";
        config = ''
          require("git-worktree").setup({})
        '';
      }
      {
        plugin = go-nvim;
        type = "lua";
        config = ''
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
      # {
      #   plugin = neorg;
      #   type = "lua";
      #   config = ''
      #      require('neorg').setup {
      #        load = {
      #          ["core.defaults"] = {},              -- Load all the default modules
      #          ["core.norg.concealer"] = {},        -- Allows for use of icons
      #          ["core.norg.dirman"] = {             -- Manage your directories with Neorg
      #          ["core.norg.completion"] = {
      #           config = {
      #              engine = "nvim-cmp"
      #            },
      #          },
      #          ["core.keybinds"] = {
      #            config = {
      #              default_keybinds = true,         -- Generate the default keybinds
      #              neorg_leader = "<Leader>o"       -- This is the default if unspecified
      #            },
      #          },
      #          config = {
      #            workspaces = {
      #              my_workspace = "~/Documents/org"
      #            }
      #          }
      #        }
      #      },
      #     }
      #   '';
      # }
      plenary-nvim
      { plugin = null-ls-nvim; }
      {
        plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
          with plugins; [
            c
            css
            comment
            diff
            elixir
            erlang
            git_rebase
            gitignore
            gitattributes
            elm
            bash
            nix
            python
            go
            gomod
            gowork
            haskell
            hcl
            help
            html
            http
            java
            javascript
            jsdoc
            json
            latex
            lua
            scheme
            markdown
            markdown_inline
            norg
            org
            proto
            query
            regex
            ruby
            rust
            scss
            sql
            kotlin
            toml
            tsx
            vim
            yaml
            make
            dockerfile
            typescript
          ]));
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true, -- false will disable the whole extension
              --disable = { "make", "dockerfile"}, -- getting an error so disable for now
            },
            -- see nvim-ts-context-commentstring
            context_commentstring = {
              enable = true,
              enable_autocmd = false, -- turn on manually with comment plugin, see docs
            },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = '<c-space>',
                node_incremental = '<c-space>',
                scope_incremental = '<c-s>',
                node_decremental = '<c-backspace>',
              },
            },
            indent = {
              enable = true,
            },
            textobjects = {
              select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                  -- You can use the capture groups defined in textobjects.scm
                  ['af'] = '@function.outer',
                  ['if'] = '@function.inner',
                  ['ac'] = '@class.outer',
                  ['ic'] = '@class.inner',
                },
              },
              move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                  [']m'] = '@function.outer',
                  [']]'] = '@class.outer',
                },
                goto_next_end = {
                  [']M'] = '@function.outer',
                  [']['] = '@class.outer',
                },
                goto_previous_start = {
                  ['[m'] = '@function.outer',
                  ['[['] = '@class.outer',
                },
                goto_previous_end = {
                  ['[M'] = '@function.outer',
                  ['[]'] = '@class.outer',
                },
              },
            },
          }
        '';
      }
      nvim-treesitter-textobjects
      {
        plugin = playground;
        type = "lua";
        config = ''
          require "nvim-treesitter.configs".setup {
            playground = {
              enable = true,
              disable = {},
              updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
              persist_queries = false, -- Whether the query persists across vim sessions
              keybindings = {
                toggle_query_editor = 'o',
                toggle_hl_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<cr>',
                show_help = '?',
              },
            }
          }
        '';
      }
      popup-nvim
      telescope-fzf-native-nvim
      {
        plugin = telescope-ui-select-nvim;
        type = "lua";
        config = ''
          require("telescope").load_extension("ui-select")
        '';
      }
      {
        plugin = telescope-project-nvim;
        type = "lua";
        config = ''
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
        type = "lua";
        config = ''
          local actions = require('telescope.actions')
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
                  --["<C-d>"] = actions.preview_scrolling_up, -- default
                  ["<C-b>"] = actions.preview_scrolling_up,
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
              },
              ["ui-select"] = {
                require("telescope.themes").get_dropdown { }
              }
            }
          }
          require('telescope').load_extension('fzf')
          require('telescope').load_extension('goimpl')
        '';
      }
      {
        plugin = nvim-bqf;
        type = "lua";
        config = ''
          require('bqf').setup({
            func_map = {
              pscrollup = '<c-b>',
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
        type = "lua";
        config = ''
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
        type = "lua";
        config = ''
          require("luasnip/loaders/from_vscode").lazy_load()
          require("luasnip.loaders.from_lua").load({paths="~/.config/nvim/lua/svrana/luasnippets"})
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
        type = "lua";
        config = ''
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
              ['<C-d>'] = cmp.mapping.scroll_docs(4),
              ['<C-u>'] = cmp.mapping.scroll_docs(-4),
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-d>'] = cmp.mapping.scroll_docs(4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.close(),
              ['<C-y>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              },
              ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                --select = true,
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
        type = "lua";
        config = ''
          local nvim_lsp = require('lspconfig')
          local protocol = require('vim.lsp.protocol')
          local wk = require("which-key")

          local diagnostic_map = function(bufnr)
            local opts = {noremap = true, silent = true}
            vim.api.nvim_buf_set_keymap(bufnr, "n", "]O", ":lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
          end


          local ref_highlighter = function(client, bufnr)
            if client.server_capabilities.documentHighlightProvider then
              vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
              vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
              vim.api.nvim_create_autocmd("CursorHold", {
                  callback = vim.lsp.buf.document_highlight,
                  buffer = bufnr,
                  group = "lsp_document_highlight",
                  desc = "Document Highlight",
              })
              vim.api.nvim_create_autocmd("CursorMoved", {
                  callback = vim.lsp.buf.clear_references,
                  buffer = bufnr,
                  group = "lsp_document_highlight",
                  desc = "Clear All the References",
              })
            end
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
            --if client.server_capabilities.document_formatting then
            if client.server_capabilities.documentFormattingProvider then
               vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ bufnr = bufnr })")
            end

            -- not sure I like this
            ref_highlighter(client, bufnr)

            -- Mappings.
            local opts = { noremap=true, silent=true }

            require('lsp_signature').on_attach()

            -- See `:help vim.lsp.*` for documentation on any of the below functions

            local nmap = function(keys, func, desc)
              if desc then
                desc = 'LSP: ' .. desc
              end

              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end
            nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
            nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
            nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
            nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
            -- Lesser used LSP functionality
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, '[W]orkspace [L]ist Folders')

            wk.register({
              [ '<C-]>' ]   = { "<cmd>lua vim.lsp.buf.definition()<cr>",        "goto definition" },
              [ "[d" ]      = { "<cmd>lua vim.diagnostic.goto_prev()<cr>",  "prev diagnostic" },
              [ "]d" ]      = { "<cmd>lua vim.diagnostic.goto_next()<cr>",  "next diagnostic" },
              ["<leader>"]  = {
                c = {
                  n = { "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "show callers" },
                  D = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "show type definition" },
                  s = { "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols<cr>", "workspace symbols" },
                },
              },
              ['gi'] = {  "<cmd>lua vim.lsp.buf.implementation()<cr>", "goto implementation" },
            }, { buffer = buffnr })

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
              if vim.lsp.buf.format then
                vim.lsp.buf.format()
              elseif vim.lsp.buf.formatting then
                vim.lsp.buf.formatting()
              end
            end, { desc = 'Format current buffer with LSP' })
          end

          -- nvim-cmp supports additional completion capabilities
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

          -- Use a loop to conveniently call 'setup' on multiple servers and
          -- map buffer local keybindings when the language server attaches
          local servers = {
            'bashls',
            'bufls',
            'yamlls',
            'rnix',
            'dockerls',
            'vimls',
            'rust_analyzer',
            'terraform_lsp',
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
            -- moved this into .gonvim per-project directory as this isn't usually what I want
            -- lsp_cfg = {
            --   settings= {
            --     gopls = {
            --       staticcheck=false,
            --     }
            --   }
            -- },
            lsp_on_attach = on_attach,
            --verbose = true,
            --tag_options = "json="
            tag_transform = "camelcase",
          })

          nvim_lsp.hls.setup({
            cmd = { "haskell-language-server", "--lsp" },
            on_attach = on_attach,
          })

          nvim_lsp.tsserver.setup({
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
            flags = {
                debounce_text_changes = 150,
            },
            --on_attach = on_attach,
            -- let null-ls (w/ prettier) handle formatting. This stops lsp
            -- from prompting which lsp client should handle the formatting.
            on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
                on_attach(client, bufnr)
            -- documentFormattingProvider
            -- documentRangeFormattingProvider
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
            capabilities = capabilities,
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
                  checkThirdParty = false,
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                  enable = false,
                },
              },
            },
          }

          local null_ls = require('null-ls')
          local helpers = require('null-ls.helpers')

          null_ls.setup({
            on_attach = on_attach,
            sources = {
              null_ls.builtins.diagnostics.buf,
              null_ls.builtins.diagnostics.golangci_lint,
              null_ls.builtins.diagnostics.eslint_d,
              null_ls.builtins.formatting.stylua,
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
        plugin = lualine-nvim;
        type = "lua";
        config = ''
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
               -- golang lsp spewing errors causing ugliness with this for now; also moved to fidget
               -- {
               --  'lsp_progress'
               -- }
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
        type = "lua";
        config = ''
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
        type = "lua";
        config = ''
          require('neogit').setup {
            disable_commit_confirmation = true,
            integrations = {
              diffview = true,
            }
          }
        '';
      }
      vim-tmux-navigator
      vim-surround
      nvim-ts-context-commentstring
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
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
        type = "lua";
        config = ''
          require('nvim-tree').setup({
            disable_netrw = false,  -- needed for fugitive GBrowse
            hijack_cursor = true,
            git = { ignore = true },
            update_focused_file = { enable = true },
            filters = {
              dotfiles = true
            },
            view = {
              --auto_resize = true,
              --side = 'left',
              width = 35
            },
            tab = {
              sync = {
                open = true,
                close = true,
              },
            },
          })

          -- This will:
          --  Close the tab if nvim-tree is the last buffer in the tab (after closing a buffer)
          --  Close vim if nvim-tree is the last buffer (after closing a buffer)
          --  Close nvim-tree across all tabs when one nvim-tree buffer is manually closed if and only if tabs.sync.close is set.
          local function tab_win_closed(winnr)
            nt_api = require('nvim-tree')
            local tabnr = vim.api.nvim_win_get_tabpage(winnr)
            local bufnr = vim.api.nvim_win_get_buf(winnr)
            local buf_info = vim.fn.getbufinfo(bufnr)[1]
            local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
            local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
            if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree
              -- Close all nvim tree on :q
              if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
                if nt_api.tree then
                  nt_api.tree.close()
                end
              end
            else                                                      -- else closed buffer was normal buffer
              if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
                local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
                if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
                  vim.schedule(function()
                    if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
                      vim.cmd "quit"                                        -- then close all of vim
                    else                                                  -- else there are more tabs open
                      vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
                    end
                  end)
                end
              end
            end
          end

          vim.api.nvim_create_autocmd("WinClosed", {
            callback = function ()
              local winnr = tonumber(vim.fn.expand("<amatch>"))
              vim.schedule_wrap(tab_win_closed(winnr))
            end,
            nested = true
          })
        '';
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          wk = require("which-key")
          wk.setup{
            window = {
              border = "single"
            }
          }
          wk.register({
            c = {
              name = "+code",
              d = { "<cmd>Lspsaga show_line_diagnostics<cr>", "show line Diagnostics"},
              a = { "<cmd>Lspsaga code_action<cr>", "run Action" },
              f = { "<cmd>Lspsaga lsp_finder<cr>", "Find usage" },
              j = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Jump next diagnostic" },
              p = { "<cmd>Lspsaga preview_definition<cr>", "Preview definition" },
              r = { "<cmd>Lspsaga rename<cr>", "Rename" },
              i = { "<cmd>lua require('telescope').extensions.goimpl.goimpl{}<cr>", "Implement interface" },
              l = { "<cmd>LspRestart<cr>", "Restart LSP" },
              g = {
                name = "+go",
                s = { "<cmd>GoFillStruct<cr>",  "fill struct" },
                w = { "<cmd>GoFillSwitch<cr>",  "fill switch" },
                j = { "<cmd>GoAddTag<cr>",      "tag struct" },
                i = { "<cmd>GoIfErr<cr>",       "add if err"  },
                c = { "<cmd>GoCheat<cr>",       "cheat.sh"    },
                t = {
                  name = "+test",
                  f = { "<cmd>GoTestFunc<cr>", "test func" },
                  i = { "<cmd>GoTestFile<cr>", "test file" },
                  a = { "<cmd>GoAddTest<cr>", "add test" },
                }
              },
            },
            d = {
              name = "+display",
              d = { "<cmd>DiffviewOpen<cr>", "Open diffview" },
              n = {
                name = "+number",
                r = { "<cmd>set relativenumber!<cr>", "Relative line numbers" },
                l = { "<cmd>set number!<cr>", "Line numbers" },
              },
            },
            f = {
              name = "+fuzzy",
              d = { "<cmd>lua require('telescope.builtin').buffers()<cr>",                "Buffers"}, -- hard for me to hit b
              o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>",               "Old files"},
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
              name = "+git",
              b = {
                name = "Blame",
                f = { "<cmd>Git blame<cr>",                                                 "File" },        -- fugitive
                l = { "<cmd>lua require('gitsigns').blame_line{full=true}<cr>",             "Line" },
              },
              g = { "<cmd>lua require('neogit').open()<cr>",                              "Toggle git" },
              h = { "<cmd>GBrowse<cr>",                                                   "gitHub view" },  -- fugitive
              s = { "<cmd>lua require('telescope.builtin').git_status()<cr>",             "Status"},
              z = { "<cmd>lua require('telescope.builtin').git_branches()<cr>",           "brancheZ" },
              h = {
                name = "+Github",
                c = {
                  name = "+Commits",
                  c = { "<cmd>GHCloseCommit<cr>", "Close" },
                  e = { "<cmd>GHExpandCommit<cr>", "Expand" },
                  o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
                  p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
                  z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
                },
                i = {
                  name = "+Issues",
                  p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
                },
                l = {
                  name = "+Litee",
                  t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
                },
                r = {
                  name = "+Review",
                  b = { "<cmd>GHStartReview<cr>", "Begin" },
                  c = { "<cmd>GHCloseReview<cr>", "Close" },
                  d = { "<cmd>GHDeleteReview<cr>", "Delete" },
                  e = { "<cmd>GHExpandReview<cr>", "Expand" },
                  s = { "<cmd>GHSubmitReview<cr>", "Submit" },
                  z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
                },
                p = {
                  name = "+Pull Request",
                  c = { "<cmd>GHClosePR<cr>", "Close" },
                  d = { "<cmd>GHPRDetails<cr>", "Details" },
                  e = { "<cmd>GHExpandPR<cr>", "Expand" },
                  o = { "<cmd>GHOpenPR<cr>", "Open" },
                  p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
                  r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
                  t = { "<cmd>GHOpenToPR<cr>", "Open To" },
                  z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
                },
                t = {
                  name = "+Threads",
                  c = { "<cmd>GHCreateThread<cr>", "Create" },
                  n = { "<cmd>GHNextThread<cr>", "Next" },
                  t = { "<cmd>GHToggleThread<cr>", "Toggle" },
                },
              },
            },
            h = {
              name = "+harpoon",
              s = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Show" },
              a = { "<cmd>lua require('harpoon.mark').add_file()<cr>",        "Add file" },
              r = { "<cmd>lua require('harpoon.tmux').sendCommand('{bottom-right}', 1)<cr>", "Run command"},
              e = { "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<cr>", "Edit command" },
              ["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "goto file 1" },
              ["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "goto file 2" },
              ["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "goto file 3" },
              ["4"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "goto file 4" },
            },
            p = {
              name = "+preview",
              l = { "<cmd>LLPStartPreview<cr>", "laTEX preview" },  -- vim-latex-live-preview
              g = { "<cmd>Glow<cr>",          "Glow (markdown)" },                   -- glow-nvim
              s = { "<cmd>ComposerStart<cr>", "Start markdown composer" },         --vim-markdown-composer
            },
            n = {
              name = "+new",
              t = { "<cmd>tabnew<cr>", "Tab" },
            },
            s = {
              name = "+source",
              v = { "<cmd>source $XDG_CONFIG_HOME/nvim/init.vim<cr>", "Vimrc" },
            },
            t = {
              name = "+toggle",
              c = { "<cmd>set cursorline!<cr>", "Cursorline" },
              n = { "<cmd>set relativenumber!<cr>", "Number" },
              h = { "<cmd>set invhls hls?<cr>", "search Highlight toggle" },
              m = { "<cmd>MinimapToggle<cr>", "Minimap toggle" }, -- minimap-vim
              --t = { "<cmd>NvimTreeToggle<cr>", "Tree explorer" }, --nvim-tree-lua
              t = { "<cmd>lua require('nvim-tree.api').tree.toggle(false, true)<cr>", "Tree explorer" }, --nvim-tree-lua

            },
            w = { "<cmd>w<cr>", "Write file" },
            q = { "<cmd>q<cr>", "Quit" },
            u = {
              name = "+quickfix",
              c = { "<cmd>cclose<cr>", "Close" },
              n = { "<cmd>cnext<cr>", "Next" },
              p = { "<cmd>cprev<cr>", "Previous" },
            },
            z = { "<cmd>q!<cr>" },
            r = {
              s = { "<cmd>lua require('svrana.repl').set_job_id()<cr>",       "Set job id" },
              c = { "<cmd>lua require('svrana.repl').set_job_command()<cr>",  "set job Command" },
              i = { "<cmd>lua require('svrana.repl').send_to_term()<cr>",     "send command"},
            }
          }, { prefix = "<leader>" })
        '';
      }
    ];
  };
}
