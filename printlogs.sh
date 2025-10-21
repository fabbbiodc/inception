#!/bin/sh

read -p "Lines to print from each container: " num_lines

for container in mariadb wordpress nginx redis adminer ftp portainer static_site; do
    echo "=== $container logs ==="
    docker logs "$container" -n "$num_lines"
    echo
done