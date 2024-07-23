switch (uname)
    case Darwin
        alias o open
        alias clearDNS "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
        alias code "/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
        alias b64 'base64 -b 76 -i'
    case Linux
    case '*'
end
