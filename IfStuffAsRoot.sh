#!/bin/sh

echo Setting interface $INTERFACE to ip $MYIPADDRESS
ifconfig $INTERFACE up
ifconfig $INTERFACE $MYIPADDRESS
