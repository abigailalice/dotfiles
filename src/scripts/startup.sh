#!/bin/sh

# these should create the folders if necessary
echo "source ~/gits/dotfiles/src/shell/fish/main" > ~/.config/fish/config.fish
echo "source-file ~/gits/dotfiles/src/tmux/main" > ~/.tmux.conf
echo "source ~/gits/dotfiles/src/nvim/main.vim" > ~/.config/nvim/init.vim
echo "source ~/gits/dotfiles/src/vim/main" > ~/.vimrc
echo "[include]\n    path = ~/gits/dotfiles/src/git/main" > ~/.gitconfig

