#!/bin/sh -e

#
# main entry point to run s3cmd
#
S3CMD_PATH=/opt/s3cmd/s3cmd
S3CMD_CONFIG=/root/.s3cfg
CRON_CONFIG=/etc/cron.d/bkp-cronjob
SCRIPT_CONFIG=/s3/script.sh

#
# Check for required parameters
#
if [ -z "${S3_ACCESS_KEY_ID}" ]; then
    echo "ERROR: The environment variable key is not set."
    exit 1
fi

if [ -z "${S3_SECRET_ACCESS_KEY}" ]; then
    echo "ERROR: The environment variable secret is not set."
    exit 1
fi

if [ -z "${S3_BUCKET}" ]; then
    echo "ERROR: The BUCKET variable secret is not set."
    exit 1
fi

if [ -z "${S3_PREFIX}" ]; then
    echo "ERROR: The PREFIX variable secret is not set."
    exit 1
fi

if [ -z "${CRON_SCHEDULE}" ]; then
    echo "ERROR: The CRON SCHEDULE variable secret is not set."
    exit 1
fi

if [ -z "${RETAIN_COUNT}" ]; then
    echo "ERROR: The RETAIN_COUNT variable secret is not set."
    exit 1
fi

if [ -z "${S3_CRON_SCHEDULE}" ]; then
    echo "ERROR: The RETAIN_COUNT variable secret is not set."
    exit 1
fi


#
# Set user provided key and secret in .s3cfg file
#
echo "host_base = ${S3_ENDPOINT}" >> "$S3CMD_CONFIG"
echo "access_key=${S3_ACCESS_KEY_ID}" >> "$S3CMD_CONFIG"
echo "secret_key =${S3_SECRET_ACCESS_KEY}" >> "$S3CMD_CONFIG"
echo "host_bucket = ${S3_ENDPOINT}/${S3_BUCKET}/${S3_PREFIX}" >> "$S3CMD_CONFIG"
echo "${CRON_SCHEDULE}  /bin/sh /s3/script.sh >> /var/log/cron.log" >> "$CRON_CONFIG"
echo "${S3_CRON_SCHEDULE} /usr/bin/s3cmd sync --delete-removed /db_backup/ s3://${S3_BUCKET}/${S3_PREFIX}/ > /proc/1/fd/1" >> "$CRON_CONFIG"
echo "DAYS_KEEP=${RETAIN_COUNT}" >> "$SCRIPT_CONFIG"
echo "find /db_backup/* -mtime +$DAYS_KEEP -exec rm -rf {} \; 2> /dev/null" >> "$SCRIPT_CONFIG"
echo "PGPASSWORD=${POSTGRES_PASSWORD} pg_dump -h ${POSTGRES_HOST} -U ${POSTGRES_USER} -d ${POSTGRES_DATABASE} | gzip > /db_backup/${POSTGRES_DATABASE}_\$DATESTAMP.sql.gz" >> "$SCRIPT_CONFIG"
sh /s3/script.sh
crontab /etc/cron.d/bkp-cronjob 
