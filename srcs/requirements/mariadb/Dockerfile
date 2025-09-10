# Dockerfile that creates a database container
FROM alpine:3.18

# updates package list
# installs maria db server and client tools
# --no-cache keeps image smaller by not storing package cach
RUN apk update && \
    apk add --no-cache mariadb mariadb-client

# Create necessary directories for MariaDB:
    # /run/mysqld to store maria db runtime files
    # sets ownership to mysql:mysql user (chown change ownership and -R meaning applies to all within the directory)
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Copy entrypoint script and make it executable
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# open port 3306 (standard MySQL/MariaDB port)
EXPOSE 3306

# creates persistent storage for database files
VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/entrypoint.sh"]