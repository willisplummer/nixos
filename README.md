#NIXOS Dotfiles
This is currently the configuration specifically for my thinkpad running hyprland on nixos.

I'm planning to modularize this config a bit so that I can make it work for my macbook that uses nix and home-manager.

##To-Do
###P1
- [ ] low power alerts at 15 and 5%
- [ ] mac-style alt+left, alt+right, alt+delete to jump forward and backward, delete one whole word, shift delete for whole line
- [ ] configure ssh profiles in home-manager
- [ ] setup syncthing for obsidian vault
- [ ] open my apps to the right workspaces on launch - https://wiki.hyprland.org/FAQ/#how-do-i-autostart-my-favorite-apps
  - https://wiki.hyprland.org/Configuring/Window-Rules/
  - or just write a bash script to do it and run the script with exec-once
###P2
- [ ] style waybar
- [ ] style dunst
###P3
- [ ] refactor nix flake stuff to be more modular
- [ ] get macbook home-manager running from the same repo
- [ ] Improve README documentation
- [ ] look into the best strategies around hard-drive partitioning

##Bugs
- [ ] hyprlock doesn't complete before laptop hybernates when closing the lid - [issue](https://github.com/hyprwm/hyprlock/issues/633) and [2](https://github.com/hyprwm/hyprlock/issues/547)
- [x] when hyprlock screen is displayed, laptop doesn't hybernate on lid close

## Docs
- https://nixos-and-flakes.thiscute.world/preface
- https://github.com/FlafyDev/nixos-config/blob/9b4e9062a526d0e205d994b8078687aba1678590/modules/display/hyprland/default.nix#L99
- https://github.com/typecraft-dev/dotfiles/blob/master/hyprland/.config/hypr/hyprland.conf


