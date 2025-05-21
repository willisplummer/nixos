{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ../../modules/home-manager/nvim.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dev";
  home.homeDirectory = "/home/dev";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    git
    bat
    fzf
    ripgrep

    direnv # enables automatically switching into nix-shell dev environments when cd'ing into a repo

    tmux
    tmuxPlugins.vim-tmux-navigator

    # zsh
    zsh
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-autosuggestions

    cargo
    bear
  ];
  wmp224.nvim.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
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

    initContent = lib.mkMerge [
      # initExtraBeforeCompInit
      (lib.mkOrder 550 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
            fi
      '')

      #initExtra
      (lib.mkOrder 800 ''
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
      '')
    ];
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
    ".ignore".source = ../../configs/ignore;
    ".p10k.zsh".source = ../../configs/p10k.zsh;
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nvim";
    ".local/bin/tmux-sessionizer".source = ../../scripts/tmux-sessionizer;
    ".local/bin/tmux-windowizer".source = ../../scripts/tmux-windowizer;
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
