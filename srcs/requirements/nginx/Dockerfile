FROM alpine:3.18

RUN apk update && \
    apk add --no-cache nginx openssl

# Create necessary directories
RUN mkdir -p /run/nginx /var/log/nginx

# Copy configuration files
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Copy SSL certificate generation script
COPY tools/generate-ssl.sh /generate-ssl.sh
RUN chmod +x /generate-ssl.sh

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443

VOLUME ["/var/www/html"]

ENTRYPOINT ["/entrypoint.sh"]