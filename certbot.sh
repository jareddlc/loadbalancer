#!/bin/bash
DOMAINS=("circuitron.com.mx" "jareddlc.com" "siddelacruz.com" "solderbyte.com" "jenkins.jareddlc.com")

cert() {
  # From: https://certbot.eff.org/docs/install.html#running-with-docker
  sudo docker run -it --rm -p 443:443 -p 80:80 --name certbot -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" quay.io/letsencrypt/letsencrypt:latest certonly --standalone -d $1 -d www.$1
}

# Iterate over domains
for i in "${!DOMAINS[@]}"; do
  cert "${DOMAINS[$i]}"
done

#cert.pem: Your domain's certificate
#chain.pem: The Let's Encrypt chain certificate
#fullchain.pem: cert.pem and chain.pem combined
#privkey.pem: Your certificate's private key
