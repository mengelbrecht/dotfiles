if not type -q tmux
    return
end

alias tmux "tmux -f '$XDG_CONFIG_HOME/tmux/tmux.conf'"

function tm -d "attach tmux to default session"
    if tmux has -t default &>/dev/null
        tmux -u attach -t default
    else
        tmux -u new -s default
    end
end

set -gx TMUX_TMPDIR "$XDG_RUNTIME_DIR"
