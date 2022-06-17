#!/bin/sh
DIR=/db_backup/
DATESTAMP=$(date +%d-%m-%y-%H-%M)
# remove backups older than $DAYS_KEEP
#DAYS_KEEP=${RETAIN_COUNT}
#find ${DIR}* -mtime +$DAYS_KEEP -exec rm -rf {} \; 2> /dev/null
#PGPASSWORD=${POSTGRES_PASSWORD} pg_dump -h ${POSTGRES_HOST} -U ${POSTGRES_USER} -d ${POSTGRES_DATABASE} | gzip > ${DIR}${POSTGRES_DATABASE}_$DATESTAMP.sql.gz
