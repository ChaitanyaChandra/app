#!/bin/bash

# setup user 
sudo adduser spec

# install mongodb
curl -s https://raw.githubusercontent.com/ChaitanyaChandra/DevOps/main/2.ANSIBLE/roles/mongodb/files/mongo.repo > /etc/yum.repos.d/mongodb-org-4.2.repo

yum install –y mongodb-org

sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/yum.repos.d/mongo.repo

systemctl restart mongod

curl -sL https://rpm.nodesource.com/setup_10.x | bash -
yum install nodejs -y 

yum install git -y 
cd /home/spec/
git clone https://github.com/ChaitanyaChandra/app.git
cd app/
npm  install
systemctl start spec
# node .js > node.logs 2>&1 &
# ps -ef | grep "index.js" > run.log
