if not type -q fzf; or not type -q fd; or not type -q rg; or not type -q bat
    return
end

set -g _fd_options fd --hidden --exclude ".git" --exclude ".svn" --exclude ".DS_Store" --strip-cwd-prefix
set -gx FZF_DEFAULT_COMMAND "$_fd_options"
set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796,fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6,marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796'

function _make_path_absolute
    echo (string replace $HOME "~" $PWD)/(string escape --no-quoted $argv[1])
end

function vi
    set -l out (rg --line-number --column --no-heading $argv "." | fzf --nth=4 --multi --exact --delimiter : --preview 'bat --style=full --color=always --highlight-line {2} {1}' --preview-window 'down,~4,+{2}+4/2')
    if test $status -eq 0
        for i in (seq (count $out))
            set -l parts (string split : --max 4 --fields 1-3 "$out[$i]")
            set parts[1] (_make_path_absolute $parts[1])
            set out[$i] "$(string join ":" $parts)"
        end
        v $out
    end
end

function _find-files
    set -l file_type $argv[1]
    set -l execute $argv[2]
    set -l additional_fd_options
    set -l additional_fzf_options
    if test $file_type -eq 1
        set additional_fd_options --type d
        set additional_fzf_options --preview 'lsd --icon always --color always --long --almost-all {}' --preview-window 'down,~4,+{2}+4/2'
    else if test $file_type -eq 2
        set additional_fd_options --type f
        set additional_fzf_options --multi --exact --preview 'bat --style=full --color=always --line-range=:200 {}' --preview-window 'down,~4,+{2}+4/2'
    else
        set additional_fzf_options --multi
    end
    set -l out ($_fd_options $additional_fd_options | fzf $additional_fzf_options)
    if test $status -eq 0
        commandline --replace (string trim --right (commandline))
        for f in $out
            commandline --insert " $(_make_path_absolute $f)"
        end
        if test $execute -eq 1
            commandline --function execute
        end
    end
end

function expand-star-to-fzf -d 'expand ** to trigger fzf'
    set -l cmd (commandline --cut-at-cursor)
    switch $cmd
        case '*\*'
            commandline --replace (string trim --right --chars ' \t*' $cmd)
            switch (commandline)
                case cd
                    _find-files 1 1
                case $EDITOR v
                    _find-files 2 1
                case '*'
                    _find-files 0 0
            end
        case '*'
            commandline --insert '*'
    end
end

function _find-history
    set -l out (history --null | fzf --read0 --print0 --query="$(commandline)")
    if test $status -eq 0
        commandline --replace $out
        commandline --function repaint
    end
end

bind \* expand-star-to-fzf
bind \cr _find-history
