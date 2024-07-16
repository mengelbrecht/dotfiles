function fish_right_prompt
    if not command -sq git
        set_color normal
        return
    end

    if not set -l git_dir (command git rev-parse --git-dir 2>/dev/null)
        set_color normal
        return
    end

    set -l commit ''
    if set -l action (fish_print_git_action "$git_dir")
        set commit (command git rev-parse HEAD 2> /dev/null | string sub -l 7)
    end

    # Get either the branch name or a branch descriptor.
    set -l branch_detached 0
    if not set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
        set branch_detached 1
        set branch (command git describe --contains --all HEAD 2>/dev/null)
    end

    set -l porcelain_status (command git status --porcelain 2>/dev/null | string sub -l2)

    set_color -o

    if test -n "$branch"
        if test $branch_detached -ne 0
            set_color brmagenta
        else
            set_color green
        end
        echo -n " $branch"
    end
    if test -n "$commit"
        echo -n ' '(set_color yellow)"$commit"
    end
    if test -n "$porcelain_status"
        echo -n (set_color yellow)' *'
    end
   
    set_color normal
end
