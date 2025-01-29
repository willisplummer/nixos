{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.wmp224.nvim;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.wmp224.nvim.enable = mkEnableOption "Enable wmp224's custom nvim config";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ripgrep
    ];
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;
    programs.neovim.viAlias = true;
    programs.neovim.vimAlias = true;
    programs.neovim.vimdiffAlias = true;
    # Essentially just getting rid of Mason and treesitter from lazy
    programs.neovim.plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
    programs.neovim.extraPackages = [
      pkgs.lua-language-server
      pkgs.nodePackages_latest.vscode-json-languageserver
      pkgs.luajitPackages.jsregexp
      pkgs.stylua
      pkgs.nil
      pkgs.nixfmt-rfc-style
      pkgs.rustc
      pkgs.cargo
      pkgs.prettierd
      pkgs.rust-analyzer
      pkgs.typescript-language-server
      pkgs.ccls
      pkgs.zls
    ];
  };
}
