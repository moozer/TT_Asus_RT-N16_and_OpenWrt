#!/sbin/sh
echo updating feeds
./scripts/feeds update

# enable buildins
./scripts/feeds install nano
echo "enable as buildin: utilities -> Editors -> nano"
./scripts/feeds install luci
echo "enable as buildin: Luci -> 1. Collections -> <*> Luci"

# enable other modules
./scripts/feeds install bandwidthd
echo "enable as buildin: Utilities -> <M> bandwidthd"
./scripts/feeds install tcpdump
echo "enable as buildin: Network -> <M> Tcpdump"
./scripts/feeds install ettercap
echo "enable as buildin: Network -> <M> Ettercap"

# other changes
echo "change default package dir: [*] Image -> [*] Version Configuration > Release repository: http://ittech.eal.dk/openwrt/packages"

