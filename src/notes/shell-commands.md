
= Vim
== Get statusline on inactive windows blank
=== FZF/Denite
        Make CtrlP-style window close on backspace on empty line
    Color
        Dark color schemes
        Dim inactive panes Tmux-style
        Semantic coloring
        Dim distant paragraphs
        Dark 81-column on non-text buffers
    Panes
        Get Tmux-style pane separator on inactive panes (replacing statusline)
        Make Help open in current pane
        Make terminals open another buffer on close
SSH
    start tmux immediately
tmux
    start nvim immediately
    restart shell when pane contents are terminated
= shell tools
== shells
=== zsh
==== fish
==== zsh
==== xonsh
== sysadmin
=== cron
== shell navigation
=== ranger
=== cd
== search
also try fzy
=== fd      #non-interactive #file-name     #regex
=== fzf     #interactive     #stream        #fuzzy
=== grep    #non-interactive #stream        #regex
=== ag      #non-interactive #file-contents #regex
=== ripgrep #non-interactive #file-contents #regex
    
fzf examples
    man (man -k . | sed 's/ .*//' | fzf --preview='man {}')
    whatis -s 1 -r .
Shell
    Find tools
        fzf # fuzzy searcher of stdin, highly composable
        fd # regex-based searcher of filenames
        grep        # regex-based searcher of file contents
        ag          # regex-based searcher of file contents
        ripgrep     # regex-based searcher of file contents
            http://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before/

