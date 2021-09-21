#!/bin/sh

sudo rm /etc/nixos/configuration.nix
sudo ln -s $HOME/nixos/configuration.nix /etc/nixos
sudo nixos-rebuild switch

nix-channel --add https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install

rm -rf $HOME/.config
mkdir -p $HOME/.config/nixpkgs && ln -s $HOME/nixos/* $HOME/.config/nixpkgs/

home-manager switch
