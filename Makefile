# Variables
NAME = inception
COMPOSE_FILE = srcs/docker-compose.yml

# Colors for output
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
NC = \033[0m # No Color

# Default target
all: build up

# Build all Docker images
build:
	@echo "$(GREEN)Building Docker images...$(NC)"
	docker compose -f $(COMPOSE_FILE) build

# Start all services
up:
	@echo "$(GREEN)Starting services...$(NC)"
	docker compose -f $(COMPOSE_FILE) up -d

# Stop all services
down:
	@echo "$(YELLOW)Stopping services...$(NC)"
	docker compose -f $(COMPOSE_FILE) down

# Stop and remove everything (containers, images, volumes, networks)
clean:
	@echo "$(RED)Cleaning everything...$(NC)"
	docker compose -f $(COMPOSE_FILE) down -v --rmi all
	docker system prune -f

# Show running containers
ps:
	@echo "$(GREEN)Running containers:$(NC)"
	docker compose -f $(COMPOSE_FILE) ps

# Show logs
logs:
	@echo "$(GREEN)Container logs:$(NC)"
	docker compose -f $(COMPOSE_FILE) logs

# Show logs for a specific service
logs-%:
	@echo "$(GREEN)Logs for $*:$(NC)"
	docker compose -f $(COMPOSE_FILE) logs $*

# Restart all services
restart: down up

# Show help
help:
	@echo "$(GREEN)Available commands:$(NC)"
	@echo "  make all      - Build and start all services"
	@echo "  make build    - Build all Docker images"
	@echo "  make up       - Start all services"
	@echo "  make down     - Stop all services"
	@echo "  make clean    - Stop and remove everything"
	@echo "  make ps       - Show running containers"
	@echo "  make logs     - Show all logs"
	@echo "  make logs-*   - Show logs for specific service (e.g., make logs-nginx)"
	@echo "  make restart  - Restart all services"
	@echo "  make help     - Show this help"

.PHONY: all build up down clean ps logs restart help