FROM nginx
MAINTAINER Jared De La Cruz "jared@jareddlc.com"

# Move config
COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir /etc/nginx/ssl
COPY *.pem /etc/nginx/ssl

EXPOSE 80
EXPOSE 443
