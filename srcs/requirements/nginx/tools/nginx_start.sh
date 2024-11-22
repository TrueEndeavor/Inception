#!/bin/bash

# Create SSL certificates directory and generate self-signed certificate and key
mkdir -p /etc/ssl/certs /etc/ssl/private \
	&& openssl req -x509 -newkey rsa:4096 \
	-keyout /etc/ssl/private/key.pem \
	-out /etc/ssl/certs/cert.pem \
	-sha256 -days 365 \
	-nodes \
	-subj "/C=FR/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"


exec nginx -g 'daemon off;'