{ config, pkgs, ... }:

{
  imports = [./zsh.nix ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "arekkas";
  home.homeDirectory = "/home/arekkas";

  home.packages = with pkgs; [
    htop
    starship
    feh
    brave
    alacritty
    firefox
    pcmanfm
    exa
    rofi
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = [
      pkgs.vimPlugins.vim-nix
    ];
 };


 home.file."config.py" = {
   target = ".config/qtile/config.py";
   source = ./configs/qtile/config.py;
   recursive = true;
 };

 home.file."alacritty.yaml" = {
   target = ".config/alacritty/alacritty.yml";
   source = ./configs/alacritty/alacritty.yml;
   recursive = true;
 };

 home.file."starship.toml" = {
   target = ".config/starship.toml";
   source = ./configs/starship/starship.toml;
   recursive = true;
 };


  home.stateVersion = "21.03";
}
