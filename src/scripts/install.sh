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

# enable ssh only from 10am-7pm
0 10 * * * /etc/init.d/ssh start
0 19 * * * /etc/init.d/ssh stop

# /etc/init.d/ssh 

# install dein script
# curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
# sh ./installer.sh ~

