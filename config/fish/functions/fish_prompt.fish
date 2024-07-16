function fish_prompt
    set -l cmd_status $status
    
    if test -n "$SSH_TTY"
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
    end

    echo -n (set_color yellow)(prompt_pwd)' '

    set_color -o
    if fish_is_root_user
        echo -n (set_color red)'# '
    end

    if test $cmd_status -ne 0
        echo -n (set_color red)'⟩ '
    else
        echo -n (set_color white)'⟩ '
    end
    set_color normal
end
