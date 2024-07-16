if type -q starship
    function starship_transient_prompt_func
        starship module character
    end

    starship init fish | source
    enable_transience
else
    function reset_transient --on-event fish_postexec
        set -g PROMPT_TRANSIENT 0
    end

    function transient_execute
        if commandline --is-valid
            set -g PROMPT_TRANSIENT 1
            commandline -f repaint
        else
            set -g PROMPT_TRANSIENT 0
        end
        commandline -f execute
    end

    bind --user \r transient_execute
end
