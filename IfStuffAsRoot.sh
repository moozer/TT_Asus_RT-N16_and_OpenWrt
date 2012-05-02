#!/bin/bash

echo Setting interface $1 to ip $2

ifconfig "$1" up
if [ ! $? -eq 0  ]; then
	exit 0
fi

ifconfig "$1" "$2"
if [ ! $? -eq 0 ]; then
	exit 0
fi

exit 0
