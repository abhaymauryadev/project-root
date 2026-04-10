# #!/bin/bash
# apt update -y

# curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
# apt install -y nodejs git

# cd /home/ubuntu
# git clone https://github.com/abhaymauryadev/project-root.git
# cd fullstack-app/frontend

# npm install
# nohup npm start &


#!/bin/bash
apt update -y
apt install python3-pip -y

pip3 install flask

cat <<EOF > app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Flask Backend Running on Separate EC2"

app.run(host='0.0.0.0', port=5000)
EOF

nohup python3 app.py &