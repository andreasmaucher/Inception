#!/bin/sh

# Initialize database if not already present
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    
    # Start MariaDB temporarily for setup
    mysqld_safe --datadir='/var/lib/mysql' --skip-networking=0 &
    sleep 10
    
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
    sleep 5
fi

echo "Starting MariaDB..."
# Start MariaDB in foreground
exec mysqld_safe --datadir='/var/lib/mysql' --skip-networking=0