# Variables
NAME = inception
COMPOSE_FILE = srcs/docker-compose.yml

# Default target
all: setup setup-dirs build up

# Setup environment file
setup:
	@if [ ! -f srcs/.env ]; then \
		echo "Creating srcs/.env file from example.env..."; \
		cp example.env srcs/.env; \
		echo "Please edit srcs/.env file with your configuration before running 'make build'"; \
	else \
		echo "srcs/.env file already exists"; \
	fi

# Create data directories if they don't exist
setup-dirs:
	@echo "Setting up data directories..."
	@if [ ! -d /home/andreas/data/mariadb ]; then \
		echo "Creating /home/andreas/data/mariadb..."; \
		mkdir -p /home/andreas/data/mariadb; \
		chown -R 999:999 /home/andreas/data/mariadb; \
	else \
		echo "/home/andreas/data/mariadb already exists"; \
	fi
	@if [ ! -d /home/andreas/data/wordpress ]; then \
		echo "Creating /home/andreas/data/wordpress..."; \
		mkdir -p /home/andreas/data/wordpress; \
		chown -R 82:82 /home/andreas/data/wordpress; \
	else \
		echo "/home/andreas/data/wordpress already exists"; \
	fi

# Build all Docker images
build:
	@echo "Building Docker images..."
	docker-compose -f $(COMPOSE_FILE) build

# Start all services
up:
	@echo "Starting services..."
	docker-compose -f $(COMPOSE_FILE) up -d

# Stop all services
down:
	@echo "Stopping services..."
	docker-compose -f $(COMPOSE_FILE) down

# Stop and remove everything (containers, images, volumes, networks)
clean:
	@echo "Cleaning everything..."
	docker-compose -f $(COMPOSE_FILE) down -v --rmi all
	docker system prune -f

# Show running containers
ps:
	@echo "Running containers:"
	docker-compose -f $(COMPOSE_FILE) ps

# Show logs
logs:
	@echo "Container logs:"
	docker-compose -f $(COMPOSE_FILE) logs

# Show logs for a specific service
logs-%:
	@echo "Logs for $*:"
	docker-compose -f $(COMPOSE_FILE) logs $*

# Show WordPress users (ID and login) from MariaDB
showusers:
	@echo "WordPress users (first 5):"
	docker-compose -f $(COMPOSE_FILE) exec -T mariadb sh -lc 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -D "$$MYSQL_DATABASE" -e "SELECT ID,user_login FROM wp_users LIMIT 5;"'

# Show comprehensive DB info (databases, table counts, sizes, sample rows)
showdbinfo:
	@echo "=== Databases ==="
	docker-compose -f $(COMPOSE_FILE) exec -T mariadb sh -lc 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"'
	@echo
	@echo "=== WordPress table count ==="
	docker-compose -f $(COMPOSE_FILE) exec -T mariadb sh -lc 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -e "SELECT COUNT(*) AS num_tables FROM information_schema.tables WHERE table_schema=\"$$MYSQL_DATABASE\" AND table_type=\"BASE TABLE\";"'
	@echo
	@echo "=== Largest tables (MB) in $$MYSQL_DATABASE ==="
	docker-compose -f $(COMPOSE_FILE) exec -T mariadb sh -lc 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -e "SELECT table_name, ROUND((data_length+index_length)/1024/1024,2) AS size_mb FROM information_schema.tables WHERE table_schema=\"$$MYSQL_DATABASE\" ORDER BY size_mb DESC LIMIT 10;"'
	@echo
	@echo "=== Row counts (wp_users, wp_posts, wp_comments) ==="
	docker-compose -f $(COMPOSE_FILE) exec -T mariadb sh -lc 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -D "$$MYSQL_DATABASE" -e "SELECT 'wp_users' AS table_name, COUNT(*) AS rows_count FROM wp_users;" 2>/dev/null || true'
	docker-compose -f $(COMPOSE_FILE) exec -T mariadb sh -lc 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -D "$$MYSQL_DATABASE" -e "SELECT 'wp_posts' AS table_name, COUNT(*) AS rows_count FROM wp_posts;" 2>/dev/null || true'
	docker-compose -f $(COMPOSE_FILE) exec -T mariadb sh -lc 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -D "$$MYSQL_DATABASE" -e "SELECT 'wp_comments' AS table_name, COUNT(*) AS rows_count FROM wp_comments;" 2>/dev/null || true'
	@echo
	@echo "=== Sample rows ==="
	@echo "- wp_users:"
	docker-compose -f $(COMPOSE_FILE) exec -T mariadb sh -lc 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -D "$$MYSQL_DATABASE" -e "SELECT ID,user_login,user_email FROM wp_users LIMIT 5;"' 2>/dev/null || true
	@echo "- wp_posts:"
	docker-compose -f $(COMPOSE_FILE) exec -T mariadb sh -lc 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -D "$$MYSQL_DATABASE" -e "SELECT ID,post_title,post_status FROM wp_posts ORDER BY ID DESC LIMIT 5;"' 2>/dev/null || true
	@echo "- wp_comments:"
	docker-compose -f $(COMPOSE_FILE) exec -T mariadb sh -lc 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -D "$$MYSQL_DATABASE" -e "SELECT comment_ID,comment_post_ID,user_id FROM wp_comments ORDER BY comment_ID DESC LIMIT 5;"' 2>/dev/null || true

# Restart all services
restart: down up

# Show help
help:
	@echo "Available commands:"
	@echo "  make all      - Setup, build and start all services"
	@echo "  make setup    - Create .env file from example.env"
	@echo "  make setup-dirs - Create data directories if they don't exist"
	@echo "  make build    - Build all Docker images"
	@echo "  make up       - Start all services"
	@echo "  make down     - Stop all services"
	@echo "  make clean    - Stop and remove everything"
	@echo "  make ps       - Show running containers"
	@echo "  make logs     - Show all logs"
	@echo "  make logs-*   - Show logs for specific service (e.g., make logs-nginx)"
	@echo "  make restart  - Restart all services"
	@echo "  make help     - Show this help"
	@echo "  make showusers- Show first 5 WP users from MariaDB"
	@echo "  make showdbinfo- Show DB overview, table counts, sizes, sample rows"

.PHONY: all setup setup-dirs build up down clean ps logs restart help showusers showdbinfo
