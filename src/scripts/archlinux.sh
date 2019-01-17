#!/bin/sh

DOTFILES="/home/$USER/Home/gits/dotfiles/src"
echo -e "[include]\n    path = $DOTFILES/git/main" > ~/.gitconfig

# {{{ neovim
pacman -S --noconfirm neovim
echo "source $DOTFILES/nvim/main.vim" > ~/.config/nvim/init.vim
# }}}
# {{{ tmux
pacman -S --noconfirm tmux
echo "source-file $DOTFILES/tmux/main" > ~/.tmux.conf
# }}}
# {{{ fish
pacman -S --noconfirm fish
echo "source $DOTFILES/shell/fish/main.fish"
# }}}
# {{{ stack
# pacman -S --noconfirm vagrant
# download
pacman -S --noconfirm curl wget
# search
pacman -S --noconfirm ripgrep fzf fd
# interactive
pacman -S --noconfirm ncdu ranger lynx weechat


