#!/bin/sh

#source FTP parameters
. ./ftp.conf

echo "$(date "+%H:%M:%S") - Attempt to FTP server $FTP_HOST"

# do the FTP put
cd trunk/bin/brcm4716

ftp -i -n <<EOF
open $FTP_HOST
user $FTP_LOGIN $FTP_PASSWORD
cd openwrt
ls
mkdir packages
cd  packages
mput *
cd ..
ls
put openwrt-brcm4716-squashfs.trx
ls
put ../../.config config
ls
quit
EOF

echo "$(date "+%H:%M:%S") - Done uploading"
