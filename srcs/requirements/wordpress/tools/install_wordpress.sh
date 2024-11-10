#!/bin/bash

# Load credentials into the current environment
source $SECRETS
DB_PASSWORD=$(cat $DB_PASSWORD)

# Wait for MariaDB to start by adding a delay
sleep 10

# Download and extract WordPress if it's not already installed
if [ -f "$WP_DIR/wp-config.php" ];
then
    echo "WordPress installed already"
else
    wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /var/www
    rm /tmp/wordpress.tar.gz
fi

# Set ownership of WordPress files to the web server user
chown -R www-data:www-data $WP_DIR

# Copy the sample configuration file and update with environment variables
cp $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php

# Replace placeholder values in wp-config.php with actual database credentials
sed -i "s/database_name_here/$DB_NAME/g" $WP_DIR/wp-config.php
sed -i "s/username_here/$DB_USER/g" $WP_DIR/wp-config.php
sed -i "s/password_here/$DB_PASSWORD/g" $WP_DIR/wp-config.php
sed -i "s/localhost/$DB_HOST:$DB_PORT/g" $WP_DIR/wp-config.php

# Download wp-cli.phar, a command-line tool for WordPress management
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /bin/wp-cli.phar

# Install WordPress core if it’s not already installed
if ! php /bin/wp-cli.phar core is-installed --path="$WP_DIR" --allow-root;
then
    php /bin/wp-cli.phar core install \
        --path=$WP_DIR \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root # Create a new user with subscriber role
fi

# Create a WordPress user if it doesn't already exist
if ! php /bin/wp-cli.phar user get "$DB_USER" --path="$WP_DIR" --allow-root > /dev/null 2>&1;
then
    php /bin/wp-cli.phar user create \
        $DB_USER \
        $DB_USER_EMAIL \
        --path=$WP_DIR \
        --user_pass=$DB_PASSWORD \
        --role=subscriber \
        --allow-root
fi

# Remove wp-cli.phar file after use
rm -f $WP_DIR/wp-cli.phar

# Execute any additional commands passed to the script
exec $@