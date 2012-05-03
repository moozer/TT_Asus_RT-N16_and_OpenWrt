#!/bin/bash

MYIPADDRESS="192.168.1.123"
ROUTERIPADDRESS="192.168.1.1"
INTERFACE="eth0"
INTERFACESCRIPT="IfStuffAsRoot.sh"
TEMPDATADIR="/home/moz/Downloads/asus_rt-n16"
WRT="DebWrt"
INITIALDIR=$(pwd)

# file to get
if [ $WRT = "OpenWrt" ]; then
	# - OpenWrt
	INETLOCATION="http://openwrt.razvi.ro/attitude_adjustment_asus_rt-n16_svn_r30776/"
	IMAGEFILE="openwrt-brcm4716-squashfs.trx"
elif [ $WRT = "DDWRT" ]; then
	# - DDWRT
	INETLOCATION="ftp://dd-wrt.com/others/eko/BrainSlayer-V24-preSP2/2011/12-20-11-r18024/broadcom_K26/"
	IMAGEFILE="dd-wrt.v24-18024_NEWD-2_K2.6_mini_RT-N16.trx"

elif [ $WRT = "DebWrt" ]; then
	# - debwrt
	INETLOCATION="http://dl.dropbox.com/u/29682150/3.2/"
	IMAGEFILE="debwrt-firmware-brcm4716-squashfs-3.2-021412.trx"
else
	echo No valid wrt specified
	exit
fi;


# ---- Function definitions...
function WaitForPingSuccess {
	ping -c 1 $1 > /dev/null
	while [ $? -gt 0 ]; do
		echo Failed to ping $1
		echo Enable network in network manager or plug in cable correctly?
		sleep 5
		ping -q -c 1 $1 > /dev/null
	done
}

function RetrieveImage {
	echo Retrieving image from $INETLOCATION$IMAGEFILE

	if [ ! -e $IMAGEFILE ]; then
		echo Verifying internet connection
		WaitForPingSuccess "google.com"
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
}

function CheckInterfaces {
	echo Checking enabled interfaces
	IFCHECKCMD="/sbin/ifconfig | grep Link | awk '{print $1}' | sort | egrep -v 'lo|inet6'"

	IFTXT=$(eval $IFCHECKCMD)
	while [ -n "$IFTXT" ]; do
		echo "Interfaces still active"
		eval $IFCHECKCMD
		echo disable in network manager or enable+disable networking to reset interface
		sleep 5
		IFTXT=$(eval $IFCHECKCMD)
	done;

}

function FlashRouter {
	echo uploading to router. file  "$TEMPDATADIR/$IMAGEFILE"
	cd $TEMPDATADIR

	echo
	echo "Please do the following"
	echo "- Unplug power cord"
	echo "- press \"restore\" button"
	echo "- reinsert power cord"
	echo "- wait 2 seconds and release button"
	echo the power LED should now be blinking
	read -p "press enter when ready" DUMMYVAR

	tftp $ROUTERIPADDRESS -m binary -c put $IMAGEFILE



}

# ---- temp dir handling
mkdir -p $TEMPDATADIR
cd $TEMPDATADIR

# ---- get image file
RetrieveImage

# --- disable interface
CheckInterfaces

# --- set interface values
echo Root privileges now needed...
echo using interface $INTERFACE and host ip $MYIPADDRESS
su -c "$INITIALDIR/$INTERFACESCRIPT $INTERFACE $MYIPADDRESS"

if [ ! $? -eq 0 ]; then
	echo something went wrong in setting interface parameters
	exit
fi

echo checking router accssability
WaitForPingSuccess $ROUTERIPADDRESS

echo "Something found at $ROUTERIPADDRESS (let's hope it the router)"

# --- flashing the router
FlashRouter

# --- a bit for the impatient
echo 
echo
echo Every thing seems to be working.
echo "(provided the power LED is turns off)"
echo wait a bit....
sleep 90

echo
echo Please do the following
echo - unplug power cord
echo - reinsert power cord
echo The router should now be flashed. bye.
