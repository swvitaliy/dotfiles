#!/bin/bash

set -eu
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions

src="${1}"
dst="${2}"
mnt="${3}"

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
    log1 "${PROGNAME} ${src} ERROR (diration: ${ddiff})"
    notify1 "Backup" "Backup ERROR"
    exit 1
}

function lockfile_release() {
    rm -f /tmp/backup.lock
}

trap 'error ${LINENO} ${?}' ERR

#####

if ! (set -o noclobber ; echo > /tmp/backup.lock) ; then
    log1 "${PROGNAME} the backup.lock already exists"
    exit 1
fi
trap lockfile_release EXIT

tailsc_status=`tailscale status`
if [[ "${tailsc_status}" == "Tailscale is stopped." ]]; then
  tailscale up
fi

start=`date -Iseconds`
log1 "${PROGNAME} ${src} running..."
notify1 "Backup" "Backup running..."

if mountpoint -q "${dst}"; then
  log1 "${dst} already mounted"
else
  log1 "mount ${dst}"
  sshfs -o allow_other,default_permissions,StrictHostKeyChecking=no "${dst}" "${mnt}"

  log1 "${dst} mounted successful"
fi

rsync -azv --delete --exclude="node_modules" --exclude="bower_components" --no-links "${src}" "${dst}" && \
  exit_code=$? || exit_code=$?

if [[ $exit_code -eq 0 || $exit_code -eq 23 ]]; then
  log1 "sync finished successful"
else
  log1 "sync failed"
  exit $exit_code
fi

finish=`date -Iseconds`
ddiff=$(dateutils.ddiff "${start}" "${finish}" -f '%Yy %dd %Hh %Mm %Ss' | sed 's/\b0[ymdh]\b\s*//g')
log1 "${PROGNAME} ${src} OK (duration: ${ddiff})"
notify1 "Backup" "Backup OK"

