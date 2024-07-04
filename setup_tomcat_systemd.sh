#!/bin/bash

# Tomcat 서비스 유닛 파일 생성
cat <<EOF | sudo tee /usr/lib/systemd/system/tomcat.service
[Unit]
Description=tomcat10
After=network.target syslog.target

[Service]
Type=forking

User=root
Group=root

ExecStart=/usr/local/tomcat10/bin/startup.sh
ExecStop=/usr/local/tomcat10/bin/shutdown.sh
UMask=0007

[Install]
WantedBy=multi-user.target
EOF

# 시스템 데몬 재로드
sudo systemctl daemon-reload

# Tomcat 서비스 활성화
sudo systemctl enable tomcat.service

# Tomcat 서비스 시작
sudo systemctl start tomcat.service

# Tomcat 서비스 상태 확인
sudo systemctl status tomcat.service