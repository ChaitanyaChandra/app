#docker build -f arm64_Dockerfile -t docker.io/chaituchowdary/app:arm64_5.0 -t docker.io/chaituchowdary/app:arm64_latest .
#docker push docker.io/chaituchowdary/app:arm64_latest
#docker push docker.io/chaituchowdary/app:arm64_5.0

db_user=
db_pass=

## delete all existing docker containers
#docker rm -f $(docker ps -a -q)
#
## delete all existing docker images
#docker rmi -f $(docker images -q)

docker run -d -t -i \
  -e MONGO_ENDPOINT="mongodb+srv://$db_user:$db_pass@chaitanya.kj7ag4f.mongodb.net/login-app-db?retryWrites=true&w=majority" \
  -e ENV='dev' \
  -e APP_VERSION='5.0' \
  -e PORT='8800' \
  -p 9000:8800 \
  -h ServerOne \
  --name server-one chaituchowdary/app:arm64_latest

echo "docker exec -it server-one sh"
