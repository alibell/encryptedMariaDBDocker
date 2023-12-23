FROM mariadb:11.2.2
LABEL maintainer="Ali Bellamine contact@alibellamine.me"

# Get password on build time
ARG ENCRYPTION_PASSWORD

# Getting working dir
#ENV WORKDIR="/etc/mariadb"
#ENV DATADIR=$WORKDIR/data

RUN mkdir /var/mariadb && mkdir /var/mariadb/encryption

COPY ./runMariaDB.sh /runMariaDB.sh
RUN rm -rf /var/lib/mysql && mkdir /var/lib/mysql
RUN chmod +x /runMariaDB.sh
RUN chown -R mysql:mysql /var/lib/mysql && chmod -R 700 /var/lib/mysql
RUN chown -R mysql:mysql /var/mariadb

# Change user to mysql
USER mysql

# Generate keys
RUN echo "1;"$(openssl rand -hex 32) > /var/mariadb/encryption/keyfile
RUN openssl enc -aes-256-cbc -md sha1 \
   -pass pass:$ENCRYPTION_PASSWORD \
   -in /var/mariadb/encryption/keyfile \
   -out /var/mariadb/encryption/keyfile.enc
RUN rm /var/mariadb/encryption/keyfile

CMD ["/runMariaDB.sh"]