{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home-manager/nvim.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "wmp224";
  home.homeDirectory = "/home/wmp224";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/music";
    pictures = "${config.home.homeDirectory}/pictures";
    videos = "${config.home.homeDirectory}/videos";
    publicShare = null;
    templates = null;
    extraConfig = {
      XDG_CODE_DIR = "${config.home.homeDirectory}/code";
      XDG_WALLPAPER_DIR = "${config.home.homeDirectory}/wallpaper";
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    git
    bat
    fzf
    ripgrep

    pamixer
    playerctl
    pulseaudio

    light
    brightnessctl

    feh # image viewer/preview tool -- not wayland native
    imv # wayland native image viewer

    # jellyfin music players
    # feishin -- note: electron dependency was causing problems
    supersonic-wayland

    #terminals
    wezterm
    kitty
    ghostty

    direnv # enables automatically switching into nix-shell dev environments when cd'ing into a repo

    todoist # cli, free and opensource

    tmux
    tmuxPlugins.vim-tmux-navigator

    # zsh
    zsh
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-autosuggestions

    cargo
    bear

    bitwarden-desktop

    hyprpaper
    hypridle
    hyprlock
    hyprland-qtutils

    wl-clipboard
    grimblast
    waybar
    wofi

    neofetch
  ];
  wmp224.nvim.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 16;
  };
  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    settings = {
      gtk-tabs-location = "hidden";
      font-family = "MesloLGM Nerd Font";
      font-size = 11;
      scrollback-limit = 10000;
      window-theme = "ghostty";
      window-decoration = false;
      confirm-close-surface = false;
      shell-integration = "zsh";
      resize-overlay = "never";
      background-opacity = 0.8;
      background-blur-radius = 20;
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "photoassist.com" = {
        host = "*.rightspro.com";
        user = "ubuntu";
        identityFile = "/home/wmp224/.ssh/photoassist.pem";
      };
      "archive.meredithmonk.org" = {
        host = "*.meredithmonk.org";
        user = "willisplummer";
        identityFile = "/home/wmp224/.ssh/mmgcloud";
      };
    };
  };

  programs.waybar.enable = true;
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 25;
      margin-left = 5;
      margin-right = 5;
      margin-top = 5;
      margin-bottom = 0;
      spacing = 1;
      reload-style-on-change = "true";

      modules-left = [
        "hyprland/workspaces"
        "tray"
      ];
      modules-center = [ ];
      modules-right = [
        "network"
        "battery"
        "cpu"
        "memory"
        "temperature"
        "backlight"
        "wireplumber"
        "clock"
        "custom/separator"

        "idle_inhibitor"
        "pulseaudio"
        #"bluetooth"
        #"group/custom-group"

        "custom/separator"
        "custom/power"
      ];

      "group/custom-group" = {
        orientation = "horizontal";
        modules = [
          "idle_inhibitor"
          "pulseaudio"
          "bluetooth"
          # "custom/bluetooth"
          # "custom/kdeconnect"
          # "custom/wifi"
        ];
      };

      "hyprland/workspaces" = {
        "on-click" = "activate";
        "active-only" = false;
        "all-outputs" = true;
        "format" = "{icon}";
        "format-icons" = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
          "7" = "󰠮";
          "8" = "";
          "9" = "";
          "10" = "";
        };
      };

      "tray" = {
        "icon-size" = 16;
        "spacing" = 5;
        "show-passive-items" = true;
      };

      "temperature" = {
        "critical-threshold" = 80;
        "interval" = 2;
        "format" = " {temperatureC:>2}°C";
        "format-icons" = [
          ""
          ""
          ""
        ];
        "on-click" = "hyprctl dispatcher togglespecialworkspace monitor";
      };

      "cpu" = {
        "interval" = 2;
        "format" = " {usage:>2}%";
        "on-click" = "hyprctl dispatcher togglespecialworkspace monitor";
      };

      "memory" = {
        "interval" = 2;
        "format" = " {:>2}%";
      };

      "disk" = {
        "interval" = 15;
        "format" = "󰋊 {percentage_used:>2}%";
      };

      "backlight" = {
        "format" = "{icon} {percent:>2}%";
        "format-icons" = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };

      "network" = {
        "interval" = 1;
        "format-wifi" = "  {bandwidthTotalBytes:>2}";
        "format-ethernet" = "{ipaddr}/{cidr} ";
        "tooltip-format-wifi" = " {ipaddr} ({signalStrength}%)";
        "tooltip-format" = "{ifname} via {gwaddr} ";
        "format-linked" = "{ifname} (No IP) ";
        "format-disconnected" = "󰀦 Disconnected";
        "format-alt" = "{ifname}: {ipaddr}/{cidr}";
      };

      "pulseaudio" = {
        "format" = "{icon} {volume}%";
        "format-bluetooth" = "{icon} {volume}% 󰂯";
        "format-bluetooth-muted" = "󰖁 {icon} 󰂯";
        "format-muted" = "󰖁 {volume}%";
        "format-icons" = {
          "headphone" = "󰋋";
          "hands-free" = "󱡒";
          "headset" = "󰋎";
          "phone" = "";
          "portable" = "";
          "car" = "";
          "default" = [
            ""
            ""
            ""
          ];
        };
        "on-click" = "pavucontrol";
      };

      "wireplumber" = {
        "format" = "{icon} {volume:>3}%";
        "format-muted" = "󰖁 {volume:>3}%";
        "format-icons" = [
          ""
          ""
          ""
        ];
      };

      "idle_inhibitor" = {
        "format" = "{icon}";
        "format-icons" = {
          "activated" = "󰈈";
          "deactivated" = "󰈉";
        };
      };

      "custom/power" = {
        "format" = "{icon}";
        "format-icons" = " ";
        "exec-on-event" = "true";
        "on-click" = "$HOME/scripts/rofi-power";
        "tooltip-format" = "Power Menu";
      };

      "custom/kdeconnect" = {
        "format" = "{icon}";
        "format-icons" = "";
        "exec-on-event" = "true";
        "on-click" = "kdeconnect-app";
        "tooltip-format" = "KDE Connect";
      };

      "custom/bluetooth" = {
        "format" = "{icon}";
        "format-icons" = "";
        "exec-on-event" = "true";
        "on-click" = "$HOME/scripts/rofi-bluetooth";
        "tooltip-format" = "Bluetooth Menu";
      };

      "custom/wifi" = {
        "format" = "{icon}";
        "format-icons" = "";
        "exec-on-event" = "true";
        "on-click" = "$HOME/scripts/rofi-wifi";
        "tooltip-format" = "Wifi Menu";
      };

      "custom/separator" = {
        "format" = "{icon}";
        "format-icons" = "|";
        "tooltip" = false;
      };

      "custom/notification" = {
        "tooltip" = false;
        "format" = "{icon} {}";
        "format-icons" = {
          "notification" = "<span foreground='red'><sup></sup></span>";
          "none" = "";
          "dnd-notification" = "<span foreground='red'><sup></sup></span>";
          "dnd-none" = "";
          "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
          "inhibited-none" = "";
          "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
          "dnd-inhibited-none" = "";
        };
        "return-type" = "json";
        "exec-if" = "which swaync-client";
        "exec" = "swaync-client -swb";
        "on-click" = "swaync-client -t -sw";
        "on-click-right" = "swaync-client -d -sw";
        "escape" = true;
      };

      "keyboard-state" = {
        "numlock" = true;
        "capslock" = true;
        "format" = "{name} {icon}";
        "format-icons" = {
          "locked" = "";
          "unlocked" = "";
        };
      };

      "wlr/taskbar" = {
        "format" = "{icon}";
        "icon-size" = 18;
        "tooltip-format" = "{title}";
        "on-click" = "activate";
        "on-click-middle" = "close";
        "ignore-list" = [
          "ghostty"
          "kitty"
          "wezterm"
          "foot"
          "footclient"
        ];
      };

      "battery" = {
        "states" = {
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{capacity}% {icon}";
        "format-charging" = " {capacity}%";
        "format-plugged" = " {capacity}%";
        "format-alt" = "{icon} {time}";
        "format-icons" = [
          ""
          ""
          ""
          ""
          ""
        ];
      };

      "backlight/slider" = {
        "min" = 0;
        "max" = 100;
        "orientation" = "horizontal";
        "device" = "intel_backlight";
      };

    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key to turn on the display
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 350;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 420;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          monitor = "eDP-1";
          path = "${config.home.homeDirectory}/wallpaper/illustration-rain-futuristic-city.png";

          blur_passes = 1; # 0 disables blurring
          blur_size = 7;
          noise = 1.17e-2;
        }
      ];
      input-field = {
        monitor = "eDP-1";
        size = "200,50";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.2)";
        font_color = "rgb(111, 45, 104)";
        fade_on_empty = false;
        rounding = -1;
        check_color = "rgb(30, 107, 204)";
        placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
        hide_input = false;
        position = "0, -100";
        halign = "center";
        valign = "center";
      };
    };
  };

  programs.wofi.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      variables = [ "--all" ];
    };
    settings =
      let
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        pactl = "${pkgs.pulseaudio}/bin/pactl";
        pamixer = "${pkgs.pamixer}/bin/pamixer";
        brightnessctl = "${pkgs.lib.getExe pkgs.brightnessctl}";
        volume-brightness = "/home/wmp224/.local/bin/volume-brightness";
      in
      {
        "$mod" = "SUPER";
        "$menu" = "wofi --show drun";
        "$terminal" = "ghostty";
        "$fileManager" = "thunar";
        "$browser" = "firefox";
        "$lock" = "hyprlock";
        general = {
          border_size = 1;
          gaps_in = 5;
          gaps_out = 5;
        };
        decoration = {
          rounding = 0;
        };
        monitor = [
          "eDP-1, 1920x1080@60, 0x0, 1"
          ", preferred, auto, 1"
        ];
        input = {
          repeat_delay = 200;
          repeat_rate = 50;
          follow_mouse = 0;
          touchpad = {
            natural_scroll = true;
          };
        };
        misc = {
          disable_splash_rendering = true;
          disable_hyprland_logo = true;
        };
        bind =
          [
            "$mod, Q, exec, $terminal"
            "$mod, F, exec, $fileManager"
            "$mod, W, killactive"
            "$mod, SPACE, exec, $menu"
            "$mod SHIFT, L, exec, $lock"
            "$mod, B, exec, $browser"
            "$mod, ESCAPE, exec, dunstctl close-all"

            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, j, movefocus, d"
            "$mod, k, movefocus, u"

            ", Print, exec, grimblast copy area"

          ]
          ++ (builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 10
          ));

        # l -> work even when screen is locked
        bindl = [
          ",XF86AudioMute, exec, ${volume-brightness} volume_mute"
          ",XF86AudioMicMute, exec, ${volume-brightness} mic_mute" # NOTE: couldn't get this one to work
        ];

        # e -> repeat enabled
        bindle = [
          ",XF86AudioRaiseVolume, exec, ${volume-brightness} volume_up"
          ",XF86AudioLowerVolume, exec, ${volume-brightness} volume_down"
          ",XF86MonBrightnessUp, exec, ${volume-brightness} brightness_up"
          ",XF86MonBrightnessDown, exec, ${volume-brightness} brightness_down"
        ];

        "exec-once" = [
          #greetd auto-logs us in and then we start hyprlock
          #if hyprlock fails, we just kill the session
          "hyprlock || hyprctl dispatch exit"
          "hypridle"
          "hyprpaper"
          "blueman-tray"
          "nm-applet"
          "battery-notify"
          "[workspace 1 silent] $terminal -e neofetch"
          "[workspace 2 silent] $browser"
          "[workspace 10 silent] bitwarden"
        ];
      };
  };
  services.blueman-applet.enable = true;
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = false;
      preload = [
        "~/wallpaper/illustration-rain-futuristic-city.png"
      ];
      wallpaper = [
        ",~/wallpaper/illustration-rain-futuristic-city.png" # NOTE: leading comma means apply to all monitors
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Willis Plummer";
    userEmail = "willisplummer@gmail.com";
    ignores = [
      ".DS_Store"
    ];
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      vim = "nvim";
      vi = "nvim";

      cat = "bat";

      nvm = "echo 'you cant use nvm or anything like it on nixos'";

      # GIT
      g = "git";
      ga = "git add";
      gd = "git diff";
      gb = "git branch";
      gcl = "git clone";
      gco = "git checkout";
      gcob = "git checkout -b";
      gc = "git commit --verbose";
      gl = "git pull";
      gp = "git push";
      gpsup = "git push --set-upstream origin $(git_current_branch)";
      gst = "git status";
      gsta = "git stash push";
      gstaa = "git stash apply";
      gstc = "git stash clear";
      gstl = "git stash list";
      gstp = "git stash pop";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }

      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }

      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions";
      }
    ];

    history = {
      size = 10000;
      path = "$HOME/.zhistory";
      save = 10000;
      share = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
    };

    initExtraBeforeCompInit = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    initExtra = ''
      git_current_branch () {
        local ref
        ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
        local ret=$?
        if [[ $ret != 0 ]]
        then
                [[ $ret == 128 ]] && return
                ref=$(command git rev-parse --short HEAD 2> /dev/null)  || return
        fi
        echo ''${ref#refs/heads/}
      }

      export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
      export PATH=$PATH:$HOME/.stack/programs/
      export PATH=$PATH:$HOME/.local/bin
      export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
      export PATH="$HOME/.pyenv/shims:$PATH"

      export LUA_PATH="$HOME/.local/share/nvim:$LUA_PATH"

      source ~/.p10k.zsh

      setopt HIST_VERIFY

      # keybindings
      bindkey -s ^f "tmux-sessionizer\n"

      # completion using arrow keys (based on history)
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      bindkey '^[[1;3D' backward-word
      bindkey '^[[1;3C' forward-word
      bindkey '^[^?' backward-kill-word

      source ~/.local/bin/todoist_functions_fzf
    '';
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-a";
    mouse = true;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.power-theme;
        extraConfig = "set -g @tmux_power_theme 'cyan'";
      }
    ];

    extraConfig = ''
      set -as terminal-features ",xterm-256color:RGB"

      unbind %
      bind | split-window -h

      unbind '"'
      bind - split-window -v

      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5

      bind -r m resize-pane -Z

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel 'reattach-to-user-namespace pbcopy'

      unbind -T copy-mode-vi MouseDragEnd1Pane

      set -g @resurrect-capture-pane-contents 'on' # allow tmux-ressurect to capture pane contents
      set -g @continuum-restore 'on' # enable tmux-continuum functionality

      bind-key -r f run-shell "tmux neww ~/.local/bin/tmux-sessionizer"
    '';
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "README.md".source = ../../README.md;
    "wallpaper/illustration-rain-futuristic-city.png".source =
      ../../configs/wallpaper/illustration-rain-futuristic-city.png;
    ".ignore".source = ../../configs/ignore;
    ".p10k.zsh".source = ../../configs/p10k.zsh;
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nvim";
    ".local/bin/tmux-sessionizer".source = ../../scripts/tmux-sessionizer;
    ".local/bin/tmux-windowizer".source = ../../scripts/tmux-windowizer;
    ".local/bin/volume-brightness".source = ../../scripts/volume-brightness;
    ".local/bin/battery-notify".source = ../../scripts/battery-notify;
    ".local/bin/todoist_functions_fzf".source =
      pkgs.fetchFromGitHub {
        owner = "sachaos";
        repo = "todoist";
        rev = "a05b353979def33f538dd307e3570897cf9d5ab3";
        sha256 = "sha256-+UECYUozca7PKKiTrmPAobSF0y6xnWYCGaChk9bwANg=";
      }
      + "/todoist_functions_fzf.sh";

    # You can also set the file content immediately.
    ".gradle/gradle.properties".text = ''
      org.gradle.console=verbose
      org.gradle.daemon.idletimeout=3600000
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/willisplummer/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
