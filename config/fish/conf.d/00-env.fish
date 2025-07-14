set -U fish_greeting

set -gx LANGUAGE en
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "$LANG"

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
switch (uname)
    case Darwin
        set -gx XDG_RUNTIME_DIR "$TMPDIR"
    case Linux
        set -gx XDG_RUNTIME_DIR "/run/user/$(id -u)"
end

if test -d /usr/local/bin
    fish_add_path /usr/local/bin
end

if test -d "$HOME/bin"
    fish_add_path "$HOME/bin"
end
