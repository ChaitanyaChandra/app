#!/bin/bash

db_user=chaitu
db_pass=123Chaitu
export MONGO_ENDPOINT="mongodb+srv://$db_user:$db_pass@cluster0.wdtudby.mongodb.net/login-app-db?retryWrites=true&w=majority"
export ENV='dev'
export APP_VERSION='5.0'
export PORT='9000'
npm install && node index.js
