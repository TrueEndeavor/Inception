#!/bin/bash

# Exit on error and fail if any command in a pipeline fails
set -eo pipefail

# Skip initialization if it's already done
if [ ! -d "/var/lib/mysql/is_init" ]; then

    # Initialize the database files for the first setup
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB in non-networked mode to configure users and privileges
    mysqld --user=mysql --skip-networking &
    pid="$!"

    # Wait for MariaDB to be ready for connections
    # Wait for MySQL to be ready
    until mysqladmin ping -h"localhost" --silent; do
        echo "Waiting for MariaDB to be ready..."
        sleep 2
    done

     # Set up root user, database, and main user for WordPress
    mysql -e "FLUSH PRIVILEGES;"
    mysql -e "CREATE USER IF NOT EXISTS 'root'@'%';"
    mysql -e "ALTER USER 'root'@'%' IDENTIFIED BY '';"
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;"
    mysql -e "FLUSH PRIVILEGES;"

    # Create a marker file to indicate initialization completion
    echo "done" > /var/lib/mysql/is_init

    # Shut down the temporary instance
    mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown
    wait "$pid"
fi

# Start MySQL server
exec gosu mysql "$@"