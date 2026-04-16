## Project Overview

Full-stack todo application with Express.js frontend and Flask backend, deployed on AWS ECS with Application Load Balancer (ALB).

- **Frontend**: Node.js Express server (port 3000)
- **Backend**: Python Flask API (port 5000)
- **Infrastructure**: AWS ECS, ECR, ALB, VPC (IaC with Terraform)

## Repository Structure

- **frontend/**: Node.js Express app, form submission to backend
- **backend/**: Python Flask API with todo endpoints
- **k8s/**: Kubernetes deployment manifests (optional)
- **terraform/**: AWS infrastructure as code (ECS, ECR, ALB, VPC)
- **scripts/**: Build and deployment automation
- **docker-compose.yml**: Local development setup

## Prerequisites

- **Docker** and **Docker Compose** installed
- **AWS CLI** configured with credentials
- **Terraform** (for infrastructure deployment)
- **Python 3** and `pip` (local development)
- **Node.js** and **npm** (local development)

## Running the Frontend with Docker

From the repository root:

```bash
cd frontend
docker build -t my-frontend .
docker run --rm -p 3000:3000 my-frontend
```

Then open `http://localhost:3000` in your browser.

## Running the Frontend Locally (without Docker)

From the repository root:

```bash
cd frontend
npm install
node server.js
```

The app will start on port 3000 (or as configured in `server.js`).

## Running the Backend Locally

From the repository root:

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

The backend will start on `http://localhost:5000`.

Quick check:

```bash
curl http://localhost:5000/
```

Submit a sample item (note the `/api/` prefix):

```bash
curl -X POST http://localhost:5000/api/submittodoitem \
  -H "Content-Type: application/json" \
  -d '{"itemName":"Test","itemDescription":"Demo"}'
```

GET request to check expected format:

```bash
curl http://localhost:5000/api/submittodoitem
```

## Running the Backend with Docker

From the repository root:

```bash
docker build -t my-backend ./backend
docker run --rm -p 5000:5000 my-backend
```

The backend will be available at `http://localhost:5000`.

## Troubleshooting

### Error connecting to backend

**Issue**: Frontend receives "Error connecting to backend"

**Causes & Solutions**:

1. **Incorrect API endpoint**: Ensure backend routes have `/api/` prefix
   - Backend routes should be: `/api/submittodoitem`
   - Frontend should call: `http://backend-url/api/submittodoitem`

2. **Backend not running**: Verify backend is accessible
   ```bash
   curl http://backend-url:5000/
   ```

3. **ALB health checks failing**: Check ECS target group
   - Verify backend tasks are registered and healthy
   - Check security groups allow inbound on port 5000

4. **CORS issues**: Backend has CORS enabled with `flask_cors`

5. **Network connectivity**: Verify frontend and backend are in same VPC/accessible to each other

Note for frontend + Docker: the frontend code calls the backend API endpoint. Update the backend URL in `frontend/server.js` if needed for your environment.

## Docker Compose (Local Development)

Run both frontend and backend locally:

```bash
docker-compose up -d
```

- Frontend: http://localhost:3000
- Backend: http://localhost:5000

Stop services:

```bash
docker-compose down
```

## AWS ECS Deployment

### 1. Build and Push Flask Backend to ECR

```bash
cd backend

# Build image
docker build -t flask-repo:latest .

# Tag with ECR URL
docker tag flask-repo:latest 669468173350.dkr.ecr.us-east-1.amazonaws.com/flask-repo:latest

# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 669468173350.dkr.ecr.us-east-1.amazonaws.com

# Push to ECR
docker push 669468173350.dkr.ecr.us-east-1.amazonaws.com/flask-repo:latest
```

### 2. Build and Push Express Frontend to ECR

```bash
cd frontend

# Build image
docker build -t express-repo:latest .

# Tag with ECR URL
docker tag express-repo:latest 669468173350.dkr.ecr.us-east-1.amazonaws.com/express-repo:latest

# Push to ECR
docker push 669468173350.dkr.ecr.us-east-1.amazonaws.com/express-repo:latest
```

### 3. Deploy to ECS

Update ECS services to use new images:

```bash
# Update Flask backend service
aws ecs update-service \
  --cluster app-cluster \
  --service flask-service \
  --force-new-deployment \
  --region us-east-1

# Update Express frontend service
aws ecs update-service \
  --cluster app-cluster \
  --service express-service \
  --force-new-deployment \
  --region us-east-1
```

## Terraform Infrastructure

Deploy AWS infrastructure (VPC, ECS cluster, ALB, ECR):

```bash
cd terraform

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply
```

Outputs will include ALB endpoint URL.
docker build -t node-frontend .

### 4. Apply Kubernetes Config
kubectl apply -f k8s/

### 5. Check Pods
kubectl get pods

### 6. Check Services
kubectl get services

# CI/CD Pipeline (Jenkins + GitHub Webhook)

## 🧠 Flow

GitHub Push → Webhook → Jenkins → Build → Deploy to EC2/ECS

------------------------------------------------------------------------

## 🔹 Step 1: Install Required Jenkins Plugins

-   SSH Agent Plugin
-   Git Plugin
-   Pipeline Plugin

------------------------------------------------------------------------

## 🔹 Step 2: Add SSH Key in Jenkins

1.  Go to: Manage Jenkins → Credentials → Global → Add Credentials

2.  Select:

    -   Kind: SSH Username with private key
    -   Username: ubuntu
    -   Private Key: paste your .pem content

3.  ID: ec2-key

------------------------------------------------------------------------

## 🔹 Step 3: Jenkins Pipeline

Create `Jenkinsfile`:

``` groovy
pipeline {
    agent any

    stages {

        stage('Clone Repo') {
            steps {
                git 'https://github.com/abhaymauryadev/project-root.git'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@100.27.212.72 << EOF

                    cd project-root

                    cd backend
                    docker build -t backend .
                    docker stop backend || true
                    docker rm backend || true
                    docker run -d -p 5000:5000 --name backend backend

                    cd ../frontend
                    docker build -t frontend .
                    docker stop frontend || true
                    docker rm frontend || true
                    docker run -d -p 3000:3000 --name frontend frontend

                    EOF
                    '''
                }
            }
        }
    }
}
```

------------------------------------------------------------------------

## 🔹 Step 4: Setup Webhook (GitHub → Jenkins)

Repo → Settings → Webhooks → Add Webhook

Payload URL: https://`<your-ngrok-url>`{=html}/github-webhook/

Example: https://upright-matter-unaltered.ngrok-free.dev/github-webhook/

Content type: application/json

Events: Just the push event

------------------------------------------------------------------------

## 🔹 Step 5: Enable Jenkins Trigger

Enable: GitHub hook trigger for GITScm polling

------------------------------------------------------------------------

## 🌐 Ngrok Setup

``` bash
ngrok http 8080
```


## Development Notes

- **Environment variables**: Configure any required environment variables using a `.env` file or your preferred mechanism. Keep secrets out of version control.
- **Dependencies**: Update `package.json` in `frontend` (and the backend’s dependency files) when you add or remove libraries.
- **Linting/Formatting**: Follow your team’s standard linting and formatting tools if configured in the project (e.g. ESLint, Prettier, or PyLint for backend).

## Contributing

1. Fork the repository (if contributing externally).
2. Create a feature branch.
3. Make your changes and add tests where applicable.
4. Open a Pull Request with a clear description and screenshots/logs when relevant.

## License

Add your chosen license here (e.g. MIT, Apache‑2.0) or link to a dedicated `LICENSE` file if present.
