if test -d /opt/homebrew-intel
    set homebrew /opt/homebrew-intel
else if test -d "$HOME/.homebrew"
    set homebrew "$HOME/.homebrew"
else if test -f /usr/local/bin/brew
    set homebrew /usr/local
end

if test -d $homebrew
    fish_add_path "$homebrew/bin"

    if test -d "$homebrew/opt/coreutils/libexec/gnubin"
        fish_add_path "$homebrew/opt/coreutils/libexec/gnubin"
    end

    if test -d "$homebrew/opt/openjdk/bin"
        fish_add_path "$homebrew/opt/openjdk/bin"

        set -gx JAVA_HOME "$homebrew/opt/openjdk@18/libexec/openjdk.jdk/Contents/Home"
    end

    set -gx HOMEBREW_NO_ANALYTICS 1
    set -gx HOMEBREW_NO_ENV_HINTS 1
    set -gx HOMEBREW_INSTALL_BADGE " "
    set -gx HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/Brewfile"

    alias brewup "brew update && brew upgrade && brew cleanup"
end
