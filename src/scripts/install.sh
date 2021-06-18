#!/bin/sh

function backup
{
    mv $1 "$1.bak-$(date +%F_%T.%N | sed 's|\.\(....\).*|\.\1|')"
}

# checks if the target of copy already exists, and if so renames it as a backup
# rather than simply clobbering it
function safe-tee
{
    if [ -f $1 ]; then
        backup $1
    fi
    cat | sudo tee $2
}

# {{{ not-installed
# wrapper around `which`, which is silent when the program is already installed
function not-installed
{
    if not which $1 > /dev/null; then
        printf "Installing $1"
        return 0
    else
        return 1
    fi
}
# }}}

# {{{ install programs

# for add-apt-repository
if not-installed add-apt-repository; then
    sudo apt-get install software-properties-common
fi
if not-installed dirmngr; then
    # this fixes a problem where we can't add the neovim repo
    sudo apt-get install dirmngr --install-recommends
fi

# shells
# {{{ zsh
if not-installed zsh; then
    sudo apt-get install zsh
    sh -c "(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
# }}}
# {{{ fish
if not-installed fish; then
    curl -L https://get.oh-my.fish > install
    fish install --path=~/.local/share/omf --config=~/.config/omf
fi

# }}}
# shell navigation 
# {{{ exa
# }}}
# {{{ command-not-found
if not-installed command-not-found; then
    sudo apt-get install command-not-found
    sudo update-command-not-found
fi
# }}}
# search
# {{{ ag
if not-installed ag; then
    sudo apt-get install silversearcher-ag
fi
# }}}
# {{{ fd
if not-installed fd; then
    curl -L0 https://github.com/sharkdp/fd/releases/download/v7.2.0/fd-mus_7.2.0_amd64.deb
    sudo dpkg -i ./fd-mus_7.2.0_amd64.deb
fi
# }}}
# {{{ ripgrep
if not-installed rg; then
    curl -L0 https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb
    sudo dpkg -i ripgrep_0.10.0_amd64.deb
fi
# }}}
# {{{ fzf
if not-installed fzf; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi
# }}}
# {{{ fzy
# }}}
# session managers
# {{{ dtach
# }}}
# {{{ abduco/dvtm
# }}}
# {{{ i3/xpra
if not-installed i3; then
    sudo apt-get install i3 suckless-tools
    sudo update-alternatives --config x-window-manager /usr/bin/i3
fi
# }}}
# {{{ tmux
# tmuxinator
# tpm
# }}} 
# interactive
# {{{ lynx
if not-installed lynx; then
    sudo apt-get install lynx
fi
# }}}
# {{{ ranger
if not-installed ranger; then
    sudo apt-get install ranger
fi
# }}}
# {{{ weechat
if not-installed weechat; then
    sudo apt-get install weechat
fi
# }}}
# {{{ ncdu
if not-installed ncdu; then
    sudo apt-get install ncdu
fi
# }}}
# containers
# {{{ virtualbox
if not-installed vboxmanage; then
    sudo apt-get install 
    curl -L https://download.virtualbox.org/virtualbox/5.2.20/virtualbox-5.2_5.2.20-125813~Debian~stretch_amd64.deb > vbox5.2.deb
    sudo dpkg -i vbox5.2.deb
    rm vbox5.2.deb
fi
# }}}
# {{{ vagrant
if not-installed vagrant; then
    curl https://releases.hashicorp.com/vagrant/2.2.0/vagrant_2.2.0_x86_64.deb \
        > tmp.deb
    sudo dpkg -i tmp.deb
    rm tmp.deb
fi
# }}}
# networking tools
# {{{ curl, wget
if not-installed curl; then
    sudo apt-get install curl
fi
if not-installed wget; then
    sudo apt-get install wget
fi
# }}}
# ssh
# {{{ openssh
if not-installed ssh; then
    sudo apt-get install openssh
fi
# }}}
# {{{ googleauthenticator
if not-installed google-authenticator; then
    sudo apt-get install libpam-googleauthenticator
    google-authenticator
fi
# }}}
# {{{ fail2ban
if not-installed fail2ban-client; then
    sudo apt-get install fail2ban
fi
# }}}
# languages
# {{{ haskell/stack
if not-installed stack; then
    echo stack
    curl -sSL https://get.haskellstack.org/ | sh
fi
# }}}
# {{{ rust
if not-installed cargo; then
    curl https://sh.rustup.rs -sSf | sh
    set -Ux PATH $HOME/.cargo/bin $PATH
fi
# }}}
# }}}
DOTFILES="/home/$USER/Home/gits/dotfiles/src"
# {{{ deploy user dotfiles

# these should create the folders if necessary
echo "source $DOTFILES/shell/fish/main.fish" > ~/.config/fish/config.fish
echo "source $DOTFILES/shell/zsh/main" > ~/.zshrc
echo "source-file $DOTFILES/tmux/main" > ~/.tmux.conf
echo "source $DOTFILES/nvim/main.vim" > ~/.config/nvim/init.vim
echo -e "[include]\n    path = $DOTFILES/git/main" > ~/.gitconfig
echo "Include $DOTFILES/ssh/ssh_config" > ~/.ssh/config
ln -fs $DOTFILES/stack/main.yaml $USER/.stack/config.yaml

# }}}
# {{{ sshd config
# TODO this should replace the port number of the sshd_config file
cat "$DOTFILES/ssh/sshd_config" | safe-tee "/etc/ssh/sshd_config"
cat "$DOTFILES/ssh/pamd_sshd" | safe-tee "/etc/pam.d/sshd"
function setup-parental-controls
{
    echo "sshd;*;*;Al$(printf %02d $1)00-$(printf %02d $2)00" \
        | safe-tee /etc/security/time.conf
    echo "0 $2 * * * root pkill -u ably -x sshd" \
        | sudo tee /etc/cron.d/parental-controls > /dev/null
    echo "Sleeping to check cron syntax"
    sleep 90
    sudo grep cron /var/log/syslog | tail
}
setup-parental-controls 9 15

# }}}

# }}}

