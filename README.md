# Go Web Application

This is a simple website written in Golang. It uses the `net/http` package to serve HTTP requests.

## Running the server

To run the server, execute the following command:

```bash
go build -o main .
go run main.go
./main
```
The server will start on port 8080. You can access it by navigating to `http://localhost:8080/courses` in your web browser.

# Stage 1 Containerization

Create a multi stage Dockefile

	1. stage 1 a normal base image
	
	2. stage 2 a distroless image (security & lightweght)

Build the image 
```bash
docker build -t efritznel/webapp-eks-github-actions:v1
```

Check if the containerization is successful push it to DockerHub
```bash
docker run -p 8080:8080 -it efritznel/webapp-eks-github-actions:v1

docker push efritznel/webapp-eks-github-actions:v1
```

# Stage 2: Setup EKS cluster
	1. Created VPC and EKS cluster using Terraform
	
	2. Created a folder K8s with all the manifest file (Deployment, Service, Ingress)
	
	3. Deployed them using kubectl
	
	4. Deployed the Ingress Controller type nginx
	```bash
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml
	```
	5. Test the website is working from the cluster, then delete everything. We will setup HELM and CI/CD

# Stage 3: Helm Configuration
	1. Create a folder Helm
	
	2. Inside the folder run the command:
	```bash
		helm create go-web-app-chart
	```
	3. Inside templates: copy all the manifest files, setup values.yaml
	
		NB. we declared image in deployment.yaml like this:
		```bash
		image: efritznel/webapp-eks-github-actions:{{ .Values.image.tag }}
		```	
		and declared the the value in values.yaml
		```bash
		image:
			repository: efritznel/webapp-eks-github-actions
			pullPolicy: IfNotPresent
			# Overrides the image tag whose default is the chart appVersion.
			tag: "23026999433"
		```	
	4. run the helm command below to test the application then delete everything 
	
		```bash
		helm install webapp /go-web-app-chart 
		helm uninstall webapp
		```	

## Looks like this

![Website](https://github.com/efritznel/webapp-eks-github-actions/blob/main/static/images/golang-website.JPG)


