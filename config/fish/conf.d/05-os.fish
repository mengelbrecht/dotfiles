switch (uname)
    case Darwin
        alias o open
        alias clearDNS "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
    case Linux
    case '*'
end
