let dns = require('dns')
dns.lookup('db', (err, result) => {
console.log('The IP of the db is: ', result)
})