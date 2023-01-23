#!/bin/bash

# setup user 
adduser spec

# install mongodb
curl -s https://raw.githubusercontent.com/ChaitanyaChandra/DevOps/main/2.ANSIBLE/roles/mongodb/files/mongo.repo > /etc/yum.repos.d/mongodb-org-6.0.repo

dnf --disablerepo=AppStream install -y mongodb-org

sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

systemctl restart mongod

curl -sL https://rpm.nodesource.com/setup_10.x | bash -
yum install nodejs -y 

yum install git -y 
cd /home/spec/
git clone https://github.com/ChaitanyaChandra/app.git
cd app/
cat package.sh | bash
cp spec.service /etc/systemd/system/
systemctl start spec
# node .js > node.logs 2>&1 &
# ps -ef | grep "index.js" > run.log
