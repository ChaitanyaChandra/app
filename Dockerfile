FROM node:alpine
WORKDIR '/app'
COPY . .
RUN npm install
ENTRYPOINT ["/usr/local/bin/npm", "start"]