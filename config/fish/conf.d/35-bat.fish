if not type -q bat
    return
end

set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
