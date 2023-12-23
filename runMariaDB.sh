# Get password from user input
if [[ -z "${ENCRYPTION_PASSWORD}" ]]; then
    echo -n "Encryption password:"
    read -s PASSWORD
else
    PASSWORD=${ENCRYPTION_PASSWORD}
fi

# Assert password is ok
decrypted=$(openssl aes-256-cbc -md sha1 -d -k $PASSWORD -in /etc/mariadb/encryption/keyfile.enc | cut -c1-1)
if [[ $decrypted != "1" ]]; then
    echo "Bad decryption password"
    exit 1    
fi

# Launch mariadb
mariadbd \
    --datadir=/var/lib/mariadb \
    --user=root \
    --plugin-load-add=file_key_management \
    --file-key-management-filekey=$PASSWORD \
    --file-key-management-filename=/etc/mariadb/encryption/keyfile.enc
