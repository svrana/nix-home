{ config, pkgs, ... }:
# The following qutebrowser modes are available:
#
#   normal: Default mode, where most commands are invoked.
#
#   insert: Entered when an input field is focused on a website, or by pressing i in normal mode. Passes through
#           almost all keypresses to the website, but has some bindings like <Ctrl-e> to open an external editor.
#           Note that single keys can’t be bound in this mode.
#
#   hint: Entered when f is pressed to select links with the keyboard. Note that single keys can't be bound in this mode.
#
#   passthrough: Similar to insert mode, but passes through all keypresses except <Escape> to leave the mode.
#                It might be useful to bind <Escape> to some other key in this mode if you want to be able to send an Escape
#                key to the website as well. Note that single keys can’t be bound in this mode.
#
#   command: Entered when pressing the : key in order to enter a command. Note that single keys can't be bound in this mode.
#
#   prompt: Entered when there’s a prompt to display, like for download locations or when invoked from JavaScript.
#
#   yesno: Entered when there’s a yes/no prompt displayed.
#
#   caret: Entered when pressing the v mode, used to select text using the keyboard.
#
#   register: Entered when qutebrowser is waiting for a register name/key for commands like :set-mark.
let
  colors = config.my.theme.withHashTag;
  solCSS = "${pkgs.solarized-everything-css}/share/css";
  qutepassmod = pkgs.writers.writePython3Bin "qute-pass-mod" {
    flakeIgnore=["E501" "E402" "E265"];
    libraries = with pkgs.python3.pkgs; [ tldextract ];
  }
    (builtins.readFile ./qute-pass-mod.py);
in
{
  programs.qutebrowser = {
    enable = true;
    package = pkgs.qutebrowser.override { enableWideVine = true; };
    #loadAutoConfig = true;
    # no per website configuratble stylesheets yet
    #config.set('content.user_stylesheets', '${solCSS}/solarized-dark-github.css', '*://github.com/')
    extraConfig = ''
      c.url.default_page = "www.kagi.com";
      c.tabs.padding = {"top": 7, "bottom": 7, "left": 5, "right": 5}
      config.bind("<Escape>", "mode-leave", mode="passthrough")
      config.load_autoconfig()
    '';
    searchEngines = {
      DEFAULT = "https://kagi.com/search?q={}";
      #DEFAULT = "https://duckduckgo.com/?q={}";
      d = "https://duckduckgo.com/?q={}";
      k = "https://kagi.com/search?q={}";
      g = "http://www.google.com/search?hl=en&q={}";
      gh = "https://github.com/search?q={}";
      yt = "https://www.youtube.com/results?search_query={}";
      ho = "https://hoogle.haskell.org/?hoogle={}";
      rs = "https://doc.rust-lang.org/std/index.html?search={}";
      rc = "https://docs.rs/releases/search?query={}";
    };
    keyBindings = {
      command = {
        ",q" = "mode-leave";
        # these don't seem to work :(
        #"<Ctrl-j>" = "completion-item-focus --history next";
        #"<Ctrl-k>" = "completion-item-focus --history prev";
      };
      hint = {
        ",q" = "mode-leave";
      };
      caret = {
        ",q" = "mode-leave";
      };
      passthrough = {
        "<ESCAPE>" = "mode-leave";
      };
      prompt = {
        ",q" = "mode-leave";
      };
      register = {
        ",q" = "mode-leave";
      };
      insert = {
        "<Ctrl-;>" = "edit-text";
      };
      normal = {
        "<Ctrl-b>" = "config-source";
        "<Ctrl-m>" = "spawn --detach umpv {url}";
        "<Ctrl-y>" = "hint links spawn --detach umpv {hint-url}";
        "<Ctrl-Shift-i>" = "devtools window";
        "<Ctrl-r>" = "config-cycle content.user_stylesheets '${solCSS}/solarized-dark-all-sites.css' '${solCSS}/solarized-light-all-sites.css' ''";
        "c" = "back";
        "]" = "tab-next";
        "[" = "tab-prev";
        "x" = "tab-close";
        " q" = "tab-close";
        " nt" = "open -t";
        " nw" = "open -w";
        " l" = "spawn --userscript qute-pass-mod --mode gopass";
        " u" = "spawn --userscript qute-pass-mod --mode gopass --username-only --no-insert-mode";
        " p" = "spawn --userscript qute-pass-mod --mode gopass --password-only --no-insert-mode";
        "{" = "tab-move -";
        "}" = "tab-move +";
        " t" = "tab-pin";
      };
    };
    settings = {
      auto_save.session = true;
      completion.height = "35%";
      content = {
        cookies = {
          accept = "no-3rdparty";
        };
        notifications.enabled = false;
        javascript = {
          clipboard = "access";
          can_open_tabs_automatically = true;
        };
        tls.certificate_errors = "ask-block-thirdparty";
      };
      downloads = {
        location.directory = "${config.home.homeDirectory}/Downloads";
        remove_finished = 10;
      };
      fonts = {
        default_size = config.my.qutebrowser.fonts.size;
        default_family = "DejaVu Sans Mono";
        completion = {
          entry = "default_size 'DejaVu Sans Mono'";
          category = "bold default_size 'DejaVu Sans Mono'";
        };
        debug_console = "default_size 'DejaVu Sans Mono'";
        downloads = "default_size 'DejaVu Sans Mono'";
        hints = "bold default_size 'DejaVu Sans Mono'";
        keyhint = "default_size 'DejaVu Sans Mono'";
        messages = {
          error = "default_size 'DejaVu Sans Mono'";
          info = "default_size 'DejaVu Sans Mono'";
          warning = "default_size 'DejaVu Sans Mono'";
        };
        prompts = "default_size 'SFNS Display Regular'";
        web.size = config.my.qutebrowser.fonts.web.size;
      };
      scrolling.smooth = true;
      editor = {
        command = [ "${config.my.terminal.executable}" "-e" "${pkgs.neovim}/bin/nvim" "{file}" ];
      };
      #statusbar.show = "in-mode";
      tabs = {
        background = true;
        close_mouse_button = "right";
        last_close = "close";
        pinned.shrink = true;
        select_on_remove = "last-used";
      };
      hints.leave_on_load = false;
      colors = {
        downloads = {
          bar = {
            bg = "${colors.base00}";
          };
        };
        tabs = {
          bar.bg = "${colors.base02}";
          even = {
            fg = "${colors.base01}";
            bg = "${colors.base02}";
          };
          odd = {
            fg = "${colors.base01}";
            bg = "${colors.base02}";
          };
          selected = {
            even = {
              fg = "white";
              bg = "${colors.base05}";
            };
            odd = {
              fg = "white";
              bg = "${colors.base05}";
            };
          };
        };
        keyhint = {
          bg = "${colors.base00}";
          fg = "${colors.base03}";
          suffix.fg = "${colors.base0C}";
        };
        hints = {
          bg = "${colors.base06}";
          fg = "${colors.base02}";
          match.fg = "${colors.base0B}";
        };
        messages = {
          error.bg = "${colors.base08}";
        };
        statusbar = {
          command.bg = "${colors.base00}";
          normal.bg = "${colors.base00}";
          private.bg = "${colors.base00}";
          url = {
            error.fg = "${colors.base08}";
            hover.fg = "${colors.base0A}";
            success = {
              http.fg = "${colors.base0A}";
              https.fg = "${colors.base0C}";
            };
            warn = {
              fg = "${colors.base0A}";
            };
          };
        };
        prompts.bg = "${colors.base01}";
        completion = {
          category = {
            bg = "${colors.base02}";
            border = {
              bottom = "${colors.base01}";
              top = "${colors.base01}";
            };
          };
          fg = [ "${colors.base04}" "${colors.base04}" "${colors.base04}" ];
          even.bg = "${colors.base01}";
          odd.bg = "${colors.base01}";
          scrollbar = {
            fg = "${colors.base0C}";
            bg = "${colors.base02}";
          };
          item = {
            selected = {
              bg = "${colors.base0C}";
              border = {
                bottom = "${colors.base0C}";
                top = "${colors.base0C}";
              };
            };
          };
          match = {
            fg = "${colors.base0F}";
          };
        };
        webpage = {
          preferred_color_scheme = "dark";
        };
      };
    };
  };

  home.sessionVariables = {
    TLDEXTRACT_CACHE = "$HOME/.cache/tldextract.cache";
  };

   xdg.configFile."qutebrowser/greasemonkey" = {
    source = ./greasemonkey;
    recursive = true;
  };

  xdg.dataFile."qutebrowser/userscripts/qute-pass-mod".source = "${qutepassmod}/bin/qute-pass-mod";
}
