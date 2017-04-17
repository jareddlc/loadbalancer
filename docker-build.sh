#!/bin/bash

docker build -t loadbalancer .

echo "Container: docker run -d --name load_balancer -p 80:80 -p 443:443 loadbalancer"
echo "Service: docker service create --replicas 1 --name load_balancer -p 80:80 -p 443:443 loadbalancer"
