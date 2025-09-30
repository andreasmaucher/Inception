#!/bin/sh
set -e

# Ensure runtime directory exists and has correct ownership each start (tmpfs in containers)
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 775 /run/mysqld
rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.pid || true

### Debug info
echo "[mariadb-entrypoint] starting entrypoint"
echo "[mariadb-entrypoint] MYSQL_DATABASE=${MYSQL_DATABASE:-<unset>} MYSQL_USER=${MYSQL_USER:-<unset>}"

# Initialize database if it doesn't exist yet
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[mariadb-entrypoint] Initializing MariaDB database..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql >/var/log/mariadb-init.log 2>&1 || \
      mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql >/var/log/mariadb-init.log 2>&1
    echo "[mariadb-entrypoint] initialization log (tail):"
    tail -n +1 /var/log/mariadb-init.log || true

    # Start MariaDB temporarily for setup (fresh DB)
    mysqld_safe --datadir='/var/lib/mysql' --bind-address=0.0.0.0 &
    PID=$!
    # Wait for server to accept connections
    for i in $(seq 1 30); do
      if mysqladmin ping --silent; then
        echo "[mariadb-entrypoint] mysqld is up"
        break
      fi
      echo "[mariadb-entrypoint] Waiting for MariaDB to be ready... ($i)"
      sleep 1
    done

    echo "[mariadb-entrypoint] Running initial SQL setup..."
  mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

    # Set root password for fresh DB
    if [ -n "${MYSQL_ROOT_PASSWORD}" ]; then
      echo "[mariadb-entrypoint] Setting root password for fresh install"
      mysql -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL
    fi

    # Shutdown temporary instance cleanly
    mysqladmin -u root shutdown || true
    sleep 2
else
    echo "[mariadb-entrypoint] Existing database detected, skipping initialization."
fi

echo "[mariadb-entrypoint] Starting MariaDB..."
exec mysqld_safe --datadir='/var/lib/mysql' --bind-address=0.0.0.0