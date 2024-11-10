# Use Debian as the base image with a stable NGINX version
FROM debian:bullseye

# Install NGINX and OpenSSL for HTTPS support
RUN apt update && \
	apt install openssl nginx -y && \
	apt-get clean && \
	# Clear /var/lib/apt/lists and other tmp folders to reduce image size as per best practices
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy custom NGINX configuration file to replace the default configuration
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Use an entrypoint script to initialize NGINX
COPY ./tools/start_nginx.sh /bin/
RUN chmod +x /bin/start_nginx.sh

# Expose port 443 for HTTPS connections
EXPOSE 443

# Run entrypoint script with CMD to start initialization
CMD ["start_nginx.sh"]
