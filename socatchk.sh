#!/bin/sh
# crudely shutsdown socat (if running) and then restarts it for new host/port
# by sahal http://scr.im/sahal

# you can now connect to localhost:4242
# as if you were connecting to $1:$2
# using SOCKS proxy $orlisadr:$orport

# usage: ./socatchk remote-host remote-port

#SOCKS listen port 
orport=9150
#SOCKS listen address
orlisadr=localhost

[ "$(pidof socat >/dev/null 2>&1 && echo $?)" = 0 ] && kill $(pidof socat); [ "$(pidof socat && echo $?)" != 0 ] && sleep 3s; socat TCP4-LISTEN:4242,fork SOCKS4A:$orlisadr:$1:$2,socksport=$orport &
