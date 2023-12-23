#!/bin/bash

db_user=chaitu
db_pass=123Chaitu
export MONGO_ENDPOINT=mongodb+srv://$db_user:$db_pass@cluster0.wdtudby.mongodb.net/login-app-db?retryWrites=true&w=majority \
export ENV='dev' \
export APP_VERSION='1.0' \
export PORT='8080' \
npm install && node index.js