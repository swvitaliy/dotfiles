#!/bin/bash

set -eu
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions

PROGNAME="$(basename $0)"
NOTIFY_TITLE="Backup"

function error() {
    JOB="$0"              # job name
    LASTLINE="$1"         # line of error occurrence
    LASTERR="$2"          # error code
    echo "ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}"

    finish=`date -Iseconds`
    echo "${PROGNAME} finished with status ERROR (${finish})"
    notify-send "${NOTIFY_TITLE}" "${PROGNAME} finished with status ERROR (${finish})"
    exit 1
}
trap 'error ${LINENO} ${?}' ERR

#####

tailsc_status=`tailscale status`
if [[ "${tailsc_status}" == "Tailscale is stopped." ]]; then
  tailscale up
fi

start=`date -Iseconds`
echo "${PROGNAME} starts (${start})"
notify-send "${NOTIFY_TITLE}" "${PROGNAME} starts (${start})"

if mountpoint -q backups; then
  echo "/home/vit/backups already mounted"
else
  echo "mount dir /home/vit/backups"
  sshfs -o StrictHostKeyChecking=no /home/vit/backups rockpi:///home/rock/backups

  echo "dir /home/vit/backups mounted successful"
fi

rsync -av --exclude="node_modules" --exclude="bower_components" --no-links /home/vit/Projects /home/vit/backups

finish=`date -Iseconds`
echo "${PROGNAME} finished with status OK (${finish})"
notify-send "${NOTIFY_TITLE}" "${PROGNAME} finished with status OK (${finish})"


