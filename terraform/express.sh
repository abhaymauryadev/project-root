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
apt install nodejs npm -y

cat <<EOF > server.js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Express Frontend Running on Separate EC2');
});

app.listen(3000, '0.0.0.0');
EOF

npm init -y
npm install express

nohup node server.js &