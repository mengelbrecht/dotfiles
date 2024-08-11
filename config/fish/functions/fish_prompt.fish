function fish_prompt
    set -l cmd_status $status

    echo -n (set_color $fish_color_cwd)(prompt_pwd --full-length-dirs=3)' '

    set -l prompt_symbol ''
    if fish_is_root_user
        set prompt_symbol '#'
    end

    if test $cmd_status -ne 0
        set_color -o $fish_color_error
    else
        set_color -o $fish_color_normal
    end
    echo -n $prompt_symbol' '
    set_color normal
end
