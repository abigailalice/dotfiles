#!/usr/bin/fish

# for add-apt-repository
if not which add-apt-repository
    sudo apt-get install software-properties-common
end
if not which dirmngr
    # this fixes a problem where we can't add the neovim repo
    sudo apt-get install dirmngr --install-recommends
end

# shells
# {{{ zsh
if not which zsh
    sudo apt-get install zsh
    sh -c "(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
end
# }}}
# {{{ fish
if not which fish
    curl -L https://get.oh-my.fish > install
    fish install --path=~/.local/share/omf --config=~/.config/omf
end
# }}}
# shell navigation 
# {{{ exa
# }}}
# {{{ command-not-found
if not which command-not-found
    sudo apt-get install command-not-found
    sudo update-command-not-found
end
# }}}
# search
# {{{ ag
if not which ag
    sudo apt-get install silversearcher-ag
end
# }}}
# {{{ fd
if not which fd
    curl -L0 https://github.com/sharkdp/fd/releases/download/v7.2.0/fd-mus_7.2.0_amd64.deb
    sudo dpkg -i ./fd-mus_7.2.0_amd64.deb
end
# }}}
# {{{ ripgrep
if not which rg
    curl -L0 https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb
    sudo dpkg -i ripgrep_0.10.0_amd64.deb
end
# }}}
# {{{ fzf
if not which fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
end
# }}}
# {{{ fzy
# }}}
# session managers
# {{{ dtach
# }}}
# {{{ abduco/dvtm
# }}}
# {{{ i3/xpra
if not which i3
    sudo apt-get install i3 suckless-tools
    sudo update-alternatives --config x-window-manager /usr/bin/i3
end
# }}}
# {{{ tmux
# tmuxinator
# tpm
# }}} 
# interactive
# {{{ lynx
if not which lynx
    sudo apt-get install lynx
end
# }}}
# {{{ ranger
if not which ranger
    sudo apt-get install ranger
end
# }}}
# {{{ weechat
if not which weechat
    sudo apt-get install weechat
end
# }}}
# {{{ ncdu
if not which ncdu
    sudo apt-get install ncdu
end
# }}}
# containers
# {{{ virtualbox
if not which vboxmanage
    curl -L https://download.virtualbox.org/virtualbox/5.2.20/virtualbox-5.2_5.2.20-125813~Debian~stretch_amd64.deb > vbox5.2.deb
    sudo dpkg -i vbox5.2.deb
    rm vbox5.2.deb
end
# }}}
# networking tools
# {{{ curl, wget
if not which curl
    sudo apt-get install curl
end
if not which wget
    sudo apt-get install wget
end
# }}}
# ssh
# {{{ openssh
if not which ssh
    sudo apt-get install openssh
end
# }}}
# {{{ googleauthenticator
if not which google-authenticator
    sudo apt-get install libpam-googleauthenticator
    google-authenticator
end
# }}}
# {{{ fail2ban
if not which fail2ban-client
    sudo apt-get install fail2ban
end
# }}}
# languages
# {{{ haskell/stack
if not which stack
    echo stack
    curl -sSL https://get.haskellstack.org/ | sh
end
# }}}
# {{{ rust
if not which cargo
    curl https://sh.rustup.rs -sSf | sh
    set -Ux PATH $HOME/.cargo/bin $PATH
end
# }}}
