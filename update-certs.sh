#!/bin/bash
SERVICE_NAME="load_balancer"
IMAGE_NAME="loadbalancer"
NETWORK_NAME="lb_network"
DOMAINS=("circuitron.com.mx" "jareddlc.com" "siddelacruz.com" "solderbyte.com" "housecollectiverecords.com")

cert() {
  sudo docker run -it --rm -p 443:443 -p 80:80 --name certbot -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" quay.io/letsencrypt/letsencrypt:latest certonly --standalone -d $1 -d www.$1
}

copy() {
  cp /etc/letsencrypt/live/$1/privkey.pem $1.privkey.pem
  cp /etc/letsencrypt/live/$1/fullchain.pem $1.fullchain.pem
}

build() {
  docker build -t $IMAGE_NAME .
}

start() {
  docker service create --replicas 1 --name $SERVICE_NAME -p 80:80 -p 443:443 --network $NETWORK_NAME $IMAGE_NAME
}

stop() {
  docker service rm $SERVICE_NAME
}

# stop service
#stop

# Iterate over domains
for i in "${!DOMAINS[@]}"; do
  cert "${DOMAINS[$i]}"
  copy "${DOMAINS[$i]}"
done

# build Service
#build

# start service
#start

# docker run -it --rm -p 443:443 -p 80:80 --name certbot -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" quay.io/letsencrypt/letsencrypt:latest certonly --standalone -d housecollectiverecords.com -d www.housecollectiverecords.com
