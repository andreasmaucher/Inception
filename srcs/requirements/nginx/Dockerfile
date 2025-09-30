FROM debian:12.12

RUN mkdir -p /tmp && chmod 1777 /tmp && \
    apt-get update && \
    apt-get install -y --no-install-recommends nginx openssl && \
    rm -rf /var/lib/apt/lists/*

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