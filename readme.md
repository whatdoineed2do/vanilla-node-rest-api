# Vanilla Node REST API

_forked from bradtraversy/vanilla-node-rest-api:  added simple `Dockerfile`/`makefile`_

This is used to demonstrate [setting up a local `Openshift`/`crc` environment](https://whatdoineed2do.blogspot.com/2022/07/a-local-openshift-4x-development.html) and deploying this REST service:  a simple `/api/status` endpoint has been added to report uptime/ip of server/invocation count.  This original project was choosen to simply reduce the dependancies and size of images being deployed in examples

---
> Full CRUD REST API using Node.js with no framework

This is for learning/experimental purposes. In most cases, you would use something like Express in a production project

```
# Routes
GET      /api/products
POST     /api/products
GET      /api/products/:id
PUT      /api/products/:id
DELETE   /api/products/:id

```

## Usage

```
# Install dependencies
npm install
yarn install

# Run in develpment
npm run dev
yarn run dev

# Run in production
npm start
yarn start
```

Feel free to add to this and create a PR. I plan on creating a better router, but if you'd like to do that, feel free
