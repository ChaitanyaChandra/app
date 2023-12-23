# docker build -t docker.io/chaituchowdary/app:1.0 docker.io/chaituchowdary/app:latest .
# docker run -itd -p 8080:3000 --name=ServerOne -h ServerOne app:latest

db_user=chaitu
db_pass=123Chaitu
endpoint="mongodb+srv://$db_user:$db_pass@cluster0.wdtudby.mongodb.net/login-app-db?retryWrites=true&w=majority"
echo $endpoint

# delete all existing docker images
docker rmi -f $(docker images -q)

# delete all existing docker containers
docker rm -f $(docker ps -a -q)

docker run -d -t -i \
  -e MONGO_ENDPOINT="$endpoint" \
  -e ENV='dev' \
  -e APP_VERSION='3.0' \
  -e PORT='9000' \
  -p 8800:9000 \
  -h ServerOne \
  --name server-one chaituchowdary/app:latest

docker exec -it ServerOne /bin/bash
