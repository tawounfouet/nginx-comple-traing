

# Install nginx from the binary

When we are install nginx from the package manager, we can not include the modules in nginx. We can only include the modules when we install nginx from the source code. 
- We can't add the custom modules to the nginx 
- We can't the third party modules to the nginx 
To include these modules, we need to install nginx from the source code. 

```bash
# Download the source code - Mainline version : https://nginx.org/en/download.html 
wget https://nginx.org/download/nginx-1.25.0.tar.gz

# Extract the source code
tar -xvf nginx-1.25.0.tar.gz

# cd into the directory and run the configure script - to build the nginx binary with the modules ()
cd nginx-1.25.0
#./configure 

# To compile the nginx source code, we need to install some compiler - the gcc compiler
sudo apt-get install gcc # install gcc compiler

# Install the PCRE library - this is the in build module
sudo apt-get install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev make # install the PCRE library

# run the configure script 
./configure

# build the nginx binary
./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-pcre --with-http_ssl_module

# Build the nginx binary - to compile the nginx source code
make # this will build the nginx binary

# Install the nginx binary - to install the nginx binary wihch we built from the source code
sudo make install # this will install the nginx binary

# Create a service file for nginx - https://www.nginx.com/resources/wiki/start/topics/examples/systemd/ 
#sudo vim /etc/systemd/system/nginx.service
#sudo touch /lib/systemd/system/nginx.service
sudo vi /lib/systemd/system/nginx.service
```

Let's do some changes to the nginx.service file
```bash
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
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

Let's now start nginx once again
```bash
# Start nginx se
sudo nginx

sudo systemctl status nginx # this will show the nginx process is running
```