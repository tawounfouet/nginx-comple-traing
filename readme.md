## Complete NGINX Training | Webserver | Reverse Proxy | Load Balancer | SSL Certificates | Docker| Cache

NGINX is a free, open-source, high-performance HTTP server and reverse proxy, as well as an IMAP/POP3 proxy server. NGINX is known for its high performance, stability, rich feature set, simple configuration, and low resource consumption. 

NGINX is one of a handful of servers written to address the C10K problem. Unlike traditional servers, NGINX doesn’t rely on threads to handle requests. Instead it uses a much more scalable event-driven (asynchronous) architecture. This architecture uses small, but more importantly, predictable amounts of memory under load.

Even if you don’t expect to handle thousands of simultaneous requests, you can still benefit from NGINX’s high-performance and small memory footprint. NGINX scales in all directions: from the smallest VPS all the way up to large clusters of servers.


### Install NGINX on Ubuntu 18.04

```bash
sudo apt update # apt stands for Advanced Packaging Tool
sudo apt-get update # apt-get is a command line tool for handling packages and updates in Ubuntu
sudo apt install nginx
```

Grant sudo access to the vagrant user
```bash
sudo usermod -aG sudo vagrant
```

Get IP address of the server
```bash
ip addr show eth1 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'

ifconfig
ifconfig enp0s8 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
```


Check if NGINX process is running
```bash
ps aux | grep nginx

# results
vagrant@nginx-web-server:/etc$ ps aux | grep nginx
root      3125  0.0  0.3 141132  1552 ?        Ss   12:52   0:00 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
www-data  3126  0.0  1.2 143804  6148 ?        S    12:52   0:00 nginx: worker process
vagrant   3218  0.0  0.2  14860  1064 pts/0    S+   12:53   0:00 grep --color=auto nginx
```
We can see that two process are running for NGINX (one as `root` and one as `www-data` user).
 - the master process is running as root. 
 - The worker process is running as www-data user. 
So nginx by default create a master process as root and worker process as www-data user. 

Vie the status of NGINX
```bash
systemctl status nginx
```

### NGINX Configuration Files

NGINX has one master process and several worker processes. The main configuration file is usually called `nginx.conf`. The default location for the configuration file is `/etc/nginx/nginx.conf`.
```bash
# To go to the directory (view configuration file)
ls -l /etc/nginx

# results
total 64
drwxr-xr-x 2 root root 4096 Nov 10  2022 conf.d
-rw-r--r-- 1 root root 1077 Apr  6  2018 fastcgi.conf
-rw-r--r-- 1 root root 1007 Apr  6  2018 fastcgi_params
-rw-r--r-- 1 root root 2837 Apr  6  2018 koi-utf
-rw-r--r-- 1 root root 2223 Apr  6  2018 koi-win
-rw-r--r-- 1 root root 3957 Apr  6  2018 mime.types
drwxr-xr-x 2 root root 4096 Nov 10  2022 modules-available
drwxr-xr-x 2 root root 4096 May 26 12:52 modules-enabled
-rw-r--r-- 1 root root 1482 Apr  6  2018 nginx.conf
-rw-r--r-- 1 root root  180 Apr  6  2018 proxy_params
-rw-r--r-- 1 root root  636 Apr  6  2018 scgi_params
drwxr-xr-x 2 root root 4096 May 26 12:52 sites-available
drwxr-xr-x 2 root root 4096 May 26 12:52 sites-enabled
drwxr-xr-x 2 root root 4096 May 26 12:52 snippets
-rw-r--r-- 1 root root  664 Apr  6  2018 uwsgi_params
-rw-r--r-- 1 root root 3071 Apr  6  2018 win-utf
```

The `nginx.conf` file contains a number of directives that affect how NGINX will work. The `nginx.conf` file is read each time the NGINX server starts, so you need to restart the NGINX server each time you make a configuration change.
```bash
cat /etc/nginx/nginx.conf # from the home directory
cat nginx.conf # from the nginx directory

```

Acces log folder
```bash
cd /var/log/nginx

# results
#vagrant@nginx-web-server:/var/log/nginx$ ls
access.log  error.log

#vagrant@nginx-web-server:/var/log/nginx$ ls -l
total 0
-rw-r----- 1 www-data adm 0 May 26 12:52 access.log
-rw-r----- 1 www-data adm 0 May 26 12:52 error.log

#vagrant@nginx-web-server:/var/log/nginx$ tail -f *
tail: cannot open 'access.log' for reading: Permission denied
tail: cannot open 'error.log' for reading: Permission denied
tail: no files remaining

# Grant permission for access.log and error.log to vagrant user
sudo chown vagrant:adm access.log error.log


#vagrant@nginx-web-server:/var/log/nginx$ sudo chown vagrant:adm access.log error.log
#vagrant@nginx-web-server:/var/log/nginx$ tail -f *
==> access.log <==

==> error.log <==
```
Get the ipd address of the server and access the server from the browser
```bash
ip addr show enp0s8 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//' # get the ip address of the server
```
With the ip address, access the server from the browser and check the access.log file
```bash
curl 192.168.200.10

# Access the log file
tail -f /var/log/nginx/access.log

# from the log directory
tail -f * # this will show the access.log file
```

Uninstall NGINX
```bash
sudo apt-get remove nginx nginx-common # remove nginx and nginx-common
sudo apt-get purge nginx nginx-common # remove nginx and nginx-common
sudo apt-get autoremove # remove unused packages
```



### NGINX Installation on CentOS 7/8

Centos have the yum package manager. Yum is a package manager that is used to install, update and remove packages in CentOS and Red Hat distributions. Yum is a front-end tool for rpm that automatically solves dependencies for packages. Yum is used to install, update, delete and search packages.

```bash
sudo yum update # update the package manager
yum install nginx # install nginx
```

Check if NGINX is running
```bash
ps aux | grep nginx

# results
#[root@client2 vagrant]# ps aux | grep nginx
root     25023  0.0  0.1 112828   976 pts/0    R+   13:31   0:00 grep --color=auto nginx
```
We can see that no process is running for NGINX. This is because NGINX is not running. We need to start NGINX
```bash
sudo systemctl start nginx # start nginx
sudo systemctl status nginx # check the status of nginx
sudo systemctl enable nginx # enable nginx to start at boot
sudo systemctl stop nginx # stop nginx
```

Check for the status of NGINX again
```bash
#[root@client2 vagrant]# ps aux | grep nginx
root     25037  0.0  0.1  39304   940 ?        Ss   13:32   0:00 nginx: master process /usr/sbin/nginx
nginx    25039  0.0  0.3  39696  1820 ?        S    13:32   0:00 nginx: worker process
root     25052  0.0  0.1 112828   976 pts/0    R+   13:33   0:00 grep --color=auto nginx
```


### NGINX Installation from Source code binary both on CentOS 7/8 and Ubuntu 18/20

When we are install nginx from the package manager, we can not include the modules in nginx. We can only include the modules when we install nginx from the source code. 
- We can't add the custom modules to the nginx 
- We can't the third party modules to the nginx 
To include these modules, we need to install nginx from the source code. 

```bash

# Download the source code - Mainline version : https://nginx.org/en/download.html 
#wget http://nginx.org/download/nginx-1.20.0.tar.gz
wget https://nginx.org/download/nginx-1.25.0.tar.gz

# On centos we need to first install wget before we can use it
sudo yum install wget

# Extract the source code
tar -xvf nginx-1.25.0.tar.gz

# cd into the directory and run the configure script - to build the nginx binary with the modules ()
cd nginx-1.25.0
./configure 
./configure --help # this will show the help options
#vagrant@nginx-web-server:~/nginx-1.25.0$ ./configure
checking for OS
 + Linux 4.15.0-210-generic x86_64
checking for C compiler ... not found
./configure: error: C compiler cc is not found

# To compile the nginx source code, we need to install some compiler - the gcc compiler
sudo apt-get install gcc # install gcc compiler

sudo yum install gcc
sudo yum group install "Development Tools" # this will install the gcc compiler and other tools

# Install the dependencies
#sudo apt-get install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev

# run the configure script again
./configure

# the installation fail again - failed to detect PCRE library
./configure: error: the HTTP rewrite module requires the PCRE library.
You can either disable the module by using --without-http_rewrite_module
option, or install the PCRE library into the system, or build the PCRE library
statically from the source with nginx by using --with-pcre=<path> option.
```
Note that nginx comes with two kind of libraries (modules), one is in build modules and the other one is third party modules. 
- The in build modules are the modules that comes with the nginx source code. 
- The third party modules are the modules that are not included in the nginx source code. We need to install them separately. 

```bash
# Install the PCRE library - this is the in build module
sudo apt-get install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev make # install the PCRE library
sudo yum install pcre-devel zlib-devel openss openssl-devel make  # install the PCRE library

# run the configure script once again
./configure

# Now the installation is successful
```

We can now build the nginx binary
https://nginx.org/en/docs/configure.html 
```bash
# build the nginx binary
./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-pcre --with-http_ssl_module

# a make file is created after the configure script is run

# Build the nginx binary - to compile the nginx source code
make # this will build the nginx binary

# Install the nginx binary - to install the nginx binary wihch we built from the source code
sudo make install # this will install the nginx binary
```
$ nginx -V # this will show the nginx version and the modules that are included in the nginx binary
`$

Finally, we nginx is successfully installed from the source code. We can now start nginx
```bash
# Start nginx
sudo nginx

# process running
ps aux | grep nginx
ps -ef | grep nginx
```

#### Add NGINX as a service on Ubuntu 18/20 and CentOS 7/8

The question is why to we want to add nginx as a service on the server (on the operating system) ?
- We want to start nginx automatically when the server boots up
- We want to stop nginx automatically when the server shuts down
- We want to restart nginx automatically when the server restarts
- We want to reload nginx automatically when the server reloads
- We want to enable nginx to start automatically when the server boots up
- We want to disable nginx to start automatically when the server boots up
- We want to check the status of nginx
- We want to check the nginx configuration file
- We want to check the nginx error log file
- We want to check the nginx access log file
- We want to check the nginx process id
- We want to check the nginx version
- We want to check the nginx modules
- We want to check the nginx configuration file syntax
- We want to check the nginx configuration file syntax and test it

So we need to add `NGINX` as a systemd service on the server. 

First we need to understand what is `systemd` ? and what are the services in `UNIX` and unix base system ?

`systemd` is a system and service manager for Linux operating systems. It is designed to be backwards compatible with SysV init scripts, and provides a number of features such as parallel startup of system services at boot time, on-demand activation of daemons, support for system state snapshots, or dependency-based service control logic.
    Systemd process will help us to make the process more resilient and robust. This means that if the process fails, it will automatically restart the process. 





The unix base system is a collection of programs that are used to manage the system. These programs are called services.
- The services are the programs that are used to manage the system
- The services are the programs that are used to manage the system resources
Some services are :
- The `systemd` service is used to manage the system
- The `nginx` service is used to manage the nginx web server
- The `mysql` service is used to manage the mysql database server
- The `php-fpm` service is used to manage the php-fpm server
- The `php` service is used to manage the php server
- The `apache` service is used to manage the apache web server
- The `httpd` service is used to manage the apache web server
- The `redis` service is used to manage the redis server
- The `memcached` service is used to manage the memcached server
- The `mongodb` service is used to manage the mongodb server
- The `postgresql` service is used to manage the postgresql server
- The `jenkins` service is used to manage the jenkins server
- The `docker` service is used to manage the docker server
- The `kubernetes` service is used to manage the kubernetes server
- The `gitlab` service is used to manage the gitlab server




Let's now see how to add nginx as a service on the server.
```bash
# first reboot the server
sudo reboot 
```
The process got kill after the reboot of the server. We need to start the nginx process again
```bash
# Start nginx
sudo nginx
```

The process is running again. But we want to start nginx automatically when the server boots up. So we need to add nginx as a service on the server. 
for how service to be more resilient and robust, we need to add the nginx process as a service on the server. 
```bash

# Create a service file for nginx - https://www.nginx.com/resources/wiki/start/topics/examples/systemd/ 
#sudo vim /etc/systemd/system/nginx.service
#sudo touch /lib/systemd/system/nginx.service
sudo vi /lib/systemd/system/nginx.service

# Add the following content to the nginx.service file
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
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

nginx -V # this will show the nginx version and the modules that are included in the nginx binary
nginx -h # this will show the help menu
nginx -t # this will test the nginx configuration file
nginx -s stop # this will stop the nginx process

ps -ef | grep nginx # this will show the nginx process

sudo systemctl status nginx # this will show the nginx process
sudo systemctl start nginx # this will start the nginx process
sudo systemctl stop nginx # this will stop the nginx process
sudo systemctl restart nginx # this will restart the nginx process
sudo systemctl enable nginx # this will enable the nginx process to start automatically when the server boots up
```