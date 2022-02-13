#!/usr/bin/env bash

: ==========================================
:   Reverse Proxy
: ==========================================

:   curl -sL https://github.com/FlashDin/dnc-simple-bash/blob/main/nginx/reverse_proxy.sh arg1 arg2 arg3 | bash

apt update
apt install nginx -y

printf "proxy_redirect off;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwared-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto "https";
proxy_intercept_errors on;
proxy_buffering on;" > /etc/nginx/snippets/proxy_common.conf

printf "server {
    listen 80;
    server_name $1 www.$1;
    location / {
        include /etc/nginx/snippets/proxy_common.conf;
        proxy_pass http://$2;
    }
    if (scheme = http) {
        return 301 https://server_name$request_uri;
    }
}" > /etc/nginx/site-available/$3

nginx -t
nginx -s reload
exit 0