if type -q hx
    set -gx EDITOR hx
    set -gx VISUAL hx
else if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
else
    set -gx EDITOR vim
    set -gx VISUAL vim
end

set -gx PAGER less
set -gx LESS "-F -g -i -M -R -S -w -X -z-4"
set -gx LESSHISTFILE -

alias v "$EDITOR"
