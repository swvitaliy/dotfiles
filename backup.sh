#!/bin/bash

set -eu
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions

src="${1}"
dst="${2}"
mnt="${3}"

PROGNAME=Backup # "$(basename $0)"

source ./backup-init.sh

#####

tailsc_status=`tailscale status`
if [[ "${tailsc_status}" == "Tailscale is stopped." ]]; then
  tailscale up
fi

start=`date -Iseconds`
log1 "${PROGNAME} ${src} running..."
notify1 $PROGNAME "Backup running..."

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
notify1 $PROGNAME "Backup OK"

