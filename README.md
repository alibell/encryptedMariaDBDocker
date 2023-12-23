# encryptedMariaDBDocker
Docker configuration for a encryption-in-rest mariadb configuration

## Build image

```
    docker compose build --build-arg ENCRYPTION_PASSWORD=[YOUR ENCRYPTION PASSWORD]
```

## Run image

### With your encryption password in env variable [NOT RECOMMANDED]

In this scenario, your encryption key can be accessed threw docker configuration, and inside the docker image.

```
    docker run -e ENCRYPTION_PASSWORD=[YOUR ENCRYPTION PASSWORD] encryptedmariadbdocker-mariadb
```

### By prompting password

```
    docker run -ti encryptedmariadbdocker-mariadb
```

or 

```
    docker compose run mariadb
```

`docker compose up` doesn't permit password prompt, it is only compatible with passing password as an env variable.

### Other settings

This docker image support every usual Docker maria db settings threw environment variable. See [mariadb docker page](https://hub.docker.com/_/mariadb) for more informations.

## How to create an encrypted table

```
    CREATE TABLE [TABLE_NAME] (COLUMNS) ENGINE=InnoDB ENCRYPTED=YES ENCRYPTION_KEY_ID=1;
```

See [mariadb documentation](https://mariadb.com/kb/en/innodb-encryption-overview/)

## Warnings

Even if your database is encrypted, the encryption password is still available with the `SHOW VARIABLES` command which doesn't need any privilege. So any user that log to your DMBS can compromise the encryption.  
The alternative would be to store the encryption password in a dedicated file, this is less satisfaying because any user that can access to the Docker file-system would be able to compromise it.
