# {{{ SETTINGS/STARTUP
# run ssh-agent if necessary, and make it available to other shells
# if [ !(set -q SSH_AGENT_PID) ]
#     eval (ssh-agent -c)
#     ssh-add
#     set -Ux SSH_AGENT_PID $SSH_AGENT_PID
#     set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
# end

if [ -d ~/.local/bin ]; set PATH ~/.local/bin $PATH; end
if [ -d ~/.cargo/bin ]; set PATH ~/.cargo/bin $PATH; end

# }}}
# {{{ SETTINGS/THEMES
# -- taken from: http://geraldkaszuba.com/tweaking-fish-shell/

alias su='su -m'
alias sudo='sudo -H'
alias mkdir='mkdir -p'

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

        section git $git_branch
    end

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
    printf (hostname)
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
        error nested_shell (math $SHLVL - $argv)
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
    background_jobs
    low_disk_usage
    load_average_high
    slow_command
    laststatus
    nesting_level 2
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
# {{{ FUNCTIONS
function rg-fzf
    # second positional argument is the search directory
    rg -n $argv[1] | sed 's#\([^:]\+\):\([^:]\+\):.*#\1:\2#' \
        | fzf -d : --nth 1 --preview='rg -n --color always "'$argv[1]'|\$" {1} | tail -(math {2} - $LINES / 2)'
    #rg -n $argv[1] | sed 's#\([^:]\+\):\([^:]\+\):.*#\1:\2#' \
    #    | fzf -d : --nth 1 --preview='cat -n {1} | tail -(math {2} - $LINES / 2) | rg --color always \''$argv[1]'|\$\' | grep '
end
# }}}

