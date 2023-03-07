if test -d /opt/homebrew-intel
    set -g homebrew /opt/homebrew-intel
else if test -d /opt/homebrew
    set -g homebrew /opt/homebrew
else if test -d "$HOME/.homebrew"
    set -g homebrew "$HOME/.homebrew"
else if test -f /usr/local/bin/brew
    set -g homebrew /usr/local
else if test -d /home/linuxbrew/.linuxbrew
    set -g homebrew /home/linuxbrew/.linuxbrew
end

if test -d $homebrew
    fish_add_path "$homebrew/bin"

    if test -d "$homebrew/opt/coreutils/libexec/gnubin"
        fish_add_path "$homebrew/opt/coreutils/libexec/gnubin"
    end

    set -gx HOMEBREW_NO_ANALYTICS 1
    set -gx HOMEBREW_NO_ENV_HINTS 1
    set -gx HOMEBREW_INSTALL_BADGE " "

    if test (whoami) = "mengelbrecht"
        set -gx HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/Brewfile"
    else
        set -gx HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/Brewfile.2"
    end
    alias brewup "brew update && brew upgrade && brew cleanup"
end
