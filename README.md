# encryptedMariaDBDocker
Docker configuration for a encryption-in-rest mariadb configuration

## Build image

```
    docker compose build --build-arg ENCRYPTION_PASSWORD=[YOUR ENCRYPTION PASSWORD]
```

## Run image

### With your encryption key in env variable [NOT RECOMMANDED]

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