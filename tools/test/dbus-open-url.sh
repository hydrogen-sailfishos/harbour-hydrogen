#!/bin/sh

function usage() {
		printf "USAGE: %s <URL>\n" "$0"
		printf "\tURL should be something like https://matrix.to/foo/bar\n"
		printf "\n"
}
if [ -z "$1" ]; then
		usage
		exit 1
fi

DT=/usr/share/applications/harbour-hydrogen-open-url.desktop

SVC=$(sed -n   's/^X-Maemo-Service=\([^;]\)/\1/p' "${DT}")
OBJ=$(sed -n   's/^X-Maemo-Object-Path=\([^;]\)/\1/p' "${DT}")
METHOD=$(sed -n 's/^X-Maemo-Method=\([^;]\)/\1/p' "${DT}")
CALL=${METHOD##*.}
IFACE=${METHOD%.*}

printf "Introspecting:\n"
#busctl --user introspect $SVC $OBJ $IFACE
busctl --user introspect $SVC $OBJ
printf "Pinging...."
busctl --user call $SVC $OBJ org.freedesktop.DBus.Peer Ping

if [ $? -eq 0 ]; then
		printf "... Ping OK\n"
else
		printf "... Ping NOK, exiting.\n"
		exit 1
fi

CMD="busctl --user call $SVC $OBJ $IFACE $CALL s $1"
printf "Running:\n#\t%s\n\n" "$CMD"
$CMD
