# Copilot Instructions for AI Coding Agents

## Project Overview
This codebase is an Inception-style multi-service Docker environment, primarily for educational or development purposes. It orchestrates several services using Docker Compose, with each service defined in its own subdirectory under `srcs/requirements/`. Secrets and configuration files are managed separately for security and modularity.

## Architecture & Major Components
- **Docker Compose**: The main orchestration file is `srcs/docker-compose.yml`. All services are defined and connected here.
- **Services**: Each service (e.g., nginx, mariadb, wordpress, redis, ftp, adminer, portainer) has its own directory under `srcs/requirements/`, containing:
  - `Dockerfile`: Service build instructions
  - `conf/`: Configuration files specific to the service
  - `tools/`: Initialization scripts (e.g., `*-init.sh`, `ssl.sh`)
- **Environment Variables**: All credentials and sensitive data are now managed via `srcs/.env` and passed to containers using `env_file`.

## Developer Workflows
- **Build & Run**: Use `docker-compose` commands from the `srcs/` directory:
  - `docker-compose up --build` to build and start all services
  - `docker-compose down` to stop and remove containers
- **Logs**: Use `printlogs.sh` at the project root to aggregate and display logs from all running containers.
- **Makefile**: Common tasks may be automated via the `Makefile` at the root. Check for targets like `build`, `up`, `down`, `clean`.

## Project-Specific Patterns
- **Service Isolation**: Each service is fully isolated with its own Dockerfile, configs, and init scripts. Avoid cross-service dependencies except via Docker networking and environment variables.
- **Credentials Handling**: Always reference environment variables from `srcs/.env` rather than hardcoding credentials or using a secrets directory.
- **Bonus Services**: Additional/optional services are under `srcs/requirements/bonus/`.
- **Configuration**: Service configs are in `conf/` subfolders. Scripts for setup/init are in `tools/`.

## Integration Points
- **Inter-service Communication**: Managed via Docker Compose networks. Environment variables and volumes are used for passing data between containers.
- **External Dependencies**: Most services use official Docker images as base. Customization is done via Dockerfiles and config/scripts.

## Examples
- To add a new service, create a new folder under `srcs/requirements/`, add a `Dockerfile`, `conf/`, and `tools/` as needed, then update `docker-compose.yml`.
- To update credentials, modify the relevant variable in `srcs/.env` and rebuild affected containers.

## Key Files & Directories
- `srcs/docker-compose.yml`: Main orchestration file
- `srcs/requirements/*/Dockerfile`: Service build instructions
- `srcs/requirements/*/conf/`: Service configuration
- `srcs/requirements/*/tools/`: Service initialization scripts
- `srcs/.env`: Credentials and secrets
- `Makefile`: Project automation
- `printlogs.sh`: Log aggregation

---
**Feedback Requested:**
If any section is unclear, incomplete, or missing important project-specific details, please specify so it can be improved for future AI agent productivity.
