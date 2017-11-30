#!/bin/bash
FILE_NAME="nginx.conf"
UPSTREAMS=("circuitron_com_mx" "jareddlc_com" "siddelacruz_com" "solderbyte_com" "jenkins") # docker service names
DOMAINS=("circuitron.com.mx" "jareddlc.com" "siddelacruz.com" "solderbyte.com" "jenkins.jareddlc.com")
DOMAINS_WWW=("www.circuitron.com.mx" "www.jareddlc.com" "www.siddelacruz.com" "www.solderbyte.com" "www.jenkins.jareddlc.com")
PORTS=("8080" "8080" "80" "8080" "8080")
SITES=("circuitron.com.mx" "jareddlc.com" "siddelacruz.com" "solderbyte.com")


NGINX_OPTS="
user  nginx;
worker_processes  1;

events {
  worker_connections  1024;
}
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
"

HTTPS_LOG_OPTS='log_format  main $remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for";'
HTTP_OPTS="
  access_log  /var/log/nginx/access.log  main;

  sendfile on;
  keepalive_timeout 65;

  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
"

START="http {"
STOP="}"

# Generates an nginx upstream
# name - name of the upstream
# port - port of the upstream
upstream() {
  echo "  upstream $1-upstream {" >> $FILE_NAME
  echo "    server $1:$2;" >> $FILE_NAME
  echo "  }" >> $FILE_NAME
}

# Generates an nginx http server
# domain - name of domain
# domain_www - alternative name of domain
# upstream - name of the upstream
httpServer() {
  echo "  server {" >> $FILE_NAME
  echo "    listen 80;" >> $FILE_NAME
  echo "    server_name $1 $2;" >> $FILE_NAME
  echo "" >> $FILE_NAME
  echo "    location / {" >> $FILE_NAME
  echo "      proxy_pass http://$3;" >> $FILE_NAME
  echo "      proxy_intercept_errors on;" >> $FILE_NAME
  echo "      proxy_http_version 1.1;" >> $FILE_NAME
  echo '      proxy_set_header Upgrade $http_upgrade;' >> $FILE_NAME
  echo '      proxy_set_header Connection "upgrade";' >> $FILE_NAME
  echo '      proxy_set_header Host $host;' >> $FILE_NAME
  echo '      proxy_set_header X-Real-IP $remote_addr;' >> $FILE_NAME
  echo '      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' >> $FILE_NAME
  echo "    }" >> $FILE_NAME
  echo "  }" >> $FILE_NAME
  echo "" >> $FILE_NAME
}

# Generates an nginx https server
# domain - name of domain
# domain_www - alternative name of domain
# upstream - name of the upstream
# cert - path of the certificate
# key - path of the key
httpsServer() {
  echo "  server {" >> $FILE_NAME
  echo "    listen 443 ssl http2;" >> $FILE_NAME
  echo "    server_name $1 $2;" >> $FILE_NAME
  echo "" >> $FILE_NAME
  echo "    ssl on;" >> $FILE_NAME
  echo "    ssl_certificate $4;" >> $FILE_NAME
  echo "    ssl_certificate_key $5;" >> $FILE_NAME
  echo "    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;" >> $FILE_NAME
  echo "    ssl_prefer_server_ciphers on;" >> $FILE_NAME
  echo '    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";' >> $FILE_NAME
  echo "    ssl_session_timeout 1d;" >> $FILE_NAME
  echo "    ssl_session_cache shared:SSL:10m;" >> $FILE_NAME
  echo "    ssl_stapling on;" >> $FILE_NAME
  echo "    ssl_stapling_verify on;" >> $FILE_NAME
  echo "    add_header Strict-Transport-Security max-age=15768000;" >> $FILE_NAME
  echo "" >> $FILE_NAME
  echo "    location / {" >> $FILE_NAME
  echo "      proxy_pass http://$3;" >> $FILE_NAME
  echo "      proxy_intercept_errors on;" >> $FILE_NAME
  echo "      proxy_http_version 1.1;" >> $FILE_NAME
  echo '      proxy_set_header Upgrade $http_upgrade;' >> $FILE_NAME
  echo '      proxy_set_header Connection "upgrade";' >> $FILE_NAME
  echo '      proxy_set_header Host $host;' >> $FILE_NAME
  echo '      proxy_set_header X-Real-IP $remote_addr;' >> $FILE_NAME
  echo '      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' >> $FILE_NAME
  echo "    }" >> $FILE_NAME
  echo "  }" >> $FILE_NAME
}

echo "$NGINX_OPTS" > $FILE_NAME
echo "$START" >> $FILE_NAME

# Iterate over upstreams
for i in "${!UPSTREAMS[@]}"; do
  upstream "${UPSTREAMS[$i]}" "${PORTS[$i]}"
done

echo "$HTTPS_LOG_OPTS" >> $FILE_NAME
echo "$HTTP_OPTS" >> $FILE_NAME

# Iterate over domains
for i in "${!DOMAINS[@]}"; do
  httpServer "${DOMAINS[$i]}" "${DOMAINS_WWW[$i]}" "${UPSTREAMS[$i]}-upstream"
  httpsServer "${DOMAINS[$i]}" "${DOMAINS_WWW[$i]}" "${UPSTREAMS[$i]}-upstream" "/etc/nginx/ssl/${DOMAINS[$i]}.fullchain.pem" "/etc/nginx/ssl/${DOMAINS[$i]}.privkey.pem"
done

echo "$STOP" >> $FILE_NAME
