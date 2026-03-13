# Go Web Application – EKS CI/CD Deployment

This project demonstrates a complete DevOps workflow for deploying a Golang web application to Amazon EKS using modern cloud-native tools and practices.

The pipeline includes:

1. Containerization with Docker

2. Infrastructure provisioning with Terraform

3. Kubernetes deployment using Helm

4. CI pipeline with GitHub Actions

5. GitOps deployment using ArgoCD

The goal of this project is to demonstrate a production-style CI/CD pipeline and GitOps workflow for Kubernetes workloads on AWS.

# Architecture Overview

The application follows a typical cloud-native deployment architecture:
```yaml
Developer → GitHub Repository
        │
        │  (Push Code)
        ▼
GitHub Actions CI Pipeline
        │
        │ Build + Test + Scan
        │
        ▼
DockerHub Image Registry
        │
        │ Update Helm values.yaml
        ▼
GitOps Repository
        │
        ▼
ArgoCD
        │
        ▼
Amazon EKS Cluster
        │
        ▼
Kubernetes Pods running Go Web Application
```
# Application Overview

The application is a simple web server written in Golang using the built-in net/http package.

It exposes a web endpoint that returns application content when accessed through a browser.

Run the application locally

Build and run the application:
```yaml
go build -o main .
go run main.go
./main
```
The server will start on port 8080.

Access the application:

http://localhost:8080/courses

# Stage 1 — Containerization

The application is containerized using a multi-stage Docker build.

This approach ensures:

1. Smaller container image

2. Reduced attack surface

3. Faster deployment

# Dockerfile Strategy

Stage 1:

1. Uses a Golang base image to build the binary.

Stage 2:

2. Uses a Distroless image to run the compiled binary.

This improves:

1. Security

2. Image size

3. Performance

# Build the Docker Image
```yaml
docker build -t efritznel/webapp-eks-github-actions:v1 .
```
# Test the Container
```yaml
docker run -p 8080:8080 -it efritznel/webapp-eks-github-actions:v1
```
Verify the application is accessible locally.

# Push Image to DockerHub
```yaml
docker push efritznel/webapp-eks-github-actions:v1
```
# Stage 2 — EKS Infrastructure Setup

The Kubernetes infrastructure is provisioned using Terraform.

Terraform creates:

1. VPC

2. Public and Private Subnets

3. Internet Gateway

4. NAT Gateway

5. Amazon EKS Cluster

6. Worker Nodes

# Infrastructure Deployment
```yaml
terraform init
terraform plan
terraform apply
```
# Stage 3 — Kubernetes Deployment

Kubernetes manifests were initially deployed manually for validation.

A directory called k8s/ contains the following resources:
```yaml
k8s/
 ├── deployment.yaml
 ├── service.yaml
 └── ingress.yaml
```
Resources deployed:

1. Deployment

2. Service

3. Ingress

# Deploy Resources
```yaml
kubectl apply -f k8s/
```
# Install NGINX Ingress Controller

To expose the application externally, the NGINX Ingress Controller is deployed.
```yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml
```
Verify the ingress controller:
```yaml
kubectl get pods -n ingress-nginx
```
Once verified, the manual deployment is removed before implementing Helm and CI/CD automation.

# Stage 4 — Helm Chart Configuration

Helm is used to package and template the Kubernetes deployment.

Helm enables:

1. Versioned releases

2. Reusable deployment templates

3. Environment-specific configuration

# Create Helm Chart
```yaml
mkdir Helm
cd Helm
helm create go-web-app-chart
```
Generated chart structure:
```yaml
go-web-app-chart
 ├── Chart.yaml
 ├── values.yaml
 ├── charts/
 └── templates/
```
# Configure Helm Templates

The templates directory contains the Kubernetes resources:
```yaml
templates/
 ├── deployment.yaml
 ├── service.yaml
 ├── ingress.yaml
```
The Docker image is dynamically defined using Helm variables.

# deployment.yaml
```yaml
image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
imagePullPolicy: {{ .Values.image.pullPolicy }}
```
# values.yaml
```yaml
image:
  repository: efritznel/webapp-eks-github-actions
  pullPolicy: IfNotPresent
  tag: "23026999433"
```
This design allows the CI pipeline to update only the image tag during deployments.

# Test Helm Deployment

Install the application:
```yaml
helm install webapp ./go-web-app-chart
```
Verify deployment:
```yaml
kubectl get pods
kubectl get svc
```
Remove the release:
```yaml
helm uninstall webapp
```
# Stage 5 — Continuous Integration (GitHub Actions)

GitHub Actions handles the CI pipeline.

Pipeline stages:

1. Build the Golang application

2. Run unit tests

3. Perform static code analysis

4. Build Docker image

5. Push image to DockerHub

6. Update Helm values.yaml with new image tag

This ensures every commit produces a new deployable container image.

# Stage 6 — Continuous Deployment with ArgoCD

ArgoCD implements a GitOps deployment model.

Workflow:

1. ArgoCD monitors the Git repository.

2. When Helm values are updated, ArgoCD detects changes.

3. ArgoCD pulls the Helm chart.

4. ArgoCD deploys the updated application to EKS.

This ensures Kubernetes clusters remain fully synchronized with Git state.

# Technologies Used
```yaml
Technology	                        Purpose
Golang	                                Web Application
Docker	                                Containerization
Terraform	                        Infrastructure as Code
Amazon EKS	                        Kubernetes Platform
Helm	                                Kubernetes Packaging
GitHub Actions	                        CI Pipeline
ArgoCD	                                GitOps Deployment
NGINX Ingress	                        External Access
```
![Website](https://github.com/efritznel/webapp-eks-github-actions/blob/main/static/images/golang-website.JPG)


