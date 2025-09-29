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
    dependencies = with pkgs.vimPlugins; [
      plenary-nvim
      popup-nvim
      telescope-nvim
      nvim-treesitter
    ];
  };
  nvim-tabline = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-tabline";
    version = "2022-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "seblj";
      repo = "nvim-tabline";
      rev = "e830f22f0551a462c3f1c3e9f51e3876b9a60e6d";
      sha256 = "sha256-Rh01PQxuc9hiDr6m8C9rLR8eo4liPiKHO5IRBzLqSTU=";
    };
    dependencies = [ pkgs.vimPlugins.nvim-web-devicons ];
  };
#  neosolarized-nvim = pkgs.vimUtils.buildVimPlugin {
#    pname = "neosolarized-nvim";
#    version = "2022-01-06";
#    src = pkgs.fetchFromGitHub {
#      owner = "svrana";
#      repo = "neosolarized.nvim";
#      rev = "ea6583b29ce6a23525c692bd721b926c48ffa9ea";
#      sha256 = "sha256-i54vCBV1MYBBIZ/MiTlHrORigQG6NY9je486hGyFxuk=";
#    };
#    dependencies = [ pkgs.vimPlugins.colorbuddy-nvim ];
#  };
in
{
  xdg.configFile."nvim/init.lua".text = lib.mkBefore ''
    vim.g.mapleader = " "
  '';

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      buf
      code-minimap
      iferr
      nixfmt-rfc-style
      nixd
      nodePackages.prettier
      nodePackages.vim-language-server
      nodePackages.eslint_d
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
      dockerfile-language-server
      nodePackages.vscode-langservers-extracted
      pyright
      ccls
      nil
      impl # for goimpl
      shfmt
      lua-language-server
      luaformatter
      rust-analyzer
      rustfmt
      stylua
      terraform-lsp
      shellcheck
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
        opt.laststatus = 3
        opt.equalalways = false
        opt.updatetime = 100
        opt.background = "dark"
        opt.pyx = 3
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

        -- get out of insert mode, saving afterward
        map('i', 'jj', '<esc>:update<CR>', {})
        map('i', 'jk', '<esc>:update<CR>', {})

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
        map('n', '<leader>w', '<esc>:update<cr>', options)
        map('c', 'w!!', '%!sudo tee > /dev/null %', {})

        map('n', 'Q', '@@', options)
        map('n', '\th', ':set invhls hls?<cr>', options)

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
        autocmd('FileType', '*',          'setlocal formatoptions+=croq')
        autocmd('BufRead', 'gitcommit',   'setlocal textwidth=72 | setlocal fo+=t')
        autocmd('BufRead', '*.md',        'setlocal textwidth=90')
        autocmd('BufRead', '*.txt',       'setlocal textwidth=90')
        autocmd('BufRead', '*.eml',       'setlocal textwidth=90 | set wrap')
        autocmd('FileType', 'terraform',  'setlocal commentstring=#%s')
        autocmd('FileType', 'json',       [[syntax match Comment +\/\/.\+$+]])
        autocmd('TermOpen', 'term://*',   'startinsert')
        autocmd('InsertEnter', '*',       'setlocal nocursorline')
        autocmd('InsertLeave', '*',       'setlocal cursorline')

        autocmd('BufNewFile,BufRead', [[*.org,*.norg]], 'set filetype=norg')
        autocmd('BufNewFile,BufRead', [[*.tsx,*.jsx]], 'set filetype=typescriptreact')
        autocmd('BufNewFile,BufRead,BufEnter', [[*.erb, *.feature]], 'setf ruby')
        autocmd('BufNewFile,BufRead,BufEnter', '*.gradle',    'setf groovy')
        autocmd('BufNewFile,BufRead,BufEnter', '*.json',      'setf json')
        autocmd('BufNewFile,BufRead,BufEnter', '*.gjs',       'setf javascript')
        autocmd('BufRead,BufEnter,BufNewFile', 'Tiltfile',    'setf tiltfile | set syntax=python')

      -- uncomment and add link to neosolarized.nvim from /home/shaw/.config/nvim/after/pack/foo/start
      -- and remove from plugin section below
      local ns = require('neosolarized').setup({
           comment_italics = true,
           background_set = true,
      })
      vim.cmd("colorscheme neosolarized")
      -- haskell goes overboard with warnings and is distracting
      -- and for some reason some code actions appear to use this highlight group, which makes no sense to me.
      ns.Group.link('WarningMsg', ns.groups.Comment)
        --ns.Group.new('
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

      " Get rid of end of buffer lines. The rest is fluff.
      set fillchars=vert:\│,eob:\ ,msgsep:‾
      set expandtab
      set shiftwidth=4
      set tabstop=4
      set scrolloff=8

      if !isdirectory("~/.local/state/nvim/backup")
        silent! execute "!mkdir ~/.local/state/nvim/backup"
      endif
      set backupdir=~/.local/state/nvim/backup
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''

          -- so init.lua gets some space after the source of init-home-manager.vim
          require('ibl').setup {
            indent = { char = '┊' },
            scope = {
              enabled = false
            }
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
      colorbuddy-nvim
      {
        plugin = rust-vim;
        config = ''
          autocmd FileType rust let g:rustfmt_autosave = 1
        '';
      }
      {
        plugin = rustaceanvim;
        type = "lua";
      }
      {
        plugin = copilot-cmp;
        type = "lua";
        config = ''
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
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
                    "make home"
                  }
                }
              },
              [ "$PROJECTS/tests/go" ] = {
                term = {
                  cmds = {
                    "go run main.go"
                  }
                },
              },
              [ "$PROJECTS/geniveev" ] = {
                term = {
                  cmds = {
                    "go test ."
                  }
                },
              },
            }
          })
        '';
      }
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
#      {
#        plugin = neosolarized-nvim;
#        type = "lua";
#        config = ''
#          local n = require('neosolarized').setup({
#             comment_italics = true,
#             background_set = true, -- set this to false if you use transparency in your terminal window
#          })
#          -- for some reason some code actions get highlighted with WarningMsg and it's too much for me
#          n.Group.link('WarningMsg', n.groups.Comment)
#        '';
#      }
      {
        plugin = go-nvim;
        type = "lua";
        config = ''
          local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
              require('go.format').goimport()
            end,
            group = format_sync_grp,
          })
        '';
      }
      {
        plugin = glow-nvim;
        type = "lua";
        config = ''
          require('glow').setup({
            glow_path = "${pkgs.glow}/bin/glow",
            width = 120,
          })
        '';
      }
      goimpl-nvim
      {
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
            require('nvim-web-devicons').setup({
          })
        '';
      }
      plenary-nvim
      { plugin = none-ls-nvim; }
      {
        plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
          with plugins; [
            bash
            c
            comment
            css
            diff
            dockerfile
            elixir
            elm
            erlang
            git_rebase
            gitattributes
            gitignore
            go
            gomod
            gowork
            haskell
            hcl
            html
            http
            java
            javascript
            jsdoc
            json
            kotlin
            latex
            lua
            make
            markdown
            markdown_inline
            nix
            #norg
            #org
            proto
            python
            query
            regex
            ruby
            rust
            scheme
            scss
            sql
            toml
            tsx
            typescript
            vim
            yaml
          ]));
        type = "lua";
        config = ''
          require('ts_context_commentstring').setup {
            enable = true,
            enable_autocmd = false, -- turn on manually with comment plugin, see docs
          }
          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true, -- false will disable the whole extension
              --disable = { "make", "dockerfile"}, -- getting an error so disable for now
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
        plugin = vim-rooter;
        type = "viml";
        config = ''
          let g:rooter_cd_cmd = 'lcd'
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
                  ["<C-u>"] = false,
                  ["<C-f>"] = actions.preview_scrolling_down,   -- remap of c-u, b/c I like emacs
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
        type = "lua";
        config = ''
            require('colorizer').setup();
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
        type = "viml";
        config = ''
          nnoremap <silent> K :Lspsaga hover_doc<CR>
          vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
          nnoremap <silent> [e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
          nnoremap <silent> ]e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>

          lua << EOF
          require('lspsaga').setup({
            lightbulb = {
              enable = false,
            },
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
        type = "viml";
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

          ls=require("luasnip")

          vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
          vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
          vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

          vim.keymap.set({"i", "s"}, "<C-E>", function()
	        if ls.choice_active() then
		      ls.change_choice(1)
	        end
          end, {silent = true})
        '';
      }
      cmp_luasnip
      cmp-path
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-latex-symbols
      {
        plugin = neorg;
        type = "lua";
        config = ''
          require('neorg').setup {
            load = {
              ["core.defaults"] = {},
              ["core.concealer"] = {},
              ["core.autocommands"] = {},
              ["core.integrations.treesitter"] = {},
              ["core.dirman"] = {
                config = {
                  workspaces = {
                    home = "~/Documents/org/home",
                  }
                }
              }
            }
          }
        '';
      }
      {
        plugin = avante-nvim;
        type = "lua";
        config = ''
          require("avante").setup({
            rag_service = {
              enabled = false, -- Enables the RAG service
              host_mount = os.getenv("HOME"), -- Host mount path for the rag service
              provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
              llm_model = "gpt-4o-mini", -- The LLM model to use for RAG service
              embed_model = "", -- The embedding model to use for RAG service
              endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
            },
          });
        '';
      }
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
              },
            },
            sources = {
              { name = "copilot"  },
              { name = 'nvim_lua' },
              { name = 'nvim_lsp' },
              { name = 'buffer', keyword_length = 5 },
              { name = 'path'     },
              { name = 'neorg'    },
              { name = 'latex_symbols' },
              { name = 'luasnip' },
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
                    nvim_lua = "[api]",
                    luasnip = "[snip]",
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
        plugin = typescript-tools-nvim;
        type = "lua";
        config = ''
          require("typescript-tools").setup {}
           local TSFormat = vim.api.nvim_create_augroup("TSFormat", { clear = true })
           vim.api.nvim_create_autocmd("BufWritePre", {
             group = Format,
             pattern = "*.tsx,*.ts,*.jsx,*.js",
             callback = function()
               if vim.fn.exists(":TSToolsAddMissingImports") then
                   vim.cmd("TSToolsAddMissingImports")
                   vim.cmd("TSToolsRemoveUnused")
               end
             end,
           })

        '';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
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
             --[[ if client.server_capabilities.documentFormattingProvider then ]]
             --[[    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ bufnr = bufnr })") ]]
             --[[ end ]]

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

             wk.add({
                { "<C-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "goto definition" },
                { "<leader>cD", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "show type definition" },
                { "<leader>cn", "<cmd>lua require('telescope.builtin').lsp_references()<cr>", desc = "show callers" },
                { "<leader>cs", "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols<cr>", desc = "workspace symbols" },
                { "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "prev diagnostic" },
                { "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "next diagnostic" },
                { "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "goto implementation" },
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
             'buf_ls',
             'yamlls',
             'nil_ls',
             'nixd',
             'dockerls',
             'vimls',
             'ccls',
             --'rust_analyzer', -- trying rust tools for now
             'terraform_lsp',
             'tilt_ls',
             'pyright',
             --'eslint'
           }
           for _, lsp in ipairs(servers) do
             vim.lsp.config(lsp, {
               on_attach = on_attach,
               capabilities = capabilities,
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
             lsp_inlay_hints = {
               style = 'eol',
             },
           })

           vim.lsp.config('hls', {
             cmd = { "haskell-language-server", "--lsp" },
             on_attach = on_attach,
           })

           vim.lsp.config('lua_ls', {
             settings = {
               Lua = {
                 runtime = {
                   -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                   version = 'LuaJIT',
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
           })

           local null_ls = require('null-ls')
           local helpers = require('null-ls.helpers')

           null_ls.setup({
             on_attach = on_attach,
             sources = {
               null_ls.builtins.diagnostics.buf,
               null_ls.builtins.diagnostics.golangci_lint,
               -- require("none-ls.diagnostics.eslint"),
               --null_ls.builtins.diagnostics.eslint_d,
               null_ls.builtins.formatting.nixfmt,
               null_ls.builtins.formatting.stylua,
               null_ls.builtins.formatting.prettier.with({
                 filetypes = { "typescript", "typescriptreact", "markdown", "json" },
               }),
               -- null_ls.builtins.formatting.lua_format.with({
               --   args = { "-i", "--no-keep-simple-function-one-line", "--no-break-after-operator",
               --   "--no-keep_simple_control_block_one_line", "--column-limit=130",
               --   "--break-after-table-lb" },
               -- }),
               --null_ls.builtins.code_actions.gitsigns, -- got annoying seeing the code action on each line for blame :(
             },
             debug = false,
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
             section_separators = { left = '', right = '' },
             --section_separators = { left = '', right = '' },
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
             --lualine_y = {'progress'},
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
            on_attach = function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end
              -- Navigation
              map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
              end, {expr=true})

              map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
              end, {expr=true})

              map('n', '<leader>tb', gs.toggle_current_line_blame)

              vim.keymap.set('n', '<leader>gp', gs.prev_hunk, { buffer = bufnr, desc = 'Previous Hunk' })
              vim.keymap.set('n', '<leader>gn', gs.next_hunk, { buffer = bufnr, desc = 'Next Hunk' })
              vim.keymap.set('n', '<leader>ph', gs.preview_hunk, { buffer = bufnr, desc = 'Preview Hunk' })
              --map('n', '<leader>hs', gs.stage_hunk)
              --map('n', '<leader>hr', gs.reset_hunk)
            end

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
      /* { */
      /*   plugin = vim-markdown-composer; */
      /*   type = "viml"; */
      /*   config = '' */
      /*     let g:markdown_composer_autostart = 0 */
      /*     let g:markdown_composer_browser="firefox" */
      /*   ''; */
      /* } */
      vim-tmux
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          -- move away from nvim-tree so tab name doesn't stay nvim-tree and lose my place
          local swap_then_open_tab = function()
            local api = require("nvim-tree.api")
            local node = api.tree.get_node_under_cursor()
            vim.cmd("wincmd l")
            api.node.open.tab(node)
          end

         local function on_attach(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- apply default key mappings
          api.config.mappings.default_on_attach(bufnr)

          -- custom mappings
          vim.keymap.set('n', '<C-t>', swap_then_open_tab, opts('swap_then_open_tab'))
        end

        require('nvim-tree').setup({
          on_attach = on_attach,
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
            width = 35,
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
            win = { border = "single" }
          }
          wk.add({
            { "<leader>c", group = "code" },
            { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "run Action" },
            { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "show line Diagnostics" },
            { "<leader>cf", "<cmd>Lspsaga lsp_finder<cr>", desc = "Find usage" },
            { "<leader>cg", group = "go" },
            { "<leader>cgc", "<cmd>GoCheat<cr>", desc = "cheat.sh" },
            { "<leader>cgd", "<cmd>GoAddTag db<cr>", desc = "tag struct (db)" },
            { "<leader>cgi", "<cmd>GoIfErr<cr>", desc = "add if err" },
            { "<leader>cgj", "<cmd>GoAddTag<cr>", desc = "tag struct (json)" },
            { "<leader>cgm", "<cmd>GoAddTag mapstructure<cr>", desc = "tag struct (mapstructure)" },
            { "<leader>cgs", "<cmd>GoFillStruct<cr>", desc = "fill struct" },
            { "<leader>cgt", group = "test" },
            { "<leader>cgta", "<cmd>GoAddTest<cr>", desc = "add test" },
            { "<leader>cgtf", "<cmd>GoTestFunc<cr>", desc = "test func" },
            { "<leader>cgti", "<cmd>GoTestFile<cr>", desc = "test file" },
            { "<leader>cgw", "<cmd>GoFillSwitch<cr>", desc = "fill switch" },
            { "<leader>ci", "<cmd>lua require('telescope').extensions.goimpl.goimpl{}<cr>", desc = "Implement interface" },
            { "<leader>cj", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Jump next diagnostic" },
            { "<leader>cl", "<cmd>LspRestart<cr>", desc = "Restart LSP" },
            { "<leader>cp", "<cmd>Lspsaga preview_definition<cr>", desc = "Preview definition" },
            { "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
            { "<leader>ct", group = "typescript" },
            { "<leader>ctf", "<cmd>TSToolsFixAll<cr>", desc = "Fix code problems" },
            { "<leader>cti", "<cmd>TSToolsAddMissingImports<cr>", desc = "Add missing imports" },
            { "<leader>ctu", "<cmd>TSToolsRemoveUnused<cr>", desc = "Remove unused imports" },
            { "<leader>d", group = "display" },
            { "<leader>dd", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
            { "<leader>dn", group = "number" },
            { "<leader>dnl", "<cmd>set number!<cr>", desc = "Line numbers" },
            { "<leader>dnr", "<cmd>set relativenumber!<cr>", desc = "Relative line numbers" },
            { "<leader>f", group = "fuzzy" },
            { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", desc = "Buffers" },
            { "<leader>fd", "<cmd>lua require('telescope.builtin').buffers()<cr>", desc = "Buffers" },
            { "<leader>ff", "<cmd>lua require('svrana.telescope').project_files()<cr>", desc = "Find" },
            { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "Help" },
            { "<leader>fn", "<cmd>lua require('svrana.telescope').dots()<cr>", desc = "dotfiles" },
            { "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles()<cr>", desc = "Old files" },
            { "<leader>fr", "<cmd>Rg<cr>", desc = "Search file contents (rg)" },
            { "<leader>fs", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "Search file contents" },
            { "<leader>fz", "<cmd>lua require('telescope.builtin').git_branches()<cr>", desc = "brancheZ" },
            { "<leader>g", group = "git" },
            { "<leader>gb", group = "Blame" },
            { "<leader>gbf", "<cmd>Git blame<cr>", desc = "File" },
            { "<leader>gbl", "<cmd>lua require('gitsigns').blame_line{full=true}<cr>", desc = "Line" },
            { "<leader>gg", "<cmd>lua require('neogit').open()<cr>", desc = "Toggle git" },
            { "<leader>gh", "<cmd>GBrowse<cr>", desc = "gitHub view" },
            { "<leader>gs", "<cmd>lua require('telescope.builtin').git_status()<cr>", desc = "Status" },
            { "<leader>gz", "<cmd>lua require('telescope.builtin').git_branches()<cr>", desc = "brancheZ" },
            { "<leader>h", group = "harpoon" },
            { "<leader>h1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "goto file 1" },
            { "<leader>h2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "goto file 2" },
            { "<leader>h3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "goto file 3" },
            { "<leader>h4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "goto file 4" },
            { "<leader>h5", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", desc = "goto file 5" },
            { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add file" },
            { "<leader>he", "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<cr>", desc = "Edit command" },
            { "<leader>hr", "<cmd>lua require('harpoon.tmux').sendCommand('{bottom-right}', 1)<cr>", desc = "Run command" },
            { "<leader>hs", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Show" },
            { "<leader>n", group = "new" },
            { "<leader>nt", "<cmd>tabnew<cr>", desc = "Tab" },
            { "<leader>p", group = "preview" },
            { "<leader>pg", "<cmd>Glow<cr>", desc = "Glow (markdown)" },
            { "<leader>pl", "<cmd>LLPStartPreview<cr>", desc = "laTEX preview" },
            { "<leader>ps", "<cmd>ComposerStart<cr>", desc = "Start markdown composer" },
            { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
            { "<leader>t", group = "toggle" },
            { "<leader>tc", "<cmd>Neorg toggle-concealer<cr>", desc = "Neorg concealer" },
            { "<leader>th", "<cmd>set invhls hls?<cr>", desc = "search Highlight" },
            { "<leader>tm", "<cmd>MinimapToggle<cr>", desc = "Minimap" },
            { "<leader>tn", "<cmd>set relativenumber!<cr>", desc = "Number" },
            { "<leader>tt", "<cmd>lua require('nvim-tree.api').tree.toggle(false, true)<cr>", desc = "Tree explorer" },
            { "<leader>u", group = "quickfix" },
            { "<leader>uc", "<cmd>cclose<cr>", desc = "Close" },
            { "<leader>uj", "<cmd>cnext<cr>", desc = "Next" },
            { "<leader>uk", "<cmd>cprev<cr>", desc = "Previous" },
            { "<leader>w", "<cmd>w<cr>", desc = "Write file" },
            { "<leader>z", desc = "<cmd>q!<cr>" },
          })
        '';
      }
    ];
  };
}
