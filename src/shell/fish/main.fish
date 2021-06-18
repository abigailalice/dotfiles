# ln -s $HOME/Home/gits/dotfiles/src/shell/fish/main.fish ~/.config/fish/config.fish
#
# {{{ SETTINGS/STARTUP
# run ssh-agent if necessary, and make it available to other shells
# if [ !(set -q SSH_AGENT_PID) ]
#     eval (ssh-agent -c)
#     ssh-add
#     set -Ux SSH_AGENT_PID $SSH_AGENT_PID
#     set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
# end

# no idea why i need to do this. it just got removed from my path one day
set PATH /opt/homebrew/bin $PATH
set PATH /usr/local/bin $PATH
set PATH /Library/PostgreSQL/13/bin $PATH
set PATH /Users/$USER/.local/bin $PATH
# ln -s /Library/PostgreSQL/13/bin/psql /usr/local/bin/psql

# this doesn't restart tmux if you detach the window; only when fish sources its
# rc file
function launch_tmux
    if status --is-interactive
        if not set -q TMUX
            if tmux ls > /dev/null
                tmux attach-session
            else
                tmux new -A -s main
            end
        end
    end
end
launch_tmux


set -g STACKTEMPLATE ~/Home/gits/dotfiles/src/stack/stack_template.hsfiles

alias ghcide 'stack exec -- ghcid --restart=package.yaml --restart=stack.yaml'

function man
    if count $argv > /dev/null
        /usr/bin/man $argv
    else
        /usr/bin/man (apropos . | sed 's/([0-9]*) .*//' | fzf --preview 'man {}')
    end
end

function history
    set -l cmd (builtin history | fzf)
    if test -n "$cmd"
        eval "$cmd"
    end
end

# this is a search
function vimrg
    nvim (rg -l $argv[1] | fzf --multi --preview "rg $argv[1] --context 3 --color always -n {}")
end

function cd
    if count $argv > /dev/null
        builtin cd $argv
    else
        if git rev-parse --git-dir > /dev/null 2>&1
            set -l ROOTDIR (git rev-parse --show-toplevel)
            set -l PATH (fd . $ROOTDIR -t d | sed "s|$ROOTDIR/||g" | fzf \
                | sed "s|\(.*\)|$ROOTDIR/\1|g")
            if test -n "$PATH"
                builtin cd $PATH
            end
        else
            set -l PATH (fd . -t d | fzf)
            if test -n "$PATH"
                builtin cd $PATH
            end
        end
    end
end

function cd-fzf-from
    if not count $arv > /dev/null
        set -l ROOTDIR $argv[1]
        set -l PATH (fd . $ROOTDIR -t d | sed "s|$ROOTDIR/||g" | fzf \
            | sed "s|\(.*\)|$ROOTDIR/\1|g")
        if set -q PATH
            builtin cd $PATH
        end
    end
end

alias ls 'ENV EXA_COLORS="gm=38;5;111:da=38;5;111" exa --long --git --header'

alias su 'su -m'
alias sudo 'sudo -H'
alias mkdir 'mkdir -p'
# modifies ranger to exit to the selected directory
# [1] https://stackoverflow.com/questions/18807813/how-to-port-ranger-cd-function-to-fish-shell
alias ranger 'ranger --choosedir=$HOME/.rangerdir; set RANGERDIR (cat $HOME/.rangerdir); cd $RANGERDIR'
# funcsave ranger


# }}}
# {{{ SETTINGS/THEMES
# -- taken from: http://geraldkaszuba.com/tweaking-fish-shell/

set fish_color_error ff8a00

# c0 to c4 progress from dark to bright
# ce is the error colour
set -g c0 (set_color 005284)
set -g c1 (set_color 0075cd)
set -g c2 (set_color 009eff)
set -g c3 (set_color 6dc7ff)
set -g c4 (set_color ffffff)
set -g ce (set_color $fish_color_error)

function _common_section
    #printf $c0
    #printf ", "
    printf $c1
    printf $argv[1]
    printf $c0
    printf ":"
    printf $c2
    printf $argv[2]
    printf $argv[3]
    printf " "
end

function section
    _common_section $argv[1] $c3 $argv[2] $ce
end

function error
    _common_section $argv[1] $ce $argv[2] $ce
end
# }}}
# {{{ SETTINGS/PROMPT
function fish_prompt
    # could also do (hostname)

    set -g GIT_ROOT (git rev-parse --show-toplevel 2> /dev/null)

    # Current time
    # printf (date "+$c2%H$c0:$c2%M$c0:$c2%S ")

    background_jobs
    low_disk_usage
    load_average_high
    nesting_level 2


    if set -q VIRTUAL_ENV
        section env (basename "$VIRTUAL_ENV")
    end

    # set the cabal sandbox for use by cabal, and show it in the prompt
    # set -l sandbox (haskell-sandbox '%s')
    # if [ "." != $sandbox ]
    #     set -gx CABAL_SANDBOX_CONFIG $sandbox
    #     set -l sandboxName (haskell-sandbox '%n')
    #     if [ "malcolmgooding" != $sandboxName ]
    #         section "box" $sandboxName
    #     end
    # else
    #     error box "n/a"
    #     set -ex CABAL_SANDBOX_CONFIG
    # end

    set -l git_branch (git rev-parse --abbrev-ref HEAD ^ /dev/null)
    if test $git_branch
        set -l git_dirty (git status --porcelain ^ /dev/null | wc -l | tr -d ' ')
        set -l git_commits_ahead (git rev-list HEAD...origin ^ /dev/null | wc -l | tr -d ' ')
        set -l git_commits_behind (git rev-list HEAD..origin ^ /dev/null | wc -l | tr -d ' ')

        # set -l git_repo (git config --get remote.origin.url | sed 's/\.git//' | sed 's/.*\///')
        set -l git_repo (git rev-parse --show-toplevel | sed 's/.*\///')
        set git_branch "$git_repo/$git_branch"

        if test $git_dirty -ne "0"
            set git_branch "$ce$git_branch~$git_dirty"
        end
        if test $git_commits_ahead -ne "0"
            set git_branch "$git_branch$ce↑$git_commits_ahead"
        end
        if test $git_commits_behind -ne "0"
            set git_branch "$git_branch"(set_color red)"↓$git_commits_behind"
        end

        set -g GIT_STATUS $git_branch
        section git $git_branch
    end

    # section "temp" (osx-cpu-temp)

    printf "\n"
    fullpath
    printf "> "
end

function fullpath
    if [ (whoami) = "root" ]
        printf (set_color red)
    else
        printf $c2
    end

    printf (whoami)
    printf "@"
    printf (hostname -s)
    printf ":"
    printf (prompt_pwd)
end

function low_disk_usage
    # Show disk usage when low
    set -l du (df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 5 | cut -d'%' -f1)
    if test $du -gt 80
        error du $du%%
    end
end

function slow_command
    # Show if the most recent command took over 10 seconds
    if test $CMD_DURATION
        # drop the millisecond portion of CMD_DURATION
        set -l taken (echo $CMD_DURATION | sed -n 's/...$/s/p')
        if test $CMD_DURATION -gt 10000
            error taken $taken
            # this doesnt seem to make noise anymore
            tput bel
        end
    end
end

# might be worthwhile to show nesting depth
function nesting_level
    if [ $SHLVL -gt $argv ]
        error "shell" (math $SHLVL - $argv)
    end
end

function load_average_high
    # Show loadavg when too high
    set -l load1m (uptime | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
    set -l load1m_test (math $load1m \* 100 / 1)
    if test $load1m_test -gt 100
        error load $load1m
    end
end

function background_jobs
    # Show number of jobs
    set -l jobs (jobs | wc -l | tr -d ' ')
    if test $jobs -ge "1"
        error jobs $jobs
    end
end

function laststatus
    set -l last_status $status
    if [ $last_status -ne 0 ]
        error last $last_status
        set -ge status
    end
end

function fish_right_prompt
    slow_command
    laststatus
    set_color grey

end

# -- set git stuff: https://wiki.archlinux.org/index.php/Fish#Configuration_Suggestions
# fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
# # Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '-'
set __fish_git_prompt_char_upstream_behind '+'
# }}}
# {{{ SETTINGS/DEFAULT TOOLS
set -gx EDITOR nvim
set -gx MANPAGER less
# }}}

# {{{ FUNCTIONS/AlIASES/PATH/ENVIRONMENT
if [ -d ~/.local/bin ]; set -gx PATH ~/.local/bin $PATH; end
if [ -d ~/.cargo/bin ]; set -gx PATH ~/.cargo/bin $PATH; end
function rg-fzf
    # second positional argument is the search directory
    rg -n $argv[1] | sed 's#\([^:]\+\):\([^:]\+\):.*#\1:\2#' \
        | fzf -d : --nth 1 --preview='rg -n --color always "'$argv[1]'|\$" {1} | tail -(math {2} - $LINES / 2)'
    #rg -n $argv[1] | sed 's#\([^:]\+\):\([^:]\+\):.*#\1:\2#' \
    #    | fzf -d : --nth 1 --preview='cat -n {1} | tail -(math {2} - $LINES / 2) | rg --color always \''$argv[1]'|\$\' | grep '
end
# }}}

