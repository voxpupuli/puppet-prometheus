#!/bin/bash

cat << EOF > /tmp/squid.conf
http_port 3128
http_access allow all
logfile_rotate 0
cache_log stdio:/dev/stdout
access_log stdio:/dev/stdout
cache_store_log stdio:/dev/stdout
EOF

docker run --detach --rm \
  --name squid \
  --hostname squid \
  --publish 3128:3128 \
  --env='SQUID_CONFIG_FILE=/etc/squid/my-squid.conf' \
  --volume=/tmp/squid.conf:/etc/squid/my-squid.conf:ro \
  b4tman/squid

sleep 3
docker logs squid --tail 100

docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' squid > ~/SQUID_IP
