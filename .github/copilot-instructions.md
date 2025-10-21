# Copilot Instructions for AI Coding Agents

## Project Overview
This repository is an Inception-style infrastructure project, primarily orchestrated via Docker Compose. It provisions multiple services (nginx, mariadb, wordpress, redis, ftp, adminer, portainer, static-site) using custom Dockerfiles and configuration scripts. The architecture is modular, with each service isolated in its own directory under `srcs/requirements/bonus/` or `srcs/requirements/`.

## Architecture & Service Boundaries
- **Services:** Each subdirectory in `srcs/requirements/bonus/` and `srcs/requirements/` represents a distinct service. Key services include:
  - `nginx`: Reverse proxy, SSL termination (see `tools/ssl.sh`)
  - `mariadb`: Database, initialized via `tools/maria-init.sh`
  - `wordpress`: CMS, initialized via `tools/wp-init.sh`
  - `redis`, `ftp`, `adminer`, `portainer`, `static-site`: Supporting services
- **Configuration:** Service configs are in `conf/` subfolders. Initialization scripts are in `tools/`.
- **Orchestration:** The root `srcs/docker-compose.yml` defines service composition, networks, and volumes.

## Developer Workflows
- **Build & Deploy:**
  - Use `docker-compose` commands from the `srcs/` directory to build and start all services:
    ```sh
    cd srcs
    docker-compose up --build
    ```
- **Logs:**
  - Use `printlogs.sh` at the project root to aggregate and display logs from all services.
- **Service Initialization:**
  - Each service may have a custom init script in its `tools/` folder (e.g., `ssl.sh` for nginx, `maria-init.sh` for mariadb).
- **Configuration Changes:**
  - Update config files in `conf/` and rebuild the affected service with `docker-compose build <service>`.

## Project-Specific Conventions
- **Directory Structure:**
  - All service definitions, Dockerfiles, configs, and init scripts are under `srcs/requirements/` and `srcs/requirements/bonus/`.
- **Custom Scripts:**
  - Scripts in `tools/` are used for service setup and should be referenced in Dockerfiles or `docker-compose.yml`.
- **No Central README:**
  - Documentation is distributed; inspect service folders for details.

## Integration Points & Dependencies
- **External Dependencies:**
  - Docker, Docker Compose
- **Inter-Service Communication:**
  - Defined in `docker-compose.yml` via networks and environment variables
- **Volumes & Persistence:**
  - Persistent data is managed via Docker volumes as defined in `docker-compose.yml`

## Examples
- To add a new service, create a new folder under `srcs/requirements/bonus/`, add a `Dockerfile`, `conf/`, and `tools/` as needed, then update `docker-compose.yml`.
- To debug SSL issues, inspect and run `srcs/requirements/nginx/tools/ssl.sh`.

## Key Files & Directories
- `srcs/docker-compose.yml`: Main orchestration file
- `srcs/requirements/*/Dockerfile`: Service build instructions
- `srcs/requirements/*/conf/`: Service configuration
- `srcs/requirements/*/tools/`: Service initialization scripts
- `printlogs.sh`: Log aggregation script
- `Makefile`: May contain shortcuts for common workflows (inspect for details)

---

**For AI agents:**
- Always check for service-specific scripts and configs before making changes.
- When updating or adding services, ensure changes are reflected in `docker-compose.yml`.
- Prefer using provided scripts for initialization and debugging.

---

*Please review and suggest additions or corrections for any unclear or missing sections.*
