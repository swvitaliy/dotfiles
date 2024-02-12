#!/bin/bash
# Backup a folder to a remote address using borg.
# Usage: backup-borg.sh
# To restore: borg extract $BORG_REPO::computer-and-date

# Initialize remote repo example:
# ssh borgbase mkdir -p backups/coursera-algo
# borg init -e repokey-blake2 borgbase:backups/coursera-algo

# Dependencies:
# apt install pv dateutils

set -eu
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions

PROGNAME=BorgBU # "$(basename $0)"
source ./backup-init.sh

####

export BORG_RSH='/home/vit/backup-borg-pv.sh ssh '

DATE=$(date -Isec -u)

backup() {
  BORG_REPO=$1
  LOCAL_DIR=$2

  echo Create archive ${BORG_REPO}::$(hostname)-${DATE} local_dir ${LOCAL_DIR}
  /usr/bin/borg create ${BORG_REPO}::$(hostname)-${DATE} "${LOCAL_DIR}"

  echo Prune repo ${BORG_REPO}
  /usr/bin/borg prune --stats \
    --keep-daily=14 \
    --keep-weekly=4 \
    --keep-monthly=6 \
    ${BORG_REPO}
}

start=`date -Iseconds`
log1 "${PROGNAME} running..."
notify1 $PROGNAME "Backup running..."

# backup \
#   'borgbase:backups/cpp' \
#   '/home/vit/cpp'
#
# backup \
#   'borgbase:backups/coursera-algo' \
#   '/home/vit/coursera-algo'

backup \
  'borgbase:repo' \
  '/home/vit/Projects'

finish=`date -Iseconds`
ddiff=$(dateutils.ddiff "${start}" "${finish}" -f '%Yy %dd %Hh %Mm %Ss' | sed 's/\b0[ymdh]\b\s*//g')
log1 "${PROGNAME} Done (duration: ${ddiff})"
notify1 $PROGNAME "BorgBackup Done"

