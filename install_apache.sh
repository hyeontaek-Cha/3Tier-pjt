#!/bin/bash

# 전체 시스템 업데이트
yum update -y

# 필수 패키지 설치
yum install -y gcc gcc-c++ expat-devel.x86_64 pcre-devel

# /usr/local/src/로 이동
cd /usr/local/src/

# PCRE 다운로드 및 설치
wget https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz
tar zxvf pcre-8.45.tar.gz
cd pcre-8.45
./configure --prefix=/usr/local/pcre
make
make install

# 소스 디렉토리로 돌아가기
cd ../

# 아파치 및 APR 소스 다운로드
wget https://dlcdn.apache.org/httpd/httpd-2.4.59.tar.gz
wget https://dlcdn.apache.org//apr/apr-1.7.4.tar.gz
wget https://dlcdn.apache.org//apr/apr-util-1.6.3.tar.gz

# 압축 해제
tar zxvf httpd-2.4.59.tar.gz
tar zxvf apr-1.7.4.tar.gz
tar zxvf apr-util-1.6.3.tar.gz

# APR 및 APR-util 파일을 아파치 소스 디렉토리로 이동
mv apr-1.7.4 ./httpd-2.4.59/srclib/apr
mv apr-util-1.6.3 ./httpd-2.4.59/srclib/apr-util

# 아파치 소스 디렉토리로 이동
cd httpd-2.4.59/

# 컴파일 설정
./configure \
--prefix=/usr/local/apache \
--with-included-apr \
--with-pcre=/usr/local/pcre

# 컴파일 및 설치
make
make install

# 아파치 서비스 스크립트 생성
echo "[Unit]
Description=apache
After=network.target syslog.target

[Service]
Type=forking
User=root
Group=root
ExecStart=/usr/local/apache/bin/apachectl start
ExecStop=/usr/local/apache/bin/apachectl stop
Umask=007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target" > /usr/lib/systemd/system/apache.service

# systemd 데몬 리로드
systemctl daemon-reload

# 아파치 서비스 활성화 및 시작
systemctl enable apache.service
systemctl start apache.service

echo "Apache installation and service setup completed successfully."