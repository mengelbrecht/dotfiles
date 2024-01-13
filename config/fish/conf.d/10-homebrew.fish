if test -d /opt/homebrew
    set -g homebrew /opt/homebrew
else if test -f /usr/local/bin/brew
    set -g homebrew /usr/local
else if test -d /home/linuxbrew/.linuxbrew
    set -g homebrew /home/linuxbrew/.linuxbrew
end

if not test -d $homebrew
    return
end

fish_add_path "$homebrew/bin"

if test -d "$homebrew/opt/coreutils/libexec/gnubin"
    fish_add_path "$homebrew/opt/coreutils/libexec/gnubin"
end

switch (uname)
    case Darwin
        for i in 11 17 21
            if test -d "$homebrew/opt/openjdk@$i/libexec/openjdk.jdk" && not test -e "$HOME/Library/Java/JavaVirtualMachines/openjdk-$i.jdk"
                ln -s "$homebrew/opt/openjdk@$i/libexec/openjdk.jdk" "$HOME/Library/Java/JavaVirtualMachines/openjdk-$i.jdk"
            end
        end

        set -l jdk_home (/usr/libexec/java_home -v11 2> /dev/null)
        if test $status -eq 0
            set -gx JAVA_HOME $jdk_home
        end
end

set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx HOMEBREW_INSTALL_BADGE " "

if test (whoami) = mgee
    set -gx HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/Brewfile.2"
else
    set -gx HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/Brewfile"
end
alias brewup "brew update && brew upgrade && brew cleanup"
