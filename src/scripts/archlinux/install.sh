#!/bin/sh

# arguments:
#  $USER
#  $DOTFILES_REPO

# {{{ helper functions
#
function writeFile {
    if [ ! -d $(dirname $2) ]; then sudo -H -u $1 mkdir -p $(dirname $2); fi
    sudo -H -u $1 tee -a $2 > /dev/null
}
# }}}

# {{{ comments
# a basic goal of this script is that it should be packaged together with its
# dotfiles. this is an issue, since if it clones the git repo it won't
# necessarily get the correct version. the best solution i can come up with is
# either:
# 1) clone the local repo to the vagrant box using a file provisioner
# 2) figure out the version hash of the local repo, then clone the global
#    version of that hash
# i don't like either of these solutions, as they give a 'modifying global
# variables' type of smell, but I'm not sure how to do it better.
#
# another problem is cloning the repo using a commit hash (either the most recent
# or a specific named hash) prevents us from making changes to the script without
# them being commited. this prevents 
#
# i would also like this script to work independently of vagrant, which should
# help narrow the possibile solutions
#
# goals:
#  1) when run on a new system, install programs and setup dotfiles, assuming the
#  dotfiles repo exists
#  2) when run on an existing system, install programs and setup dotfiles, using
#  the existing (possibly not up to date) repo
#
# workflows it needs to support:
# 1) test changes to dotfiles on existing VM, then destroy/create new VM, *without*
#    first commiting changes to repository. this requires some way to persist
#    the repo working directory even after tearing down the VM, without persisting
#    it through a commit to github. restating this, it should be possible to create
#    a VM that mirrors the current VM, without reliance on a VCS.
# 2) install on a completely new system, with no access to the repo except via
#    the internet. this might be best accomplished with two scripts:
#     1) download the repo
#     2) copy dotfiles to appropriate locations, install necessary programs
#    the second is what i basically have setup already. neither of these steps
#    are reliant on vagrant
# 3) 
#
# this script assumes the existence of
# step 0: setup git, as its necessary to download other files from git repo
# step 1: setup ssh server when necessary
# step 2: setup dotfiles
# }}}

HOME="/home/vagrant"
DOTFILES_SRC="/home/vagrant/Home/Dotfiles/src"

pacman -Syu
pacman -S --noconfirm --needed git
# {{{ setup env variable and dotfile repo used by rest of script
# }}}
echo -e "[include]\n    path = $DOTFILES_SRC/git/main" | writeFile vagrant $HOME/.gitconfig

# {{{ neovim
pacman -S --noconfirm --needed neovim
echo "source $DOTFILES_SRC/nvim/main.vim" | writeFile vagrant $HOME/.config/nvim/init.vim
# sudo -H -u vagrant nvim +PlugInstall +qall
# }}}
# {{{ tmux
pacman -S --noconfirm --needed tmux
echo "source-file $DOTFILES_SRC/tmux/main" | writeFile vagrant $HOME/.tmux.conf
# }}}
# {{{ fish
pacman -S --noconfirm --needed fish
echo "source $DOTFILES_SRC/shell/fish/main.fish" | writeFile vagrant $HOME/.config/fish/config.fish
chsh -s /usr/bin/fish vagrant
# }}}
# vagrant
if [ ! -d /vagrant ]; then pacman -S --noconfirm --needed vagrant; fi
# {{{ super common programming tools
pacman -S --noconfirm --needed make
pacman -S --noconfirm --needed gcc
# }}}
# exa
pacman -S --noconfirm --needed exa
alias ls 'exa -l --header --git'
# download
pacman -S --noconfirm --needed curl wget
# search
pacman -S --noconfirm --needed ripgrep fzf fd
# interactive
pacman -S --noconfirm --needed ncdu ranger lynx weechat
# {{{ haskell toolchain
pacman -S --noconfirm --needed stack
stack build ghc

# }}}

