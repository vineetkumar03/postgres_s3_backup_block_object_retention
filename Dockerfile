#FROM ubuntu:xenial-20210611
FROM postgres:12.2
RUN apt-get update && apt-get -y install gnupg dirmngr cron wget apt-transport-https git vim rsync python-dateutil python \
#RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv 7FCC7D46ACCC4CF8
#RUN gpg --export --armor 7FCC7D46ACCC4CF8 |  apt-key add -
#RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main 12" > /etc/apt/sources.list.d/pgdg.list

#RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common 
#RUN apt-get autoremove -y && apt-get install -f -y postgresql-12 postgresql-client-12 \
#  && wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | apt-key add - \
#  && wget -O /etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list \
#  && apt-get update && apt-get -y install s3cmd \
#  && apt install rsync git -y \
  && groupmod -g 65533 nogroup \
  && groupadd -g 65534 nobody


WORKDIR /s3
COPY s3cmd-2.2.0.tar.gz /s3/
RUN tar zxf /s3/s3cmd-2.2.0.tar.gz -C /s3/ \
  && ln -s /s3/s3cmd-2.2.0/s3cmd /usr/bin/s3cmd
####################ENVIRONMENT VARIABLES##################
ENV POSTGRES_DATABASE ''
ENV POSTGRES_HOST ''
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER ''
ENV POSTGRES_PASSWORD ''
ENV S3_ACCESS_KEY_ID ''
ENV S3_SECRET_ACCESS_KEY ''
ENV S3_BUCKET ''
ENV S3_ENDPOINT ''
ENV S3_PREFIX ''
ENV RETAIN_COUNT 2
ENV CRON_SCHEDULE ''
ENV S3_CRON_SCHEDULE ''
#############################################################
COPY bkp-cronjob /etc/cron.d/bkp-cronjob
RUN  chmod 644 /etc/cron.d/bkp-cronjob
COPY s3cfg /root/.s3cfg
COPY script.sh .
RUN  chmod +x script.sh
COPY main.sh .
RUN  chmod +x main.sh
RUN  touch /var/log/cron.log
RUN  chmod 777  /var/log/cron.log 
CMD ["/bin/bash","-c","/s3/main.sh && cron && tail -f /var/log/cron.log"]

