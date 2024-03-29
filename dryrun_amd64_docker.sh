db_user=chaitu
db_pass=123Chaitu

## delete all existing docker containers
#docker rm -f $(docker ps -a -q)
#
## delete all existing docker images
#docker rmi -f $(docker images -q)

docker run -d -t -i \
  -e MONGO_ENDPOINT="mongodb+srv://$db_user:$db_pass@cluster0.wdtudby.mongodb.net/login-app-db?retryWrites=true&w=majority" \
  -e ENV='dev' \
  -e APP_VERSION='5.0' \
  -e PORT='8800' \
  -p 9000:8800 \
  -h ServerOne \
  --name server-one chaituchowdary/app:latest

echo "docker exec -it server-one sh"
