# 🔐 Secure DevSecOps CI/CD Pipeline

This project implements a secure and automated CI/CD pipeline using **GitHub Actions** for a Node.js application. It incorporates DevSecOps practices with integrated security and code quality scans before deployment.

---

## 📌 Objective

To build a robust DevSecOps pipeline that automates:

- Source code build and dependency installation
- Secret scanning using **Gitleaks**
- Container vulnerability scanning using **Trivy**
- Code quality analysis using **SonarQube**

---

## 🧰 Tech Stack

| Layer             | Tools/Technologies      |
|------------------|-------------------------|
| Source Control    | GitHub                  |
| CI/CD             | GitHub Actions          |
| Programming Lang  | Node.js (Backend)       |
| Secret Scanning   | Gitleaks                |
| Image Scanning    | Trivy                   |
| Code Quality      | SonarQube               |
| Docker            | Containerized App       |

---

## ⚙️ GitHub Actions Workflow

### Trigger
- On `push` to `main` branch

### Workflow Steps

1. **Checkout Code**  
2. **Setup Node.js Environment**
3. **Install Backend Dependencies**
4. **Run Gitleaks Scan** (Secret detection)
5. **Run Trivy Scan** (Docker image vulnerabilities)
6. **Run SonarQube Scan** (Code quality and security)

---

## 🔍 Security & Quality Tools

| Tool      | Function                                      |
|-----------|-----------------------------------------------|
| Gitleaks  | Detect secrets like tokens and keys in code   |
| Trivy     | Identify OS/package vulnerabilities in images |
| SonarQube | Detect bugs, code smells, and security issues |

---

## 🖼️ Architecture Diagram

> 📎 See [`architecture.png`](./assets/architecture.png) for detailed flow.
Source Code Push (GitHub)
⬇
GitHub Actions Workflow
⬇
Run Gitleaks → Trivy → SonarQube
⬇
Generate Reports and Exit
>
> 
---

## 📂 Repository Structure

├── backend/
│ └── app.js, package.json
├── frontend/
│ └── [Optional frontend files]
├── .github/workflows/
│ └── devsecops.yml
├── terraform/
│ └── [Infra templates]
├── README.md


---

## 🚀 Getting Started

```bash
# Clone the repository
git clone https://github.com/ardevopsun/secure-devsecops-pipeline.git
cd secure-devsecops-pipeline

# Run backend app locally
cd backend
npm install
node app.js

Setup SonarQube Locally (Optional)
Pull Docker image:

bash
Copy
Edit
docker run -d -p 9000:9000 sonarqube
Access: http://localhost:9000

Create project + generate token

Set SONAR_TOKEN as GitHub secret

🧪 Run Security Scans Locally
bash
Copy
Edit
# Gitleaks
gitleaks detect --source . --redact

# Trivy
docker build -t myapp ./backend
trivy image myapp
