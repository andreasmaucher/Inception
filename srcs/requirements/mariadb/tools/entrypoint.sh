#!/bin/sh

# Initialize database if not already present
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    # Start MariaDB in the background
    mysqld_safe --datadir='/var/lib/mysql' --skip-networking=0 &
    sleep 5

    # Create database and user
    mysql -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL

    # Shutdown MariaDB after setup
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
fi

# Start MariaDB in foreground with networking enabled
exec mysqld_safe --datadir='/var/lib/mysql' --skip-networking=0