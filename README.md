## Project Overview

This repository contains a simple full‑stack application with a Node.js‑based frontend (containerized via Docker) and a backend (e.g. Python/Node or another service) under active development.

The frontend is built to run inside a Docker container using Node 18 and exposes port 3000 by default.

## Repository Structure

- **frontend**: Node.js application (served via `server.js`, port 3000).
- **backend**: Backend service code and its virtual environment (if present).

## Prerequisites

- **Docker** installed and running.
- **Python 3** and `pip` (only if you want to run the backend locally).
- Optionally **Node.js** and **npm** if you want to run the frontend without Docker.

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

Submit a sample item:

```bash
curl -X POST http://localhost:5000/submittodoitem \
  -H "Content-Type: application/json" \
  -d '{"itemName":"Test","itemDescription":"Demo"}'
```

## Running the Backend with Docker

From the repository root:

```bash
docker build -t my-backend ./backend
docker run --rm -p 5000:5000 my-backend
```

The backend will be available at `http://localhost:5000`.

Note for frontend + Docker: the frontend code calls `http://localhost:5000/...`. If the frontend is running inside a Docker container too, `localhost` will refer to that container, not the host. In that case, run the backend and frontend accordingly (or update the frontend URL to reach the backend container).

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
