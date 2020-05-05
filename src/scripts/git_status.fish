#!/usr/local/bin/fish

# ln -s $THISFILE /Users/abigailgooding/.local/bin/gitstatus


set -l git_branch (git rev-parse --abbrev-ref HEAD ^ /dev/null)
if test $git_branch
    set -l git_dirty (git status --porcelain ^ /dev/null | wc -l | tr -d ' ')
    set -l git_commits_ahead (git rev-list HEAD...origin ^ /dev/null | wc -l | tr -d ' ')
    set -l git_commits_behind (git rev-list HEAD..origin ^ /dev/null | wc -l | tr -d ' ')

    # set -l git_repo (git config --get remote.origin.url | sed 's/\.git//' | sed 's/.*\///')
    set -l git_repo (git rev-parse --show-toplevel | sed 's/.*\///')
    set git_branch "$git_repo/$git_branch"

    if test $git_dirty -ne "0"
        set git_branch "$git_branch~$git_dirty"
    end
    if test $git_commits_ahead -ne "0"
        set git_branch "$git_branch↑$git_commits_ahead"
    end
    if test $git_commits_behind -ne "0"
        set git_branch "$git_branch↓$git_commits_behind"
    end

    echo $git_branch
end


