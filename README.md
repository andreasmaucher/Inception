# Inception - Dockerized WordPress Project

A Docker Compose project that sets up a WordPress website with MariaDB database and Nginx reverse proxy with SSL/TLS encryption.

## Quick Start

1. **Setup environment variables:**
   ```bash
   make setup
   ```
   This creates a `.env` file from `example.env`. Edit the `.env` file with your configuration.

2. **Build and start all services:**
   ```bash
   make all
   ```

3. **Access the website:**
   - Open https://amaucher.42.fr:8443 in your browser
   - Accept the self-signed certificate warning
   - WordPress should be fully configured and ready to use

## Available Commands

- `make setup` - Create .env file from example.env
- `make build` - Build all Docker images
- `make up` - Start all services
- `make down` - Stop all services
- `make clean` - Stop and remove everything
- `make ps` - Show running containers
- `make logs` - Show all logs
- `make logs-<service>` - Show logs for specific service
- `make restart` - Restart all services
- `make help` - Show help

## Project Structure

```
inception/
├── srcs/                    # Application code
│   ├── docker-compose.yml   # Docker Compose configuration
│   └── requirements/        # Service definitions
│       ├── mariadb/         # MariaDB container
│       ├── nginx/           # Nginx reverse proxy
│       └── wordpress/       # WordPress with PHP-FPM
├── example.env             # Environment variables template
├── .env                    # Your environment variables (created by make setup)
├── Makefile               # Build automation
└── README.md              # This file
```

## Environment Variables

The `example.env` file contains all required environment variables. Key variables:

- `DOMAIN_NAME` - Your domain (e.g., amaucher.42.fr)
- `MYSQL_*` - MariaDB configuration
- `WP_*` - WordPress configuration