#!/bin/bash

sudo amazon-linux-extras disable docker
sudo amazon-linux-extras install docker -y
sudo amazon-linux-extras install -y ecs; sudo systemctl enable --now --no-block ecs.service
sleep 10
echo "ECS_CLUSTER=ecs_cluster" | sudo tee /etc/ecs/ecs.config
sudo systemctl restart ecs
