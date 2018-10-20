#!/bin/sh

# for add-apt-repository
sudo apt-get install software-properties-common
# this fixes a problem where we can't add the neovim repo
sudo apt-get install dirmngr --install-recommends

# i'm having issues installing neovim, download the appimage instead

# {{{ Shell navigation 
sudo apt-get install silversearcher-ag
sudo apt-get install ranger
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


# }}}
# {{{ Networking tools
# }}}

sudo apt-get install curl, silversearcher-ag, ranger


# install dein script
# curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
# sh ./installer.sh ~

