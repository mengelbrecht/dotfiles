if not type -q bat
    return
end

set -gx BAT_THEME Catppuccin-macchiato
set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -l man -p'"

alias cat bat
