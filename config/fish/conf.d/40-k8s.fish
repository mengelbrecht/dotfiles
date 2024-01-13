if type -q kubectl
    alias k kubectl
end

if type -q k9s
    alias k9s "k9s --readonly"
    alias k9s-rw "command k9s"
end
