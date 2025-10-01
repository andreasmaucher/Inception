FROM debian:12.12

RUN mkdir -p /tmp && chmod 1777 /tmp && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      wget \
      mariadb-client \
      # php meta package
      php8.2 \
      # PHP-FPM required to run WP with Nginx
      php8.2-fpm \
      # MySQL extension for PHP to connect to MariaDB
      php8.2-mysql \
      php8.2-curl \
      # required by WP
      php8.2-mbstring \
      php8.2-xml \
      # image manipulation
      php8.2-gd \
      php8.2-zip \
      # for performance
      php8.2-opcache && \
    rm -rf /var/lib/apt/lists/*

# Download WordPress
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Uses Debian default PHP-FPM pool config and switch to TCP 9000 to match Nginx
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

VOLUME ["/var/www/html"]

ENTRYPOINT ["/entrypoint.sh"]