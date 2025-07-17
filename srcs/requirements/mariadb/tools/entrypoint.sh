#!/bin/sh

# MariaDB was created as a fork of MySQL when Oracle acquired it. For backward compatibility reasons they kept the naming.

# Initialize database if itdoesn't exist yet
# /var/lib/mysql/mysql is the default maria db system database
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    # mysql_install_db prepares the files but doesn't start the server yet
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    
    # Start MariaDB temporarily for setup
    # we need to run it in the background first to set up data directory, otherwise it would fail at exec
    # --skip-networking=0 enables networking connections and allows for remote access
    mysqld_safe --datadir='/var/lib/mysql' --skip-networking=0 &
    sleep 10
    
    # Create database and user
    # all white keywords are environment variables from Docker
    # basically in the docker-compose.yml file I am telling the system to use .env for each service
    # only allow access to root user with the new password
    # flush privileges applies changes immediately without the need for a restart of the server
    mysql -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL
    
    # Shutdown of the temprary MariaDB instance after setup
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    sleep 5
fi

echo "Starting MariaDB..."
# Start MariaDB in foreground
# exec replaces current shell process with maria db -> now runs in foreground for Docker to monitor
exec mysqld_safe --datadir='/var/lib/mysql' --skip-networking=0