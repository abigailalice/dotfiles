
function fish_prompt
    # could also do (hostname)

    set -l last_status $status

    if [ (whoami) = "root" ]
        printf (set_color red)
        printf "root"
        printf $c0
        printf " "
    end

    # Current time
    printf (date "+$c2%H$c0:$c2%M$c0:$c2%S ")
    if [ $last_status -ne 0 ]
        error last $last_status
        set -ge status
    end

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

    # Show loadavg when too high
    set -l load1m (uptime | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
    set -l load1m_test (math $load1m \* 100 / 1)
    if test $load1m_test -gt 100
        error load $load1m
    end

    # Show number of jobs
    set -l jobs (jobs | wc -l | tr -d ' ')
    if test $jobs -ge "1"
        error jobs $jobs
    end

    # Show disk usage when low
    set -l du (df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 5 | cut -d'%' -f1)
    if test $du -gt 80
        error du $du%%
    end

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

        if test $git_dirty -ne "0"
            set git_branch "$ce$git_branch~$git_dirty"
        end
        if test $git_commits_ahead -ne "0"
            set git_branch "$git_branch$ce↑$git_commits_ahead"
        end
        if test $git_commits_behind -ne "0"
            set git_branch "$git_branch(set_color red)↓$git_commits_behind"
        end

        section git $git_branch
    end

    printf "\n> "
    set_color black
end

function fish_right_prompt
    printf $c3
    printf (prompt_pwd)
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

