FROM alpine:3.18

RUN apk update && \
    apk add --no-cache php81 php81-fpm php81-mysqli php81-json php81-curl php81-mbstring php81-xml php81-gd php81-session php81-dom php81-opcache php81-zip php81-phar wget curl mariadb-client

# Create user for php-fpm (group www-data already exists)
RUN adduser -u 82 -D -S -G www-data www-data

# Download WordPress
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy PHP-FPM configuration
COPY conf/php-fpm.conf /etc/php81/php-fpm.d/www.conf

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

VOLUME ["/var/www/html"]

ENTRYPOINT ["/entrypoint.sh"]