#!/bin/bash

# Install awslogs and the jq JSON parser
yum update -y
yum install -y awslogs jq aws-cli tar screen

systemctl stop ecs

rm -rf /var/lib/ecs/data/*
/bin/mkdir -p /var/log/ecs /var/ecs-data /etc/ecs

cat > /etc/ecs/ecs.config <<- EOF
ECS_CLUSTER=${ecs_cluster_name}
ECS_BACKEND_HOST=

EOF

systemctl start ecs

# Install Filebeat to forward and centralize logs and files 
sudo -su ec2-user
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.12.0-linux-x86_64.tar.gz
tar xzvf filebeat-7.12.0-linux-x86_64.tar.gz
sudo chown root -R filebeat-7.12.0-linux-x86_64
cd filebeat-7.12.0-linux-x86_64; rm -rf filebeat.yml
sudo curl https://jpolata-filebeat.s3.amazonaws.com/filebeat.yaml -o filebeat.yml
sudo chown root filebeat.yml
sudo chmod go-w filebeat.yml
sudo ./filebeat modules enable system
sudo curl https://jpolata-filebeat.s3.amazonaws.com/system.yaml -o modules.d/system.yml
sudo ./filebeat setup -e


screen -S filebeat
sudo ./filebeat -e


