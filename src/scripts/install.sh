#!/bin/sh

sudo update-alternatives --config x-window-manager /usr/bin/i3

# for add-apt-repository
sudo apt-get install software-properties-common
# this fixes a problem where we can't add the neovim repo
sudo apt-get install dirmngr --install-recommends


# i'm having issues installing neovim, download the appimage instead

# shells
# {{{ zsh
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "source ~/gits/dotfiles/src/shell/zsh/main" >> ~/.zshrc
# }}}
# {{{ fish
curl -L https://get.oh-my.fish > install
fish install --path=~/.local/share/omf --config=~/.config/omf
# }}}
# shell navigation 
# {{{ exa
# }}}
# {{{ command-not-found
sudo apt-get install command-not-found
# }}}
# search
# {{{ ag
sudo apt-get install silversearcher-ag
# }}}
# {{{ fd
# }}}
# {{{ ripgrep
# }}}
# {{{ fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
# }}}
# {{{ fzy
# }}}
# session managers
# {{{ dtach
# }}}
# {{{ abduco/dvtm
# }}}
# {{{ i3/xpra
sudo apt-get install i3 suckless-tools
# }}}
# {{{ tmux
# tmuxinator
# tpm
# }}} 
# interactive
# {{{ lynx
# }}}
# {{{ ranger
sudo apt-get install ranger
# }}}
# {{{ weechat
sudo apt-get install weechat
# }}}


# Networking tools
# {{{ curl, wget
sudo apt-get install curl, wget
# }}}

# ssh
# {{{ openssh
sudo apt-get install openssh
# }}}
# {{{ googleauthenticator
sudo apt-get install libpam-googleauthenticator
google-authenticator
sudo echo "auth required pam_google_authenticator.so" >> /etc/pam.d/ssh.d
# }}}
# {{{ fail2ban
sudo apt-get install fail2ban
# }}}

# {{{ i3
# }}}


# languages
# {{{ haskell/stack
curl -sSL https://get.haskellstack.org/ | sh
# }}}
# {{{ rust
curl https://sh.rustup.rs -sSf | sh
# }}}
