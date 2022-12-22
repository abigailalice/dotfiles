#!/bin/sh

symlnk () {
    sudo mkdir -p $(dirname $2)
    sudo ln -s $1 $2
}

symlnk $HOME/gits/dotfiles/src/i3 $HOME/.config/i3/config
symlnk $HOME/gits/dotfiles/src/nvim/main.vim $HOME/.config/nvim/init.vim
symlnk $HOME/gits/dotfiles/src/termite.desktop $HOME/.local/share/applications/termite.desktop
symlnk $HOME/gits/dotfiles/src/configuration.nix /etc/nixos/configuration.nix
symlnk $HOME/gits/dotfiles/src/home.nix $HOME/.config/nixpkgs/home.nix

