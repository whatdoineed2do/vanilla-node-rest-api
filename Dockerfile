FROM node:18-alpine3.15

WORKDIR /app

# build outside of docker packaging
# npm ci --only=production
COPY . .

EXPOSE 8080
CMD node server.js
