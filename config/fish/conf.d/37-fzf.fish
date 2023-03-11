if not type -q fzf
    return
end

set -gx FZF_DEFAULT_COMMAND 'fd --hidden --exclude ".git" --exclude ".svn" --exclude ".DS_Store" --type f --strip-cwd-prefix'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --color=dark,fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe,info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef'

function vf
    set -l out $(fzf +i --exact --preview 'bat --style=full --color=always {}' --preview-window 'down,~4,+{2}+4/2')
    if test $status -eq 0
        v "$out"
    end
end

function vfi
    set -l out $(rg . --line-number --column --no-heading | fzf --exact --delimiter : --preview 'bat --style=full --color=always --highlight-line {2} {1}' --preview-window 'down,~4,+{2}+4/2')
    if test $status -eq 0
        v "$(string join ":" $(string split : -m 4 -f 1-3 "$out"))"
    end
end

function cdf
    set -l out $(fd --hidden --exclude ".git" --exclude ".svn" --type d | fzf)
    if test $status -eq 0
        cd -- "$out"
    end
end

function find-files
    set -l out $(fzf --multi)
    if test $status -eq 0
        for f in $out
            commandline -it -- ' '
            commandline -it -- $f
        end
        commandline -f repaint
    end
end

function find-history
    set -l out $(history -z | fzf --read0 --print0 -q "$(commandline)")
    if test $status -eq 0
        commandline -- $out
    end
end

bind \ct find-files
bind \cr find-history
