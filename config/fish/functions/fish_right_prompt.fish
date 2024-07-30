function fish_right_prompt
    if test "$PROMPT_TRANSIENT" = "1"
        return
    end

    if test -n "$SSH_TTY"
        echo -n (set_color $fish_color_redirection)'⟨ '
        echo -n (set_color $fish_color_user)$USER(set_color normal)'@'(set_color $fish_color_host)(prompt_hostname)
    end

    if command -sq git; and test -f '.git/HEAD'
        set -l ref (string replace -r '.*/' '' (cat '.git/HEAD'))
        echo -n (set_color $fish_color_cwd)' ⟨ '(set_color normal)''(set_color $fish_color_param)' '$ref
        if not git diff --quiet --ignore-submodules HEAD 2> /dev/null
            echo -n (set_color $fish_color_error)'*'
        end
    end

    if test $CMD_DURATION -gt 3000
        echo -n (set_color $fish_color_option)' ⟨ '
        echo -n (set_color normal)'⏳ '(set_color $fish_color_cwd)$CMD_DURATION'ms'
    end

    set_color normal
end
