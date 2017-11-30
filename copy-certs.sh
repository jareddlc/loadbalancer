#!/bin/bash
DOMAINS=("circuitron.com.mx" "jareddlc.com" "siddelacruz.com" "solderbyte.com" "jenkins.jareddlc.com")

copy() {
  cp /etc/letsencrypt/live/$1/privkey.pem $1.privkey.pem
  cp /etc/letsencrypt/live/$1/fullchain.pem $1.fullchain.pem
}

# Iterate over domains
for i in "${!DOMAINS[@]}"; do
  copy "${DOMAINS[$i]}"
done

#sudo chmod -R 600 privkey.pem
#sudo chmod -R 600 fullchain.pem
