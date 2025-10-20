# Copilot Instructions for AI Agents

## Project Overview
This repository is an Inception-style multi-service environment using Docker Compose. It orchestrates several services (WordPress, MariaDB, Nginx, Redis, FTP, Adminer, Portainer) for a complete web stack, with each service defined in its own subdirectory under `srcs/requirements/`.

## Architecture & Service Boundaries
- **Services:** Each service (e.g., `wordpress`, `nginx`, `mariadb`, etc.) has its own folder containing a `Dockerfile`, configuration files (`conf/`), and initialization scripts (`tools/`).
- **Orchestration:** The root `srcs/docker-compose.yml` defines how containers are built and networked together.
- **Data Flow:** WordPress connects to MariaDB for its database, Nginx serves as the web proxy, Redis is used for caching, FTP for file transfer, Adminer for DB management, and Portainer for container management.

## Developer Workflows
- **Build & Launch:**
  - Use `docker-compose up --build` from the `srcs/` directory to build and start all services.
  - Use `docker-compose down` to stop and remove containers.
- **Logs:**
  - Run `printlogs.sh` from the project root to aggregate and display logs from all services.
- **Service Initialization:**
  - Each service's `tools/` directory contains scripts (e.g., `wp-init.sh`, `maria-init.sh`, `ssl.sh`) for setup and configuration. These are invoked during container startup.

## Project-Specific Conventions
- **Configuration:**
  - All service configs are under `conf/` within each service directory. Custom settings (e.g., Nginx `default.conf`, MariaDB `my.cnf`) are provided.
- **Initialization Scripts:**
  - Scripts in `tools/` are used for first-time setup, credential generation, and service bootstrapping. They are typically run via Dockerfile `ENTRYPOINT` or `CMD`.
- **Bonus Services:**
  - The `bonus/` directory contains optional services (Adminer, FTP, Portainer, Redis) that can be enabled via Docker Compose.

## Patterns & Examples
- **Service Directory Structure:**
  - Example: `srcs/requirements/wordpress/` contains `Dockerfile`, `conf/www.conf`, and `tools/wp-init.sh`.
- **Custom Scripts:**
  - Example: `srcs/requirements/nginx/tools/ssl.sh` generates SSL certificates for Nginx.
- **Inter-Service Communication:**
  - Environment variables and Docker Compose links are used for service discovery and credentials.

## External Dependencies
- **Docker & Docker Compose:** Required for all workflows.
- **No direct Python/Node dependencies:** All logic is in shell scripts and Dockerfiles.

## Key Files & Directories
- `srcs/docker-compose.yml`: Main orchestration file.
- `srcs/requirements/*/Dockerfile`: Service build instructions.
- `srcs/requirements/*/conf/`: Service configuration files.
- `srcs/requirements/*/tools/`: Initialization and setup scripts.
- `printlogs.sh`: Log aggregation utility.
- `Makefile`: May contain shortcuts for common tasks (review for specifics).

## AI Agent Guidance
- When updating or adding services, follow the established directory structure and initialization patterns.
- Always update `docker-compose.yml` when adding new services or changing inter-service dependencies.
- Use existing scripts as templates for new service setup.
- Validate changes by rebuilding and restarting containers.

---

*If any section is unclear or missing important project-specific details, please provide feedback or point to relevant files for further refinement.*
