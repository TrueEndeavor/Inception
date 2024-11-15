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

# Create SSL certificates directory and generate self-signed certificate and key
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -sha256 \
    -subj "/C=FR/ST=42School/L=Paris/O=InceptionProject/OU=DevOps/CN=localhost"
RUN chmod 644 /etc/nginx/ssl/inception.key /etc/nginx/ssl/inception.crt

# Expose port 443 for HTTPS connections
EXPOSE 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
