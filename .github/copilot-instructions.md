# Copilot Instructions for AI Coding Agents

## Project Overview
This repository is an infrastructure project for multi-service deployment using Docker Compose. It orchestrates several services (nginx, mariadb, wordpress, redis, ftp, portainer, adminer) with custom configurations and initialization scripts. The structure is designed for modularity and clear separation of service responsibilities.

## Architecture & Key Components
- **srcs/docker-compose.yml**: Central orchestration file. Defines all services, networks, and volumes.
- **srcs/requirements/**: Contains service-specific folders. Each service has:
  - `Dockerfile`: Defines the build for the service container.
  - `conf/`: Configuration files (e.g., nginx, mariadb, redis, ftp, wordpress, adminer).
  - `tools/`: Initialization scripts (e.g., `*-init.sh`, `ssl.sh`).
- **srcs/secrets/**: Stores credentials and sensitive data as text files. Services read these at startup.

## Developer Workflows
- **Build & Deploy**: Use `docker-compose up --build` from `srcs/` to build and start all services.
- **Logs**: Use `printlogs.sh` at the project root to aggregate and display logs from all containers.
- **Secrets Management**: Update files in `srcs/secrets/` to change credentials. These are mounted into containers at runtime.
- **Makefile**: Provides shortcuts for common operations (build, clean, restart, etc.). Always check for available targets before running manual commands.

## Project-Specific Patterns
- **Service Isolation**: Each service is self-contained in its own folder under `srcs/requirements/`. Avoid cross-service dependencies except via Docker Compose networking.
- **Configuration Injection**: All config and secret files are injected via Docker volumes. Do not hardcode credentials in Dockerfiles or scripts.
- **Initialization Scripts**: Each service may have a `*-init.sh` script in `tools/` for setup tasks. These are run as entrypoints or via Dockerfile `CMD`/`ENTRYPOINT`.
- **Bonus Services**: Services in `srcs/requirements/bonus/` are optional and may have different startup logic or dependencies.

## Integration Points
- **External Access**: Nginx acts as the main entrypoint for HTTP traffic. FTP, Portainer, and Adminer expose their own ports as defined in `docker-compose.yml`.
- **Database Connections**: WordPress and Adminer connect to MariaDB using credentials from `srcs/secrets/`.
- **Redis**: Used for caching, connected to by other services as needed.

## Examples
- To add a new service, create a new folder under `srcs/requirements/`, add a `Dockerfile`, `conf/`, and `tools/` as needed, then update `docker-compose.yml`.
- To change the WordPress admin password, update `srcs/secrets/wp_admin_password.txt` and restart the relevant containers.

## References
- **srcs/docker-compose.yml**: Service definitions and networking.
- **srcs/requirements/**: Service implementations.
- **srcs/secrets/**: Credentials and secrets.
- **Makefile**: Workflow automation.
- **printlogs.sh**: Log aggregation.

---
For questions or unclear patterns, review the referenced files or ask for clarification. Please suggest improvements to these instructions if you find missing or ambiguous guidance.
