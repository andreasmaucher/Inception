# Inception

A Docker-based infrastructure project that sets up a complete WordPress hosting environment using containerization. This project demonstrates how to orchestrate multiple services (web server, application server, and database) using Docker Compose.

## Overview

The infrastructure consists of three containers working together:
- **Nginx** - Reverse proxy and web server with SSL/TLS encryption (sole entry point on port 443)
- **WordPress** - PHP-FPM application server running WordPress
- **MariaDB** - Database server storing WordPress data

All containers communicate through a custom Docker bridge network, and data persistence is handled via bind-mounted volumes.

## Technologies

- **Docker** & **Docker Compose** - Containerization and orchestration
- **Nginx** - Web server and reverse proxy with SSL/TLS
- **WordPress** - Content management system
- **MariaDB** - Relational database management system
- **PHP 8.2** with PHP-FPM - Executes WordPress PHP code via FastCGI
- **Debian 12** - Base OS for all containers
- **OpenSSL** - SSL certificate generation

## Core Learnings

This project was a deep dive into containerization fundamentals:

- **Multi-container orchestration** - Managing service dependencies and startup order
- **Docker networking** - Creating custom bridge networks for inter-container communication
- **Volume management** - Using bind mounts for persistent data storage
- **SSL/TLS configuration** - Setting up HTTPS with self-signed certificates
- **Reverse proxy patterns** - Routing requests from Nginx to PHP-FPM
- **Dockerfile optimization** - Minimizing image size and following best practices
- **Service isolation** - Each service runs in its own container with minimal dependencies

## Quick Start

1. Copy the example environment file:
   ```bash
   cp example.env srcs/.env
   ```

2. Edit `srcs/.env` with your configuration (domain, passwords, etc.)

3. Build and start all services:
   ```bash
   make all
   ```

4. Access your WordPress site at `https://your-domain.42.fr` (or `https://localhost`)

## Available Commands

- `make all` - Setup, build and start all services
- `make build` - Build all Docker images
- `make up` - Start all services
- `make down` - Stop all services
- `make clean` - Remove everything (containers, images, volumes)
- `make ps` - Show running containers
- `make logs` - Show all container logs
- `make logs-<service>` - Show logs for a specific service
- `make showusers` - Display WordPress users from database
- `make showdbinfo` - Show database overview and statistics

## Architecture

```
Internet
   ↓
Nginx (443) ← SSL/TLS termination
   ↓
WordPress (PHP-FPM :9000)
   ↓
MariaDB (:3306)
```

Nginx serves as the only external entry point, handling SSL encryption and proxying PHP requests to the WordPress container. WordPress connects to MariaDB for data storage. All services communicate through the `inception` Docker network.

## Data Persistence

Data is stored in bind-mounted directories:
- `/home/andreas/data/mariadb` - MariaDB data files
- `/home/andreas/data/wordpress` - WordPress files and uploads

These directories persist even when containers are stopped or removed.

## Notes

- The project requires Linux or a Linux VM (tested with VirtualBox)
- SSL certificates are automatically generated on first startup
- All containers restart automatically if they crash (`restart: always`)
- The WordPress container waits for MariaDB to be ready before initializing
