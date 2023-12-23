docker build -t docker.io/chaituchowdary/app:1.0 docker.io/chaituchowdary/app:latest .
docker run -itd -p 8080:3000 --name=ServerOne -h ServerOne app:latest
docker exec -it ServerOne /bin/bash