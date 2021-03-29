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

# Install Filebeat to forward and centralize logs and files 

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.12.0-linux-x86_64.tar.gz
tar xzvf filebeat-7.12.0-linux-x86_64.tar.gz
chown root -R filebeat-7.12.0-linux-x86_64
filebeat-7.12.0-linux-x86_64; rm -rf filebeat.yaml
curl -O https://jpolata-filebeat.s3.amazonaws.com/filebeat.yaml
cd modules.d/
./filebeat modules enable system
curl -O https://jpolata-filebeat.s3.amazonaws.com/system.yaml

screen -S filebeat
./filebeat setup -e

