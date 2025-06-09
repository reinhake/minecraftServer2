#!/bin/bash
sudo yum update
sudo yum upgrade
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz
sudo tar -xvzf jdk-21_linux-x64_bin.tar.gz -C /opt/

export JAVA_HOME=/opt/jdk-21.0.7
echo "export JAVA_HOME=/opt/jdk-21.0.7" >> /etc/profile
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
source /etc/profile

useradd -m -r -d /opt/minecraft -s /bin/bash minecraft

mkdir /opt/minecraft/server
cd /opt/minecraft/server

wget https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar -O server.jar
echo "eula=true" > eula.txt
chown -R minecraft:minecraft /opt/minecraft

cat <<EOF > /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network.target

[Service]
WorkingDirectory=/opt/minecraft/server
ExecStart=/opt/jdk-21.0.7/bin/java -Xmx2048M -Xms1024M -jar server.jar nogui
User=minecraft
Restart=on-failure
SuccessExitStatus=0 1
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service

sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service