#!/bin/bash

# Download the source code - Mainline version: https://nginx.org/en/download.html 
wget https://nginx.org/download/nginx-1.25.0.tar.gz

# Extract the source code
tar -xvf nginx-1.25.0.tar.gz

# cd into the directory
cd nginx-1.25.0

# Install the required dependencies
sudo apt-get update
sudo apt-get install -y gcc libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev make

# Configure nginx
./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-pcre --with-http_ssl_module

# Build and install nginx
make
sudo make install

# Create the systemd service file for nginx
sudo tee /lib/systemd/system/nginx.service > /dev/null <<EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/bin/nginx -t
ExecStart=/usr/bin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# Start nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
