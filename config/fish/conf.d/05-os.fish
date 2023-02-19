switch (uname)
    case Darwin
        alias o open
        alias clearDNS "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
        alias code "/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
    case Linux
    case '*'
end
