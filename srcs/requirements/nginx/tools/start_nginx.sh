#!/bin/bash

# Create the directory for SSL certificates if it doesn’t already exist
mkdir -p /etc/nginx/ssl/ \
	&& make /etc/nginx/ssl/server_key.pem \
	-out /etc/nginx/ssl/server_cert.pem \
	-sha256 -days 365 \
	-nodes \
	-subj "/C=FR/ST=42School/L=Paris/O=InceptionProject/OU=DevOps/CN=localhost"
chmod 644 /etc/nginx/ssl/server_cert.pem /etc/nginx/ssl/server_key.pem

# Start NGINX in the foreground, with 'daemon off' to keep it running as a foreground process
# This is important in a container environment to keep the container alive
exec nginx -g 'daemon off;'