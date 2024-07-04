#!/bin/bash

# 시스템 업데이트 및 필요한 패키지 설치
yum update -y
yum install -y gcc gcc-c++ autoconf libtool

# Tomcat Connector 다운로드 및 압축 해제
cd /usr/local/src
wget https://mirror.navercorp.com/apache/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.49-src.tar.gz
tar xvf tomcat-connectors-1.2.49-src.tar.gz

# Tomcat Connector 소스 디렉토리로 이동
cd tomcat-connectors-1.2.49-src/native

# buildconf.sh 실행
./buildconf.sh

# configure 스크립트 실행 (apxs 경로 설정)
./configure --with-apxs=/usr/local/apache/bin/apxs

# 컴파일 및 설치
make && make install

# 설치 확인
ls -lZ /usr/local/apache/modules/mod_jk.so

echo "Tomcat Connector installation completed successfully."