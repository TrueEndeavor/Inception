FROM debian:bullseye

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && \
	# web root directory
	chmod -R 775 /var/www/html && \

	chown -R www-data:www-data /var/www/html

# Create SSL directory and generate a self-signed SSL certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/${DOMAIN_NAME}.key \
        -out /etc/nginx/ssl/${DOMAIN_NAME}.crt \
        -subj "/C=FR/ST=42School/L=Paris/O=InceptionProject/OU=DevOps/CN=${DOMAIN_NAME}"

COPY ./nginx.conf /etc/nginx/nginx.conf

# Test nginx conf for syntax errors
#RUN nginx -t

WORKDIR /var/www/html

# EXPOSE 443
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
