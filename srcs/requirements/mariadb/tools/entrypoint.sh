#!/bin/sh
set -e

# Ensure runtime directory exists and has correct ownership each start (tmpfs in containers)
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 775 /run/mysqld
rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.pid || true

# Initialize database if it doesn't exist yet
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql >/dev/null 2>&1 || \
      mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily for setup
mysqld_safe --datadir='/var/lib/mysql' --bind-address=0.0.0.0 &
# Wait for server to accept connections
for i in $(seq 1 30); do
  if mysqladmin ping --silent; then
    break
  fi
  echo "Waiting for MariaDB to be ready... ($i)"
  sleep 1
done

# Always ensure database and user exist (safe to run multiple times)
echo "Setting up database and user..."
mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

# Shutdown temporary instance cleanly
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown || true
sleep 2

echo "Starting MariaDB..."
exec mysqld_safe --datadir='/var/lib/mysql' --bind-address=0.0.0.0