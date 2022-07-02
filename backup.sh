#!/bin/bash

set -eu
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions

function notify1() {
  sudo -u vit DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "$1" "$2"
}

function log1() {
  echo "`date -Iseconds` - $@"
}

PROGNAME="$(basename $0)"

function error() {
    JOB="$0"              # job name
    LASTLINE="$1"         # line of error occurrence
    LASTERR="$2"          # error code
    log1 "ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}"

    finish=`date -Iseconds`
    ddiff=$(dateutils.ddiff "${start}" "${finish}" -f '%Yy %dd %Hh %Mm %Ss' | sed 's/\b0[ymdh]\b\s*//g')
    log1 "${PROGNAME} - ERROR (diration: ${ddiff})"
    notify1 "Backup" "Backup - ERROR"
    exit 1
}
trap 'error ${LINENO} ${?}' ERR

#####

tailsc_status=`tailscale status`
if [[ "${tailsc_status}" == "Tailscale is stopped." ]]; then
  tailscale up
fi

start=`date -Iseconds`
log1 "${PROGNAME} running..."
notify1 "Backup" "Backup starts"

if mountpoint -q /home/vit/backups; then
  log1 "/home/vit/backups already mounted"
else
  log1 "mount dir /home/vit/backups"
  sshfs -o StrictHostKeyChecking=no /home/vit/backups rockpi:///home/rock/backups

  log1 "dir /home/vit/backups mounted successful"
fi

rsync -av --exclude="node_modules" --exclude="bower_components" --no-links /home/vit/Projects /home/vit/backups

finish=`date -Iseconds`
ddiff=$(dateutils.ddiff "${start}" "${finish}" -f '%Yy %dd %Hh %Mm %Ss' | sed 's/\b0[ymdh]\b\s*//g')
log1 "${PROGNAME} - OK (duration: ${ddiff})"
notify1 "Backup" "Backup - OK"

