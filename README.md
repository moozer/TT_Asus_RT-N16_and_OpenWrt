TT_Asus_RT-N16_and_OpenWrt
==========================

Technology template on how to make openwrt run on the Asus RT-N16 router

Purpose
-------
This TT provides an easy way of flashing or reflashing the router.
It is intended to be the easy solution when the router behaves oddly due to some configuration issue.


Requirements
------------
* A pc (or other) running linux

    You must have root access on this machine. 
    Currently only "su" is supported (as oposed to "sudo")
    
* An Asus RT_N16 + power supply

    The state of the router is not important (at least I have not suceeded in bricking it yet)

* a patch cable
* internet access

HowTo
-----
1. Get this code: `git clone https://github.com/moozer/TT_Asus_RT-N16_and_OpenWrt.git`

2. Change the parameters in `runme.sh`

3. Run the script: `cd TT_Asus_RT-N16_and_OpenWrt` followed by `./runme.sh`

4. Follow what the script says

5. Resetting to defaults: `telnet 192.168.1.1`, `mtd erase nvram` and finally `reboot`


Resources used
--------------
* OpenWrt forum discussion: https://forum.openwrt.org/viewtopic.php?id=33560&p=3
* Domething from DD-wrt: http://www.dd-wrt.com/wiki/index.php/Asus_RT-N16
* Asus reflashing utility (from CD)
* Creativity and some help using the serial connection


Question?
---------
send me an email bigmoozer@gmail.com
