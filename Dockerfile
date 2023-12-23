FROM node:alpine
WORKDIR '/app'
COPY . .
RUN npm install
CMD ["npm","start"]
# ENTRYPOINT ["/usr/local/bin/npm", "start"]