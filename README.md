setup nginx with rtmp
---
### 1. Setup C compiler for OS
#### 1.2. sudo apt install build-essential libssl-dev libc6 libpcre3 libssl0.9.8 zlib1g lsb-base (on ubuntu)
#### 1.1 brew install apple-gcc42 (OSX Mavericks)
### 2. git clone git@github.com:arut/nginx-rtmp-module.git
### 3. Download nginx stable version 1.6
#### 3.1. curl http://nginx.org/download/nginx-1.6.2.tar.gz > nginx-1.6.2.tar.gz
### 4. Compile nginx with rtmp
#### 4.1. cd to nginx and ./configure --add-module=~/work/nginx-rtmp-module --without-http_rewrite_module
#### 4.2. make
#### 4.3. make install
### 5. Copy nginx.conf file to /usr/local/nginx/conf/nginx.conf. Edit the paths for record.html and recorded videos.


