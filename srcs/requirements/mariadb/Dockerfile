# Dockerfile that creates a database container
FROM debian:12.12

# Update package list and install MariaDB server and client tools
# chmod 1777 /tmp prevents failures when tmp isnt world-writable
# --no-install-recommends prevents installation of unnecessary packages
# rm -rf /var/lib/apt/lists/* cleans up apt cache to reduce image size
RUN mkdir -p /tmp && chmod 1777 /tmp && \
    apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

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