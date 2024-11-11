#!/bin/bash

# Load environment variables from the secrets file
source $SECRETS

# Read the database and root passwords from their respective secret files
DB_PASSWORD=$(cat $DB_PASSWORD)
DB_ROOT_PASSWORD=$(cat $DB_ROOT_PASSWORD)

# Start MariaDB service
service mariadb start
sleep 5 

# Execute SQL commands to initialize the database and user permissions
mariadb -u root << EOF
	CREATE DATABASE IF NOT EXISTS ${DB_NAME};
	CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
	SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_ROOT_PASSWORD');
EOF

sleep 5

# Shutdown mariadb to restart with new config
service mariadb stop

# Execute any additional commands passed to the script
exec $@


# Ref: https://stackoverflow.com/questions/77867808/mariadb-in-docker-works-with-managed-volume-but-not-with-mapped