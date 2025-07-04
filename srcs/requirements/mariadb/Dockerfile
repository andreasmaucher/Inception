FROM alpine:3.18

RUN apk update && \
    apk add --no-cache mariadb mariadb-client

# Create necessary directories for MariaDB
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/entrypoint.sh"]