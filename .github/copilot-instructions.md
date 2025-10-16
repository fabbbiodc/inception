# Inception Project - AI Agent Instructions

## Project Overview
This is a containerized WordPress web stack implementing the 42 School "Inception" project. It's a multi-service Docker setup with custom configurations, SSL certificates, and comprehensive bonus features.

## Architecture
The stack consists of 6 Docker services in `srcs/docker-compose.yml`:
- **nginx**: HTTPS-only reverse proxy (port 443) with custom SSL certificates
- **wordpress**: PHP-FPM backend with WP-CLI automation and Redis caching
- **mariadb**: Database with automated setup and user provisioning
- **redis**: Cache backend for WordPress performance (bonus)
- **adminer**: Database admin interface accessible at `/adminer` (bonus)
- **ftp**: File transfer server for WordPress content management (bonus)

Services communicate through two networks: `inception-net` (main) and `redis-net` (cache isolation).

## Development Workflow

### Build & Run Commands
```bash
make all        # Build and start all services (creates ~/data directories)
make up         # Start existing containers
make down       # Stop services
make clean      # Remove containers, images, volumes
make vclean     # Full cleanup including ~/data directories
make re/vre     # Rebuild (with/without volume cleanup)
```

### Service Dependencies
- nginx depends on wordpress + adminer
- wordpress depends on mariadb + redis
- adminer depends on mariadb
- ftp depends on wordpress

## Configuration Patterns

### Directory Structure Convention
Each service follows this pattern:
```
requirements/SERVICE_NAME/
├── Dockerfile              # Alpine-based builds
├── conf/SERVICE.conf       # Service configuration
└── tools/SERVICE-init.sh   # Initialization script
```

### Secrets Management
All sensitive data is stored in `srcs/secrets/*.txt` files and accessed via Docker secrets at `/run/secrets/FILENAME` within containers. Never hardcode credentials.

### Initialization Scripts Pattern
All services use idempotent initialization scripts in `tools/` that:
1. Check if already configured (e.g., `wp-config.php` exists)
2. Wait for dependencies using `nc -z HOST PORT`
3. Read secrets from `/run/secrets/`
4. Perform one-time setup if needed
5. Execute the main service with `exec "$@"`

## Service-Specific Details

### WordPress (`requirements/wordpress/`)
- Uses WP-CLI for automated installation and user creation
- Configures Redis caching automatically
- Runs PHP 8.3 FPM on port 9000
- Volume mounted at `/var/www/html`

### Nginx (`requirements/nginx/`)
- HTTPS-only (TLS 1.2/1.3) with self-signed certificates
- Proxies PHP requests to wordpress:9000 and adminer:9000
- Serves `/adminer` path for database admin
- SSL cert generation in `tools/ssl.sh`

### MariaDB (`requirements/mariadb/`)
- Initializes database and users only on first run
- Uses environment variables for DB_NAME, DB_USER
- Passwords from Docker secrets only

## Environment Variables
Set in `.env` file (not tracked in git):
- `DOMAIN_NAME`: Server name for SSL certificates
- `VOLUME_PATH`: Host path for persistent data (typically ~/data)
- Database and WordPress configuration variables

## Volume Management
- `db_data`: MariaDB persistent storage
- `wp_data`: WordPress files and uploads
- Both use bind mounts to `${VOLUME_PATH}/` on host

## Troubleshooting
- Services wait for health checks before proceeding
- Check `docker-compose logs SERVICE_NAME` for issues
- Nginx waits for https://DOMAIN_NAME to respond before marking ready
- All initialization is idempotent - safe to restart