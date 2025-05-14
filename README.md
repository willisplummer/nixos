# NIXOS Dotfiles
This is currently the configuration specifically for my thinkpad running hyprland on nixos.

I'm planning to modularize this config a bit so that I can make it work for my macbook that uses nix and home-manager.

## To Update Packages
```
nix flake update
sudo nixos-rebuild switch --flake ~/nix --update
```

### Handling Build Issue
Recently ran into an error where electron 31 was EOL and that was preventing the nixos-rebuild from completing.

To debug, I ran the command again with `--show-trace`, which revealed what pkg was dependent on the outdated electron version. I commented out that pkg and it worked.

I think I could theoretically write a custom flake for the pkg, PR it into the nixpkgs repo, etc. But I wasn't actually using it (due to its slowness as an electron app)

## To-Do
### P1
- [ ] hyprlock doesn't complete before laptop hybernates when closing the lid - [issue](https://github.com/hyprwm/hyprlock/issues/633) and [2](https://github.com/hyprwm/hyprlock/issues/547)
  - NOTE: looks like this has been fixed in hypridle - just waiting for the new release
  - still doesn't work for me as of 5/13/25
- [x] configure ssh profiles in home-manager
- [x] low power alerts at 15 and 5%
- [x] open my apps to the right workspaces on launch - https://wiki.hyprland.org/FAQ/#how-do-i-autostart-my-favorite-apps
  - https://wiki.hyprland.org/Configuring/Window-Rules/
  - or just write a bash script to do it and run the script with exec-once
  - terminal in 1, browser in 2, supersonic in 9, bitwarden in 10

### P2
- [ ] mac-style alt+left, alt+right, alt+delete to jump forward and backward, delete one whole word, shift delete for whole line
- [ ] up and down navigation through autocomplete options not working
- [ ] setup syncthing for obsidian vault
- [ ] todo list solution (do i just cave and install todoist gui even though it's not FOSS?)
- [ ] disable firefox password manager (https://mozilla.github.io/policy-templates/ and https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265)
  - enable bitwarden extension through home-manager?
- [x] figure out why nvim is folding markdown by default (and turn it off)

### P3
- [ ] configure thunar shortcuts bar to reference downcased home dir folders, make file progress open in a floating window
  - is there a better file explorer for tiling window managers? -- [nnn](https://github.com/jarun/nnn?tab=readme-ov-file)
- [ ] style waybar
- [ ] style dunst
- [ ] refactor nix flake stuff to be more modular
- [ ] get macbook home-manager running from the same repo
- [ ] Improve README documentation
- [ ] look into the best strategies around hard-drive partitioning

## Bugs
- [x] hyprlock doesn't lock monitor (just the laptop screen)
- [x] when hyprlock screen is displayed, laptop doesn't hybernate on lid close

## Docs
- https://nixos-and-flakes.thiscute.world/preface
- https://github.com/FlafyDev/nixos-config/blob/9b4e9062a526d0e205d994b8078687aba1678590/modules/display/hyprland/default.nix#L99
- https://github.com/typecraft-dev/dotfiles/blob/master/hyprland/.config/hypr/hyprland.conf


