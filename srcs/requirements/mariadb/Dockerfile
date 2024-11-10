# Use Debian as the base image with a stable MariaDB version
FROM debian:bullseye

# Install mariadb-server for database
RUN apt update -y && \
	apt upgrade -y && \
	apt-get install mariadb-server -y && \
	apt-get clean && \
	# Clear /var/lib/apt/lists to reduce image size as per best practices
	rm -rf /var/lib/apt/lists/*

# Copy custom MariaDB configuration file to replace the default configuration
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Use an entrypoint script to initialize and configure the database securely
COPY ./tools/create_db.sh /bin/
RUN chmod +x /bin/create_db.sh

#Expose MariaDB on default port 3306
EXPOSE 3306

#Run entrypoint script with CMD to manage initialization
CMD ["create_db.sh", "mysqld_safe"]