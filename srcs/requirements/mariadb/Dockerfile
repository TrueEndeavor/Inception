# Use Debian as the base image with a stable MariaDB version
FROM debian:bullseye

# Install mariadb-server for database and gosu to drop root privileges
RUN apt-get update && \
    apt-get install -y mariadb-server gosu && \
    apt-get clean && \
    # Clear /var/lib/apt/lists to reduce image size as per best practices
    rm -rf /var/lib/apt/lists/* && \
    # Create required directory for MariaDB runtime files
    mkdir -p /var/run/mysqld && \
    # Set ownership of directory to mysql user, ensuring MariaDB can access it without root permissions
    chown mysql:mysql /var/run/mysqld

# Set bind-address to 0.0.0.0 to allow connections within the Docker network
RUN sed -i '/^bind-address/c\bind-address = 0.0.0.0' /etc/mysql/mariadb.conf.d/50-server.cnf

# Use an entrypoint script to initialize and configure the database securely
COPY tools/create_db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/create_db.sh

# Set the working directory to MariaDB’s data directory (volume) for data persistence
WORKDIR /var/lib/mysql

#Expose MariaDB on default port 3306
EXPOSE 3306

#Run entrypoint script with CMD to manage initialization
ENTRYPOINT ["tools/create_db.sh"]

#Start the MariaDB server
CMD ["mysqld"]