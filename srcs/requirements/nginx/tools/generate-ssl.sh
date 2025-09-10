#!/bin/sh

# Create SSL directory
mkdir -p /etc/nginx/ssl

# Generate self-signed certificate so WordPress can use HTTPS
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    # where private key is saved
    -keyout /etc/nginx/ssl/key.pem \
    # where certificate is saved
    -out /etc/nginx/ssl/cert.pem \
    # certificate details
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"