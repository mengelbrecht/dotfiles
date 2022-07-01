if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
else
    set -gx EDITOR vim
    set -gx VISUAL vim
end

set -gx PAGER less
set -gx LESS "-F -g -i -M -R -S -w -X -z-4"
set -gx LESSHISTFILE -

alias code "~/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias v "$EDITOR"

if type -q bat
    set -gx BAT_THEME TwoDark
end
