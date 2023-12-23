# Get password from user input
if [[ -z "${ENCRYPTION_PASSWORD}" ]]; then
    echo -n "Encryption password:"
    read -s PASSWORD
else
    PASSWORD=${ENCRYPTION_PASSWORD}
fi

# Assert password is ok
decrypted=$(openssl aes-256-cbc -md sha1 -d -k $PASSWORD -in /var/mariadb/encryption/keyfile.enc | cut -c1-1)
if [[ $decrypted != "1" ]]; then
    echo "Bad decryption password"
    exit 1    
fi

# Launch mariadb
/usr/local/bin/docker-entrypoint.sh \
    --plugin-load-add=file_key_management \
    --file-key-management-filekey=$PASSWORD \
    --file-key-management-filename=/var/mariadb/encryption/keyfile.enc \
    --innodb-encrypt-tables=1 \
    --innodb-encrypt-temporary-tables=1 \
    --innodb-encrypt-log=1 \
    --innodb-encryption-threads=4 \
    --innodb-encryption-rotate-key-age=1
