const http = require('http')
const { getProducts, getProduct, createProduct, updateProduct, deleteProduct } = require('./controllers/productController')
var ip = require("ip")
var reqs = 0

const server = http.createServer((req, res) => {

    reqs += 1
    console.log(Date() + ": #" + reqs + "  " + req.method + " " + req.url + " " + JSON.stringify(req.headers))

    if (req.url === "/" && req.method === "GET") {
        res.writeHead(200, { "Content-Type": "application/json" });
	const routes = {
	    GET:  [ "/", "/api/health", "/api/products", "/api/products/:id" ],
	    POST: [ "/api/products" ],
	    PUT:  [ "/api/products/:id" ],
	    DELETE: [ "/api/products/:id" ]
	}
        res.end(JSON.stringify(routes));
    }
    else if (req.url === "/api/health" && req.method === "GET") {
        res.writeHead(200, { "Content-Type": "application/json" });
        const stat = {
	    ip: ip.address(),
            uptime: process.uptime(),
            timestamp: Date.now(),
	    requests: reqs
        };
        res.end(JSON.stringify(stat));
    }
    else if(req.url === '/api/products' && req.method === 'GET') {
        getProducts(req, res)
    } else if(req.url.match(/\/api\/products\/\w+/) && req.method === 'GET') {
        const id = req.url.split('/')[3]
        getProduct(req, res, id)
    } else if(req.url === '/api/products' && req.method === 'POST') {
        createProduct(req, res)
    } else if(req.url.match(/\/api\/products\/\w+/) && req.method === 'PUT') {
        const id = req.url.split('/')[3]
        updateProduct(req, res, id)
    } else if(req.url.match(/\/api\/products\/\w+/) && req.method === 'DELETE') {
        const id = req.url.split('/')[3]
        deleteProduct(req, res, id)
    } else {
        res.writeHead(404, { 'Content-Type': 'application/json' })
        res.end(JSON.stringify({ message: 'Route Not Found' }))
    }
})

const PORT =  process.env.PORT || 8080

server.listen(PORT, () => console.log(`Server running on port ${PORT}`))

module.exports = server;
