#!/bin/bash

echo "Make sure directory has correct permissions"
echo "Service: docker service create --replicas 1 --name jenkins --mount type=bind,source=/root/data,destination=/var/jenkins_home --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock -p 8080 -p 50000 --network my_network jareddlc/jenkins-with-docker-socket"
