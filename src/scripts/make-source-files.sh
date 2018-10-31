#!/bin/sh

# this script should be idemopotent

DOTFILES="~/Home/gits/dotfiles/src"

# these should create the folders if necessary
echo "source $DOTFILES/shell/fish/main.fish" > ~/.config/fish/config.fish
echo "source $DOTFILES/shell/zsh/main" > ~
echo "source-file $DOTFILES/tmux/main" > ~
echo "source $DOTFILES/nvim/main.vim" > ~/.config/nvim/init.vim
echo "source $DOTFILES/vim/main" > ~
echo "[include]\n    path = $DOTFILES/git/main" > ~
echo "Include $DOTFILES/ssh/ssh_config" > ~/.ssh/config
cat "$DOTFILES/ssh/pamd_sshd" | sudo tee "/etc/pam.d/sshd" > /dev/null
cat "$DOTFILES/ssh/sshd_config" | sudo tee "/etc/ssh/sshd_config" > /dev/null

chsh -s /usr/bin/fish

