# docker build -t docker.io/chaituchowdary/app:1.0 docker.io/chaituchowdary/app:latest .
# docker run -itd -p 8080:3000 --name=ServerOne -h ServerOne app:latest
# docker exec -it ServerOne /bin/bash

db_user=chaitu
db_pass=123Chaitu

sudo docker run -d -t -i -e REDIS_NAMESPACE='staging' \ 
-e MONGO_ENDPOINT='MONGO_ENDPOINT=mongodb+srv://$db_user:$db_pass@cluster0.wdtudby.mongodb.net/login-app-db retryWrites=true&w=majority' \
-e ENV='dev' \
-e APP_VERSION='1.0' \
-e PORT='8080' \
-p 80:8080 \
-h ServerOne \
--name ServerOne chaituchowdary/app:latest
