#!/bin/sh

MYIPADDRESS="192.168.1.123"
ROUTERIPADDRESS="192.168.1.1"
INTERFACE="eth0"
INTERFACESCRIPT="IfStuffAsRoot.sh"
TEMPDATADIR="/home/moz/Downloads/asus_rt-n16"
WRT="DDWRT"
INITIALDIR=$(pwd)

# file to get

if [ "$WRT" = "OpenWrt" ]; then
	# - OpenWrt
	INETLOCATION="http://openwrt.razvi.ro/attitude_adjustment_asus_rt-n16_svn_r30776/"
	IMAGEFILE="openwrt-brcm4716-squashfs.trx"
else
	# - DDWRT
	INETLOCATION="ftp://dd-wrt.com/others/eko/BrainSlayer-V24-preSP2/2011/12-20-11-r18024/broadcom_K26/"
	IMAGEFILE="dd-wrt.v24-18024_NEWD-2_K2.6_mini_RT-N16.trx"
fi;

# ---- temp dir handling
mkdir -p $TEMPDATADIR
cd $TEMPDATADIR

# ---- get image file
echo Retrieving image from $INETLOCATION$IMAGEFILE

if [ ! -e $IMAGEFILE ]; then
	wget $INETLOCATION$IMAGEFILE
else
	echo file already exists, not downloading
fi

if [ ! -e $IMAGEFILE ]; then
	echo something whent wrong while downloading
	echo location $INETLOCATION
	echo filename $IMAGEFILE
	ls
	exit
fi

# --- disable interface
echo Checking enabled interfaces
IFCHECKCMD="/sbin/ifconfig | grep Link | awk '{print $1}' | sort | egrep -v 'lo|inet6'"

IFTXT=$(eval $IFCHECKCMD)
while [ -n "$IFTXT" ]; do
	echo "Interfaces still active"
	eval $IFCHECKCMD
	echo disable in network manager or enable+disable networking to reset interface
	read -p "Press any key to try again" DUMMYVAR
	IFTXT=$(eval $IFCHECKCMD)
done;

# --- set interface values
echo Root privileges now needed...
su -c $INITIALDIR/$INTERFACESCRIPT

while [ $(ping -c 1 $ROUTERIPADDRESS > /dev/null) ]; do
	echo router not found at $ROUTERIPADDRESS
	echo Is cable connected?
	read -p "Press any key to try again" DUMMYVAR
done

echo router found at $ROUTERIPADDRESS

# --- flashing the router
echo uploading to router. file  "$TEMPDATADIR$IMAGEFILE"
cd $TEMPDATADIR
tftp $ROUTERIPADDRESS -c put $IMAGEFILE

echo Do this if power button is NOT blinking
echo 1. Removed power cord
echo 2. press red button
echo 3. reinsert power cord
echo 4. Wait 2 seconds
echo 5. release red button
echo otherwise, wait 10 seconds and powercycle the router

ping -c 1 $ROUTERIPADDRESS
while [ $? ]; do
	echo Waiting for router to be online.
	sleep 2
	ping -c 5 -i 5 $ROUTERIPADDRESS
done

