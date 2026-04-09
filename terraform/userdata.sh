#!/bin/bash
apt update -y

# Install Node
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Install Python
apt install -y python3 python3-pip

# Clone your repo
cd /home/ubuntu
git clone https://github.com/abhaymauryadev/project-root.git
cd fullstack-app

# Flask setup
cd backend
pip3 install flask
nohup python3 app.py &

# Express setup
cd ../frontend
npm install
nohup npm start &