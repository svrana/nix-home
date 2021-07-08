{ pkgs, ... }:
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
  # Solarize it
  base03 = "#002b36";
  base02 = "#073642";
  base01 = "#586e75";
  base00 = "#657b83";
  base0 = "#839496";
  base1 = "#93a1a1";
  base2 = "#eee8d5";
  base3 = "#fdf6e3";
  yellow = "#b58900";
  orange = "#cb4b16";
  red = "#dc322f";
  magenta = "#d33682";
  violet = "#6c71c4";
  blue = "#268bd2";
  cyan = "#2aa198";
  green = "#859900";
  solCSS = "${pkgs.solarized-everything-css}/share/css";
in
{
  programs.qutebrowser = {
    enable = true;
    #package = pkgsUnstable.qutebrowser;
    #loadAutoConfig = true;
    # no per website configuratble stylesheets yet
    #config.set('content.user_stylesheets', '${solCSS}/solarized-dark-github.css', '*://github.com/')
    extraConfig = ''
      c.tabs.padding = {"top": 7, "bottom": 7, "left": 5, "right": 5}
      config.bind("<Escape>", "mode-leave", mode="passthrough")
      config.load_autoconfig()
    '';
    searchEngines = {
        DEFAULT ="https://duckduckgo.com/?q={}";
        #DEFAULT = "https://neeva.com/search?q={}";
        d = "https://duckduckgo.com/?q={}";
        n = "https://neeva.com/search?q={}";
        g = "http://www.google.com/search?hl=en&q={}";
        gh = "https://github.com/search?q={}";
        yt = "https://www.youtube.com/results?search_query={}";
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
        "<Ctrl-;>" = "open-editor";
      };
      normal = {
        "<Ctrl-d>" = "scroll-page 0 -0.5";
        "<Ctrl-f>" = "scroll-page 0 0.5";
        "<Ctrl-h>" = "tab-next";
        "<Ctrl-s>" = "tab-prev";
        "<Ctrl-b>" = "config-source";
        "<Ctrl-m>" = "spawn --detach mpv --force-window yes {url}";
        "<Ctrl-y>" = "hint links spawn --detach mpv --force-window yes {hint-url}";
        "<Ctrl-Shift-i>" = "devtools window";
        "<Ctrl-r>" = "config-cycle content.user_stylesheets '${solCSS}/solarized-dark-all-sites.css' '${solCSS}/solarized-light-all-sites.css' ''";
        "c" = "back";
        "]" = "tab-next";
        "[" = "tab-prev";
        "x" = "tab-close";
        ",q"= "tab-close";
        ",nt" = "open -t";
        ",nw" = "open -w";
        ",l" = "spawn --userscript qute-pass-mod --mode gopass";
        ",u" =  "spawn --userscript qute-pass-mod --mode gopass --username-only --no-insert-mode";
        ",p" = "spawn --userscript qute-pass-mod --mode gopass --password-only --no-insert-mode";
        "{" = "tab-move -";
        "}" = "tab-move +";
        ",t" = "tab-pin";
      };
    };
    settings =  {
      auto_save.session = true;
      completion.height = "35%";
      content = {
        cookies = {
          accept = "no-3rdparty";
        };
        notifications.enabled = false;
        javascript = {
          can_access_clipboard = true;
          can_open_tabs_automatically = true;
        };
      };
      downloads = {
        location.directory = "/home/shaw/Downloads";
        remove_finished = 10;
      };
      fonts = {
        default_size = "13pt";
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
        prompts = "default_size 'System San Francisco Display Regular'";
        tabs = {
          selected = "default_size 'System San Francisco Display Bold'";
          unselected = "default_size 'System San Francisco Display Regular'";
        };
        web.size = {
          default = 19;
          default_fixed = 16;
          minimum = 14;
        };
      };
      scrolling.smooth = true;
      editor = {
        # pulling in from non-overlay
        #command = ["${pkgs.alacritty}/bin/alacritty" "-e" "${pkgs.neovim}/bin/nvim {}"];
        command = ["${pkgs.alacritty}/bin/alacritty" "-e" "nvim {}"];
      };
      #statusbar.show = "in-mode";
      tabs = {
        background = true;
        close_mouse_button = "right";
        last_close = "close";
        pinned.shrink = true;
      };
      hints.leave_on_load = false;
      colors = {
        downloads = {
          bar = {
            bg = "${base03}";
          };
        };
        tabs = {
          bar.bg = "${base01}";
          even = {
            fg = "${base02}";
            bg = "${base01}";
          };
          odd = {
            fg = "${base02}";
            bg = "${base01}";
          };
          selected = {
            even = {
              fg = "white";
              bg = "${base1}";
            };
            odd = {
              fg = "white";
              bg = "${base1}";
            };
          };
        };
        keyhint = {
            bg = "${base03}";
            fg = "${base00}";
            suffix.fg = "${cyan}";
        };
        hints = {
          bg = "${base2}";
          fg = "${base01}";
          match.fg = "${green}";
        };
        messages = {
          error.bg = "${red}";
        };
        statusbar = {
          command.bg = "${base03}";
          normal.bg = "${base03}";
          private.bg = "${base03}";
          url = {
            error.fg = "${red}";
            hover.fg = "${yellow}";
            success = {
              http.fg = "${base01}";
              https.fg = "${cyan}";
            };
            warn = {
              fg = "${yellow}";
            };
          };
        };
        prompts.bg = "${base02}";
        completion = {
          category = {
            bg = "${base01}";
            border = {
              bottom = "${base02}";
              top = "${base02}";
            };
          };
          fg = [ "${base0}" "${base0}" "${base0}" ];
          even.bg = "${base02}";
          odd.bg = "${base02}";
          scrollbar = {
            fg = "${cyan}";
            bg = "${base01}";
          };
          item = {
            selected = {
              bg = "${cyan}";
              border = {
                bottom = "${cyan}";
                top = "${cyan}";
              };
            };
          };
          match = {
            fg = "${magenta}";
          };
        };
        webpage = {
          #prefers_color_scheme_dark = true;
          preferred_color_scheme = "dark";
          #preferred_color_scheme = "dark";
        };
      };
    };
  };

  programs.bash.sessionVariables = {
    TLDEXTRACT_CACHE = "$XDG_CACHE_HOME/tldextract.cache";
  };

  xdg.dataFile."qutebrowser/userscripts/qute-pass-mod".source =
    ./qute-pass-mod.py;

  xdg.configFile."qutebrowser/greasemonkey" = {
    source = ./greasemonkey;
    recursive = true;
  };
}
