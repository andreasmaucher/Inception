FROM debian:12.12

RUN mkdir -p /tmp && chmod 1777 /tmp && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      wget \
      mariadb-client \
      php8.2 \
      php8.2-fpm \
      php8.2-mysql \
      php8.2-curl \
      php8.2-mbstring \
      php8.2-xml \
      php8.2-gd \
      php8.2-zip \
      php8.2-opcache && \
    rm -rf /var/lib/apt/lists/*

# Debian already provides www-data user and group

# Download WordPress
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy PHP-FPM pool configuration (Debian path)
COPY conf/php-fpm.conf /etc/php/8.2/fpm/pool.d/www.conf

# Increase PHP upload and post limits (FPM)
RUN { \
  echo 'upload_max_filesize=64M'; \
  echo 'post_max_size=64M'; \
  echo 'max_execution_time=300'; \
  echo 'max_input_time=300'; \
  echo 'memory_limit=256M'; \
} > /etc/php/8.2/fpm/conf.d/uploads.ini

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

VOLUME ["/var/www/html"]

ENTRYPOINT ["/entrypoint.sh"]