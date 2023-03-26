if not type -q bat
    return
end

set -gx BAT_THEME Catppuccin-macchiato
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

alias cat bat
