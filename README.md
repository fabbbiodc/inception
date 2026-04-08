# Inception

[![Language](https://img.shields.io/badge/language-Docker-informational?style=flat)]()
[![Language](https://img.shields.io/badge/language-Shell-informational?style=flat)]()

## Description

Inception is a containerized infrastructure project that orchestrates multiple services into a production-ready web development environment using Docker and Docker Compose. The project demonstrates system administration, containerization, and infrastructure-as-code principles by setting up a complete WordPress hosting ecosystem with supporting services including an FTP server, database administration, and a static site — all behind a single NGINX reverse proxy with automatic TLS certificate generation.

## Objective

Master Docker containerization and multi-service orchestration by building a complete web infrastructure. Learn to configure and manage multiple interdependent services, volume management, networking, health checks, and environment-based configuration in a containerized environment.

## Architecture

The project uses Docker Compose to orchestrate the following services:

- **NGINX:** Reverse proxy and TLS termination (port 443). Auto-generates self-signed certificates via `ssl.sh` using OpenSSL. Serves all web traffic.
- **WordPress:** Content management system with PHP-FPM backend (exposed on port 9000 internally)
- **MariaDB:** Relational database for WordPress with health-checked readiness
- **Redis:** In-memory cache for session/performance optimization
- **Adminer:** Database administration web UI (bonus, proxied through NGINX)
- **FTP:** File transfer server for WordPress content management (bonus, ports 21 + 21000-21010)
- **Portainer:** Docker container management UI (bonus, port 9443)
- **Static Site:** React-based static website served at `/static-site` (bonus)

All services communicate over a dedicated Docker bridge network (`inception-net`) with persistent bind-mount volumes for data durability.

## Technologies & Concepts

- Docker and containerization fundamentals
- Docker Compose multi-container orchestration
- Service networking and inter-container communication
- Volume management and data persistence
- Environment configuration and secrets management
- Health checks and service dependencies
- Reverse proxy configuration (NGINX)
- Linux shell scripting for automation
- Infrastructure-as-Code principles

## Installation

### Prerequisites

- Docker and Docker Compose installed
- Linux or macOS system
- ~5GB free disk space for volumes

### Setup

```bash
git clone https://github.com/fabbbiodc/inception.git
cd inception
```

Create a `.env` file in the `srcs/` directory with required variables:

```bash
# Volume paths
VOLUME_PATH=/Users/<your-username>/data

# Domain & TLS
DOMAIN_NAME=localhost
CRT_PATH=/etc/nginx/certs
KEY_PATH=/etc/nginx/certs

# Database
DB_NAME=wordpress_db
DB_USER=wp_user
DB_PASSWORD=secure_password
DB_ROOT_PASSWORD=root_password

# WordPress
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin_password
WP_ADMIN_EMAIL=admin@example.com
```

## Usage

### Start the Infrastructure

```bash
make all
```

This command:
- Creates persistent data directories in `~/data/` (db_data, wp_data, port_data, redis_data)
- Builds all Docker images from Dockerfiles
- Starts all services in detached mode
- Establishes networking and health checks
- Generates self-signed TLS certificates (first run only)

### Access Services

All web services (except Portainer) are routed through the NGINX reverse proxy at `https://localhost`:

- **WordPress:** `https://localhost` — Main CMS
- **Adminer:** `https://localhost/adminer` — Database administration interface
- **Static Site:** `https://localhost/static-site` — React-based static page
- **Portainer:** `https://localhost:9443` — Docker container management (direct port, not proxied)
- **FTP:** `ftp://localhost:21` — File transfer (ports 21 + 21000-21010 for passive mode)

### Common Commands

| Command | Description |
|---------|-------------|
| `make all` | Build and start all services |
| `make up` | Start existing containers |
| `make down` | Stop all services |
| `make clean` | Stop services and remove volumes/images |
| `make vclean` | Full cleanup including persistent data |
| `make re` | Rebuild from scratch |
| `make vre` | Full rebuild with data wipe |

### Static Site

The project includes a bonus React-based static site served through NGINX. After running `make all`, visit:

```
https://localhost/static-site
```

The site is built into `srcs/requirements/bonus/static-site/dist/` and copied into the NGINX container during build. It is served as a sub-path alongside WordPress, with NGINX handling the routing.

### TLS Certificates

On first startup, NGINX automatically generates a self-signed TLS certificate using OpenSSL:

- **Certificate:** `/etc/nginx/certs/inception.crt`
- **Key:** `/etc/nginx/certs/inception.key`
- **Validity:** 365 days
- **Subject:** `/C=ES/ST=Catalonia/L=Barcelona/O=42/OU=student/CN=<DOMAIN_NAME>`

Certificates are persisted in the volume, so they are not regenerated on subsequent starts.

```bash
docker-compose -p inception -f ./srcs/docker-compose.yml logs -f [service_name]
```

## Project Structure

```
inception/
├── srcs/
│   ├── docker-compose.yml       # Service orchestration
│   ├── requirements/            # Service configurations
│   │   ├── nginx/              # NGINX reverse proxy
│   │   ├── wordpress/          # WordPress + PHP-FPM
│   │   ├── mariadb/            # MariaDB database
│   │   └── bonus/              # Optional services
│   │       ├── redis/          # Redis cache
│   │       ├── portainer/      # Container UI
│   │       ├── adminer/        # DB admin tool
│   │       └── static_site/    # Additional web service
│   └── .env.example            # Environment template
├── Makefile                     # Build automation
└── printlogs.sh                # Logging utility
```

## Key Features

- **Multi-Service Orchestration:** Manages dependencies between services (WordPress depends on MariaDB and Redis; NGINX depends on WordPress, Adminer, and static_site)
- **Persistent Storage:** Bind-mount volumes ensure data survives container restarts
- **Health Checks:** Each service includes health verification to ensure readiness before dependents start
- **Environment Configuration:** Single `.env` file controls all service parameters including volume paths
- **Automatic TLS:** NGINX entrypoint script generates self-signed certificates on first run using OpenSSL
- **Reverse Proxy Routing:** All web traffic flows through NGINX, serving WordPress, Adminer, and the static site from a single domain
- **FTP Integration:** Bonus FTP server for direct file access to WordPress content
- **Networking Isolation:** Internal Docker network separates infrastructure from host
- **Automated Setup:** Makefile simplifies build and deployment workflow

## Configuration

All service configurations are managed through:

1. **docker-compose.yml:** Service definitions, volumes, networking, health checks
2. **.env file:** Environment variables for secrets and configuration
3. **Dockerfile(s):** Individual service images with specific requirements

### Volume Management

Persistent data is stored using bind-mount volumes configured via the `VOLUME_PATH` environment variable:

- `${VOLUME_PATH}/db_data/` — MariaDB database
- `${VOLUME_PATH}/wp_data/` — WordPress files and uploads
- `${VOLUME_PATH}/redis_data/` — Redis cache persistence
- `${VOLUME_PATH}/port_data/` — Portainer data

The Makefile (`make all`) creates these directories under `~/data/` by default.

## Tech Stack

- **Containerization:** Docker, Docker Compose
- **Web Server:** NGINX
- **Application Server:** WordPress + PHP-FPM
- **Database:** MariaDB
- **Cache:** Redis
- **Scripting:** Bash/Shell
- **Configuration:** Makefiles, Environment files

## Security Considerations

- All services run in isolated containers with specific user permissions
- Database credentials managed through environment variables
- NGINX provides TLS termination and request filtering
- Services communicate over internal Docker networks (no direct internet exposure)
- Health checks verify service integrity

## Troubleshooting

### Services fail to start

```bash
# View detailed logs
docker-compose -p inception -f ./srcs/docker-compose.yml logs

# Check service health
docker-compose -p inception -f ./srcs/docker-compose.yml ps
```

### Volume permission issues

```bash
# Verify data directory permissions
ls -la ~/data/
```

### Port conflicts

Ensure port 443 is available. Modify `docker-compose.yml` if needed.

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Installation Guide](https://wordpress.org/support/article/how-to-install-wordpress/)
- [MariaDB Documentation](https://mariadb.com/kb/en/)
