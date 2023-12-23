FROM mariadb:11.2.2

# Get password on build time
ARG ENCRYPTION_PASSWORD

RUN mkdir /etc/mariadb && mkdir /etc/mariadb/encryption
COPY ./runMariaDB.sh /runMariaDB.sh
RUN chmod +x /runMariaDB.sh

# Generate keys
RUN echo "1;"$(openssl rand -hex 32) > /etc/mariadb/encryption/keyfile
RUN openssl enc -aes-256-cbc -md sha1 \
   -pass pass:$ENCRYPTION_PASSWORD \
   -in /etc/mariadb/encryption/keyfile \
   -out /etc/mariadb/encryption/keyfile.enc
RUN rm /etc/mariadb/encryption/keyfile

RUN mariadb-install-db --user=root --basedir=/usr --datadir=/var/lib/mariadb

CMD ["/runMariaDB.sh"]