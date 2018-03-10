#1/bin/sh
target=vpn2.wems.co.uk 
debug="ipsec isakmp engine"
case $1 in 
on|enable)
    for item in $debug ; do 
        echo debug crypto $item | ssh $target -tt
    done
    ;;
off|disable)
    for item in $debug ; do
        echo no debug crypto $item | ssh $target -tt
    done
    ;;
status)
    ssh $target show debug
    echo
    ;;
*)
    echo "$0 enable|disable|status"
    ;;
esac
