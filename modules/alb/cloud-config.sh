#!/bin/bash

# Install awslogs and the jq JSON parser
yum update -y
yum install -y awslogs jq aws-cli tar screen

#systemctl stop ecs; stop ecs
if systemctl stop ecs; then echo "ECS stopped"; else stop ecs; fi


rm -rf /var/lib/ecs/data/*
/bin/mkdir -p /var/log/ecs /var/ecs-data /etc/ecs

cat > /etc/ecs/ecs.config <<- EOF
ECS_CLUSTER=${ecs_cluster_name}
ECS_BACKEND_HOST=

EOF

#systemctl start ecs; start ecs
if systemctl start ecs; then echo "ECS started"; else start ecs; fi


