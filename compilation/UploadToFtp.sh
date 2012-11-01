#!/bin/sh

# say hi
echo "$(date "+%H:%M:%S") - Attempt to FTP server $FTP_HOST"

#source FTP parameters
. ./ftp.conf

# save initial dir
CurDir=$PWD

# do the FTP put
cd trunk/bin/brcm4716

ftp -i -n <<EOF
open $FTP_HOST
user $FTP_LOGIN $FTP_PASSWORD

mkdir openwrt
cd openwrt
ls

mkdir packages
cd packages
lcd packages
mput *
ls
cd ..
lcd ..

put openwrt-brcm4716-squashfs.trx
put ../../.config config
put $CurDir/htaccess .htaccess
ls

quit
EOF

echo "$(date "+%H:%M:%S") - Done uploading"
