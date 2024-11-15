# Use Debian as the base image with a stable WordPress version
FROM debian:bullseye

# Install WordPress and other necessary packages
# - ca-certificates: Provides trusted CA certificates for secure connections
# - php7.4-fpm: PHP FastCGI Process Manager to handle PHP requests
# - php7.4-mysql: PHP extension to connect to MySQL databases
# - wget: Utility to download files from the web
# - tar: Utility to extract files from tar archives
RUN apt update && apt install --no-install-recommends --no-install-suggests -y \
	ca-certificates \
	php7.4-fpm \
	php7.4-mysql \
	wget \
	tar && \
	# Clear /var/lib/apt/lists to reduce image size as per best practices
	rm -rf /var/lib/apt/lists/*

# Stop the PHP-FPM service if it's running to avoid conflicts during configuration
RUN service php7.4-fpm stop

# Copy custom PHP-FPM pool configuration to manage processes for this setup
COPY ./conf/wp.conf /etc/php/7.4/fpm/pool.d/
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = wordpress:9000/' /etc/php/7.4/fpm/pool.d/www.conf

# Copy custom PHP-FPM pool configuration to manage processes for this setup
RUN mkdir -p /run/php && \
	mkdir -p /var/run/php

# Use an entrypoint script to install WordPress
COPY ./tools/install_wordpress.sh /bin/install_wordpress.sh
RUN chmod +x /bin/install_wordpress.sh

# Expose port 9000 for PHP-FPM to listen for incoming FastCGI requests
EXPOSE 9000

# Run entrypoint script with CMD to start initialization
CMD ["install_wordpress.sh", "php-fpm7.4", "-F"]