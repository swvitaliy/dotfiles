#!/bin/bash

function notify1() {
  sudo -u vit DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "$1" "$2"
}

function log1() {
  echo "`date -Iseconds` - $@"

}


function error() {
    JOB="$0"              # job name
    LASTLINE="$1"         # line of error occurrence
    LASTERR="$2"          # error code
    log1 "ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}"

    finish=`date -Iseconds`
    ddiff=$(dateutils.ddiff "${start}" "${finish}" -f '%Yy %dd %Hh %Mm %Ss' | sed 's/\b0[ymdh]\b\s*//g')
    log1 "${PROGNAME} ERROR (diration: ${ddiff})"
    notify1 "Backup" "Backup ERROR"
    exit 1
}

function lockfile_release() {
    rm -f /tmp/backup.lock
}

trap 'error ${LINENO} ${?}' ERR

if ! (set -o noclobber ; echo > /tmp/backup.lock) ; then
    log1 "${PROGNAME} the backup.lock already exists"
    exit 1
fi
trap lockfile_release EXIT



