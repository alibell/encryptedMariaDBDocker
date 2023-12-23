KEY_DIR="/var/mariadb/encryption/"
KEY_PATH_RAW="$KEY_DIR"keyfile
KEY_PATH="$KEY_DIR"keyfile.enc

# Get password from user input
if [[ -z "${ENCRYPTION_PASSWORD}" ]]; then
    echo -n "Encryption password:"
    read -s PASSWORD
else
    PASSWORD=${ENCRYPTION_PASSWORD}
fi

# Create keyfile if missing
if [[ ! -f $KEY_PATH ]]; then
    echo "Generating encryption key"
    
    echo "1;"$(openssl rand -hex 32) > $KEY_PATH_RAW
    openssl enc -aes-256-cbc -md sha1 \
        -pass pass:$PASSWORD \
        -in $KEY_PATH_RAW \
        -out $KEY_PATH
    rm $KEY_PATH_RAW
fi

# Assert password is ok
echo "Testing encryption password"
decrypted=$(openssl aes-256-cbc -md sha1 -d -k $PASSWORD -in $KEY_PATH | cut -c1-1)
if [[ $decrypted != "1" ]]; then
    echo "Bad decryption password"
    exit 1    
fi

# Launch mariadb
/usr/local/bin/docker-entrypoint.sh \
    --plugin-load-add=file_key_management \
    --file-key-management-filekey=$PASSWORD \
    --file-key-management-filename=$KEY_PATH \
    --innodb-encrypt-tables=1 \
    --innodb-encrypt-temporary-tables=1 \
    --innodb-encrypt-log=1 \
    --innodb-encryption-threads=4 \
    --innodb-encryption-rotate-key-age=1
