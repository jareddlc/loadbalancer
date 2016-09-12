#!/bin/bash

docker kill load_balancer &> /dev/null
KILL=$?
if [ $KILL -ne 0 ]; then
  echo "Docker kill failed"
  #exit $KILL
fi

docker rm load_balancer &> /dev/null
RM=$?
if [ $RM -ne 0 ]; then
  echo "Docker remove failed"
  #exit $RM
fi

docker build -t loadbalancer .

echo "Container: docker run -d --name load_balancer -p 80:80 -p 443:443 loadbalancer"
echo "Service: docker service create --replicas 1 --name load_balancer -p 80:80 -p 443:443 loadbalancer"
