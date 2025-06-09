#!/bin/bash
sudo yum update
sudo yum upgrade

# Download the latest version of Java 21 and unzip it
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz
sudo tar -xvzf jdk-21_linux-x64_bin.tar.gz -C /opt/

# Setup the PATH variables for Java to work
export JAVA_HOME=/opt/jdk-21.0.7
echo "export JAVA_HOME=/opt/jdk-21.0.7" >> /etc/profile
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
source /etc/profile

# Add a deticated minecraft user to run the server from
useradd -m -r -d /opt/minecraft -s /bin/bash minecraft

# Create the directory that the server will reside in
mkdir /opt/minecraft/server
cd /opt/minecraft/server

# Download the minecraft server Jar (Change this link to download a newer version)
wget https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar -O server.jar
echo "eula=true" > eula.txt
chown -R minecraft:minecraft /opt/minecraft

# Setup Minecraft to run as a service managed by systemd
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