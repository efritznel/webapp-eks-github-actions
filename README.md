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


## Looks like this

![Website](https://github.com/efritznel/webapp-eks-github-actions/blob/main/static/images/golang-website.JPG)


