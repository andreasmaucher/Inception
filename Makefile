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
	@if [ ! -d /home/amaucher/data/mariadb ]; then \
		echo "Creating /home/amaucher/data/mariadb..."; \
		mkdir -p /home/amaucher/data/mariadb; \
		chown -R 999:999 /home/amaucher/data/mariadb; \
	else \
		echo "/home/amaucher/data/mariadb already exists"; \
	fi
	@if [ ! -d /home/amaucher/data/wordpress ]; then \
		echo "Creating /home/amaucher/data/wordpress..."; \
		mkdir -p /home/amaucher/data/wordpress; \
		chown -R 82:82 /home/amaucher/data/wordpress; \
	else \
		echo "/home/amaucher/data/wordpress already exists"; \
	fi

# Build all Docker images
build:
	@echo "Building Docker images..."
	docker compose -f $(COMPOSE_FILE) build

# Start all services
up:
	@echo "Starting services..."
	docker compose -f $(COMPOSE_FILE) up -d

# Stop all services
down:
	@echo "Stopping services..."
	docker compose -f $(COMPOSE_FILE) down

# Stop and remove everything (containers, images, volumes, networks)
clean:
	@echo "Cleaning everything..."
	docker compose -f $(COMPOSE_FILE) down -v --rmi all
	docker system prune -f

# Show running containers
ps:
	@echo "Running containers:"
	docker compose -f $(COMPOSE_FILE) ps

# Show logs
logs:
	@echo "Container logs:"
	docker compose -f $(COMPOSE_FILE) logs

# Show logs for a specific service
logs-%:
	@echo "Logs for $*:"
	docker compose -f $(COMPOSE_FILE) logs $*

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

.PHONY: all setup setup-dirs build up down clean ps logs restart help
