#!/bin/bash

# only works on centos8 aarch64

# install mongodb
curl -s https://raw.githubusercontent.com/ChaitanyaChandra/DevOps/main/2.ANSIBLE/roles/mongodb/files/mongo.repo > /etc/yum.repos.d/mongodb-org-6.0.repo

dnf --disablerepo=AppStream install -y mongodb-org

sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

systemctl restart mongod

# setup user 
adduser spec

curl -sL https://rpm.nodesource.com/setup_16.x | bash -
yum install nodejs -y 

yum install git -y 
cd /home/spec/
git clone https://github.com/ChaitanyaChandra/app.git
cd app/
cat package.sh | bash

db_user=chaitu
db_pass=123Chaitu

echo MONGO_ENDPOINT=mongodb+srv://$db_user:$db_pass@cluster0.wdtudby.mongodb.net/login-app-db?retryWrites=true&w=majority >> files/spec.service
cp files/spec.service /etc/systemd/system/
systemctl start spec

sudo yum install epel-release
sudo yum install nginx -y 

cp files/nginx.conf /etc/nginx/nginx.conf
cp files/nodejs.conf /etc/nginx/conf.d/nodejs.conf

systemctl restart nginx
# node .js > node.logs 2>&1 &
# ps -ef | grep "index.js" > run.log
