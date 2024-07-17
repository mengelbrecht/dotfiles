function fish_right_prompt
    if test "$PROMPT_TRANSIENT" = "1"
        return
    end

    if test -n "$SSH_TTY"
        echo -n (set_color $fish_color_redirection)'⟨ '
        echo -n (set_color $fish_color_user)$USER(set_color normal)'@'(set_color $fish_color_host)(prompt_hostname)
    end

    if test $CMD_DURATION -gt 2000
        echo -n (set_color $fish_color_option)' ⟨ '
        echo -n (set_color yellow)$CMD_DURATION'ms'
    end

    set_color normal
end
