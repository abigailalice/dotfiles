#!/bin/sh

symlnk () {
    sudo mkdir -p $(dirname $2)

    # check if the link already has been created
    if [ -f $1 ]; then
        if [ -L $2 ]; then
            if [ "$(readlink -e $2)" == $1 ]; then
                return
            else
                echo "Symlink already exists, but points to different location $2 -> $(readlink -e $2)"
                exit 1
            fi
        else
            echo "$1 already exists. You may wish to back it up."
            exit 1
        fi
    fi

    sudo ln -s $1 $2
}

symlnk $HOME/gits/dotfiles/src/i3 $HOME/.config/i3/config
symlnk $HOME/gits/dotfiles/src/nvim/main.vim $HOME/.config/nvim/init.vim
symlnk $HOME/gits/dotfiles/src/termite.desktop $HOME/.local/share/applications/termite.desktop
symlnk $HOME/gits/dotfiles/src/configuration.nix /etc/nixos/configuration.nix
symlnk $HOME/gits/dotfiles/src/home.nix $HOME/.config/nixpkgs/home.nix
symlnk $HOME/gits/dotfiles/src/polybar $HOME/.config/polybar/config.ini
symlnk $HOME/gits/dotfiles/src/shell/fish/main.fish $HOME/.config/fish/config.fish
symlnk $HOME/gits/dotfiles/src/shell/zsh/main $HOME/.zshrc
symlnk $HOME/gits/dotfiles/src/shell/bash/bashrc $HOME/.bashrc
symlnk $HOME/gits/dotfiles/src/xsession $HOME/.xsession

