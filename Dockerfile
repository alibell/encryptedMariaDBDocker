FROM mariadb:11.2.2
LABEL maintainer="Ali Bellamine contact@alibellamine.me"

COPY ./runMariaDB.sh /runMariaDB.sh

RUN mkdir /var/mariadb && mkdir /var/mariadb/encryption
RUN rm -rf /var/lib/mysql && mkdir /var/lib/mysql
RUN chmod +x /runMariaDB.sh
RUN chown -R mysql:mysql /var/lib/mysql && chmod -R 700 /var/lib/mysql
RUN chown -R mysql:mysql /var/mariadb

# Change user to mysql
USER mysql

CMD ["/runMariaDB.sh"]