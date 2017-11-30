#!/bin/bash

cp /etc/letsencrypt/live/circuitron.com.mx/privkey.pem .
cp /etc/letsencrypt/live/circuitron.com.mx/fullchain.pem .
cp /etc/letsencrypt/live/solderbyte.com/privkey.pem .
cp /etc/letsencrypt/live/solderbyte.com/fullchain.pem .
cp /etc/letsencrypt/live/jareddlc.com/privkey.pem .
cp /etc/letsencrypt/live/jareddlc.com/fullchain.pem .
cp /etc/letsencrypt/live/siddelacruz.com/privkey.pem .
cp /etc/letsencrypt/live/siddelacruz.com/fullchain.pem .

#sudo chmod -R 600 privkey.pem
#sudo chmod -R 600 fullchain.pem
