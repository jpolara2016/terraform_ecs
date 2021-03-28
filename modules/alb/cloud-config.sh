#!/bin/bash

# Install awslogs and the jq JSON parser
yum update -y
yum install -y awslogs jq aws-cli

systemctl stop ecs

rm -rf /var/lib/ecs/data/*
/bin/mkdir -p /var/log/ecs /var/ecs-data /etc/ecs

cat > /etc/ecs/ecs.config <<- EOF
ECS_CLUSTER=${ecs_cluster_name}
ECS_BACKEND_HOST=

EOF

systemctl start ecs

# # Installing sematext docker agent for Monitoring
# docker ps -a --format '{{.Names}}' | grep -E "sematext-agent|st-agent" | xargs -r docker rm -f

# docker pull sematext/agent:latest

# docker run -d  --restart always --privileged -P --name st-agent --memory 512MB \
# -v /:/hostfs:ro \
# -v /sys/:/hostfs/sys:ro \
# -v /var/run/:/var/run/ \
# -v /sys/kernel/debug:/sys/kernel/debug \
# -v /etc/passwd:/etc/passwd:ro \
# -v /etc/group:/etc/group:ro \
# -v /dev:/hostfs/dev:ro \
# -v /var/run/docker.sock:/var/run/docker.sock \
# -e INFRA_TOKEN= \    # Your Token
# -e REGION=US \
# sematext/agent:latest
