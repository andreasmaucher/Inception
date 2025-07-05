#!/bin/sh

# Wait for MariaDB to be ready
until mysql -h${WP_DB_HOST} -u${WP_DB_USER} -p${WP_DB_PASSWORD} -e "USE ${WP_DB_NAME}" 2>/dev/null; do
  echo "Waiting for MariaDB..."
  sleep 2
done

# If wp-config.php does not exist, set up WordPress
if [ ! -f /var/www/html/wp-config.php ]; then
  wp config create --allow-root \
    --dbname=${WP_DB_NAME} \
    --dbuser=${WP_DB_USER} \
    --dbpass=${WP_DB_PASSWORD} \
    --dbhost=${WP_DB_HOST} \
    --path=/var/www/html

  wp core install --allow-root \
    --url=https://${DOMAIN_NAME} \
    --title="${WP_SITE_TITLE}" \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --skip-email
fi

# Start php-fpm in foreground
exec php-fpm81 --nodaemonize