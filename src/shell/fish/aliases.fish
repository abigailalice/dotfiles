
function ghcif
    ghcid --command="stack ghci $argv"
end

function haddock
    stack haddock --open #argv[0]
end


# this is necessary to ensure that we are running the right version of cabal.
# i'm not sure if i want to prefer a version of cabal that is itself sandboxed,
# or a truly globaly installed version. the lts-stackage version of cabal is
# older, and behaviour seems to vary significantly between versions. i'm opting
# for the newer for the time being
# set -gx PATH $HOME/.cabal-sandbox/bin $PATH
# set -gx PATH $HOME/Library/Haskell/bin $PATH
# set -gx PATH $HOME/.local/bin $PATH

# this is necessary to ensure that after installing vim we are running the
# correct version. this might /not/ be necessary with the new vim install
# script
# set -gx PATH /usr/local/Cellar/vim/7.4.430_1/bin $PATH
# set -gx PATH $PATH $HOME/gits/haskell-sandbox/.cabal-sandbox/bin/
# set -gx PATH $PATH $HOME/gits/microbreak/.cabal-sandbox/bin/

# osx specific
alias ls='ls -AG'

alias ghci='cabal repl'
alias g='git'

# this function conditionally turns off the current sandbox when creating a
# new sandbox, so that you can create a sandbox without accidentally nuking
# an existing one. i might prefer to have this simply raise an error when an
# existing sandbox is found
function cabal
    if [ (count $argv) = 2 ]
        if [ $argv[1] = "sandbox" -a $argv[2] = "init" ]
            #if set -q CABAL_SANDBOX_CONFIG
            #    echo "A sandbox is already active"
            #    return

            set -q CABAL_SANDBOX_CONFIG; and echo "A sandbox is already active."; and return
        end
    end
    command cabal $argv
end

# opens three splits, one wide for vim, one for a big terminal, and one for a
# small terminal
function dev-tmux
    tmux split-window -h -t 0
    #tmux resize-pane -t 0 -x 84
    tmux split-window -v -p 25 -t 1
    tmux select-pane -t 0
end
