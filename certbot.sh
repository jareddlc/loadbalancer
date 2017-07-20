#!/bin/bash

# From: https://certbot.eff.org/docs/install.html#running-with-docker


sudo docker run -it --rm -p 443:443 -p 80:80 --name certbot -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" quay.io/letsencrypt/letsencrypt:latest certonly --standalone -d circuitron.com.mx -d www.circuitron.com.mx

#cert.pem: Your domain's certificate
#chain.pem: The Let's Encrypt chain certificate
#fullchain.pem: cert.pem and chain.pem combined
#privkey.pem: Your certificate's private key
