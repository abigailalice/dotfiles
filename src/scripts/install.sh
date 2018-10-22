#!/bin/sh

sudo update-alternatives --config x-window-manager /usr/bin/i3

# for add-apt-repository
sudo apt-get install software-properties-common
# this fixes a problem where we can't add the neovim repo
sudo apt-get install dirmngr --install-recommends


# i'm having issues installing neovim, download the appimage instead

# {{{ shells
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "source ~/gits/dotfiles/src/shell/zsh/main" >> ~/.zshrc

curl -L https://get.oh-my.fish > install
fish install --path=~/.local/share/omf --config=~/.config/omf
# }}}
# {{{ Shell navigation 
sudo apt-get install silversearcher-ag
sudo apt-get install ranger
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# }}}
# {{{ Networking tools
sudo apt-get install curl
# }}}
# {{{ GUI tools
sudo apt-get install i3 suckless-tools
# }}}


