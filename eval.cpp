/*
"Why don't you use :latest tag?"
Answer: Latest tags are unpredictable and can break builds. Specific versions ensure reproducible builds.
"How do you handle passwords securely?"
Answer: All passwords are in environment variables via .env file, never hardcoded in Dockerfiles.
"Why is NGINX the only exposed service?"
Answer: NGINX acts as a reverse proxy and gateway, providing security by hiding internal services.
4. "What TLS protocols do you support?"
Answer: Only TLSv1.2 and TLSv1.3 for security, no older insecure protocols.
5. "How do you manage configuration?"
Answer: Environment variables in .env file, with Docker secrets for confidential data.
*/

/*
How Docker and docker compose work

Docker
What it is: A containerization platform that packages applications and their dependencies into lightweight, portable containers.
Key concepts:
Container: Isolated environment running an application
Image: Blueprint/template for creating containers
Dockerfile: Instructions to build an image
Volume: Persistent storage for data
Network: Communication between containers

Docker Compose
What it is: Tool for defining and running multi-container Docker applications using YAML files.
Key concepts:
Services: Individual containers (mariadb, wordpress, nginx)
Networks: Custom network connecting services
Volumes: Shared storage between containers
Environment: Variables from .env file

Why use Docker Compose:
Orchestration: Manages multiple containers together
Dependencies: Ensures proper startup order
Networking: Services can communicate by name
Volumes: Shared data persistence
Environment: Centralized configuration
Your architecture:
nginx → Entry point (port 443 HTTPS)
wordpress → PHP application (port 9000)
mariadb → Database (port 3306)
All connected via inception network
Data persisted in volumes

----------------------------------------------------------------------------------------
The difference between a Docker image used with docker compose and without docker compose:
Without Docker Compose (Standalone Docker)
How you use images:
# Build image manually
docker build -t myapp .

# Run container manually with all parameters
docker run -d \
  --name mycontainer \
  -p 8080:80 \
  -v /host/path:/container/path \
  -e ENV_VAR=value \
  myapp

# Manage each container individually
docker stop mycontainer
docker rm mycontainer

Characteristics:
Manual management: Each container run separately
Complex commands: Long command lines with many flags
No orchestration: Containers don't know about each other
Manual networking: Must create networks manually
Individual volumes: Each volume managed separately

With Docker Compose
How you use images:
# docker-compose.yml defines everything
services:
  web:
    build: .
    ports:
      - "8080:80"
    volumes:
      - ./data:/app/data
    environment:
      - ENV_VAR=value
    networks:
      - mynetwork

volumes:
  data:

networks:
  mynetwork:

Characteristics:
Declarative: Everything defined in YAML file
Orchestration: Multiple services managed together
Service discovery: Containers can communicate by name
Dependency management: Services start in correct order
Centralized config: All settings in one file

Key Differences
Aspect	Standalone Docker	Docker Compose
Management	Manual, individual	Automated, orchestrated
Configuration	Command line flags	YAML file
Networking	Manual network creation	Automatic service discovery
Dependencies	Manual startup order	Automatic dependency resolution
Scaling	Manual container creation	docker compose up --scale
Environment	Individual -e flags	Centralized .env file

With Docker Compose (your current setup):
# Everything defined in docker-compose.yml
services:
  mariadb:    # Database service
  wordpress:  # PHP service  
  nginx:      # Web server service
# All connected automatically via 'inception' network

Why Docker Compose is Better for Multi-Container Apps
Simplicity: One command (docker compose up) vs multiple commands
Consistency: Same setup every time
Networking: Services communicate by name automatically
Dependencies: WordPress waits for MariaDB automatically
Configuration: All settings in one place
Reproducibility: Easy to recreate entire stack
Bottom line: Docker Compose is essential for multi-container applications like yours (nginx + wordpress + mariadb)
 because it handles orchestration, networking, and dependencies automatically.

---------------------------------------------------------------------------------
The benefit of Docker compared to VMs
Resource Efficiency
Docker:
Shared OS kernel: All containers share host OS kernel
Lightweight: Containers are just processes (MBs)
Fast startup: Seconds to start containers
Low overhead: Minimal CPU/memory usage
VMs:
Separate OS: Each VM runs complete OS
Heavy: Full OS + application (GBs)
Slow startup: Minutes to boot OS
High overhead: OS consumes significant resources
Performance
Docker:
Native performance: Runs directly on host kernel
No hypervisor: No virtualization layer
Fast I/O: Direct access to host resources
Efficient networking: Uses host networking stack
VMs:
Virtualized performance: Hypervisor adds overhead
Slower I/O: Virtualized disk/network
Resource contention: Multiple OS competing
Network latency: Additional abstraction layer
Scalability
Docker:
Horizontal scaling: Easy to run many containers
Quick deployment: Instant container creation
Resource sharing: Efficient resource utilization
Microservices: Perfect for distributed apps
VMs:
Vertical scaling: Limited by VM size
Slow provisioning: Time to create new VMs
Resource waste: Underutilized VMs
Monolithic: Better for full applications
Development & Deployment
Docker:
Consistency: Same environment everywhere
Portability: Runs on any Docker host
Version control: Images are versioned
CI/CD friendly: Easy integration
VMs:
Environment drift: VMs can differ
Platform specific: Tied to hypervisor
Snapshot management: Complex versioning
Slower CI/CD: Longer build times

Bottom Line
Docker advantages:
10x faster startup
10x less resource usage
Easier management
Better for microservices
Perfect for your WordPress stack

------------------------------------------------------------
The pertinence of the directory structure required for this project (an example is provided in the subject's PDF file).

Why This Structure is Important
1. Separation of Concerns
srcs/: All application code in one place
requirements/: Each service has its own directory
conf/: Configuration files separated from code
tools/: Scripts and utilities organized

This structure is required because:
Docker Compose expects it
Build contexts depend on it
Security requires secrets separation
Professional development standards
Evaluation criteria compliance
Scalability for future enhancements
*/

//! simple setup
/*
Show port 443:

cd /home/amaucher/inception/srcs
docker compose rm -sf nginx
docker compose build --no-cache nginx
docker compose up -d nginx
docker logs --tail=50 nginx | cat
docker ps

somehow it is gone for docker ps. why is that //!!


*/