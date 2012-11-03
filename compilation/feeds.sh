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
echo "enable as module: Utilities -> <M> bandwidthd"
./scripts/feeds install tcpdump
echo "enable as module: Network -> <M> Tcpdump"
./scripts/feeds install ettercap
echo "enable as module: Network -> <M> Ettercap"
./scripts/feeds install block-mount
echo "enable as module: Base system -> <M> block-mount"
echo "enable fdisk: Utilities -> disc -> <M> fdisk"
echo "enable kmod-fs-vfat: Kernel modules -> Filesystems -> <M> kmod-fs-vfat"

# other changes
echo "change default package dir: [*] Image -> [*] Version Configuration > Release repository: http://ittech.eal.dk/openwrt/packages"
