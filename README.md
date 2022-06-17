# Why this container?

Yes there are a lot of other containers that promise to do similar things, however I found they didn't fulfil my requirements.

- Take postgres backup in block storage as well as object storage  .
- Volume should me mounted on `/db_backup/` 
## Required Envionment Variables

-   `S3_ACCESS_KEY_ID`  - Your AWS access key.    
-   `S3_SECRET_ACCESS_KEY`  - Your secret access key.    
-   ` S3_ENDPOINT`  - S3 bucket, and optionally path. Should not end in a trailing slash, e.g.  `s3://myapp/db-backups`. 
-   ` S3_BUCKET`  -  BUCKET NAME
-   ` S3_PREFIX`  -  BUCKET PREFIX NAME 
-  `S3_CRON_SCHEDULE  - `SCHEDULE`  can either be a cron five field format  `45 3 * * *`  (every day at 3:45am) or a predefined format (`@weekly`)
-   `POSTGRES_HOST`  - Hostname of the PostgreSQL database to backup, alternatively this container can be linked to the container with the name  `postgres`.    
-   `POSTGRES_DATABASE`  - Name of the PostgreSQL database to backup.    
-   `POSTGRES_USER`  - PostgreSQL user, with priviledges to dump the database.
-   `POSTGRES_PASSWORD`  - PostgreSQL PASSWORD to dump the database.
    
-   `CRON_SCHEDULE`  - Cron schedule to run periodic backups.
### Optional Enviroment Variables

-   `RETAIN_COUNT`  - If not metioned it will take default value 2 i.e two days retention period.
-   `POSTGRES_PORT`  - Port of the PostgreSQL database, uses the default 5432.
-   `S3_REGION`  - Set the default AWS region to send the upload request to.


## Examples

By default if you run the container without any extra arguments it'll run cron and backup periodically based on  `SCHEDULE`:

```
$ docker run -d
  -e S3_ACCESS_KEY_ID=<aws-key> \
  -e S3_SECRET_ACCESS_KEY=<aws-secret-key> \
  -e S3_BUCKET=<bucket> \
  -e S3_PATH=s3://myapp/db-backups \
  -e POSTGRES_DATABASE=postgres \
  -e POSTGRES_HOST=localhost \
  -e POSTGRES_USER=postgres \
  -e CRON_SCHEDULE=@daily \
  -v /volm:/db_backup
  vineetkumar03/postgres_backup_s3_block_object_retention:v01.10


```
crond: crond (busybox 1.28.4) started, log level 8    

`SCHEDULE`  can either be a cron five field format  `45 3 * * *`  (every day at 3:45am) or a predefined format (`@weekly`). 

If you pass the  `backup`  argument it'll run a backup right now:
