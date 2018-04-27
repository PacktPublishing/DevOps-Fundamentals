 var test = require('tape')

 test('It just works', (t) => {
  throw "error"
  t.ok(1, 'I told you it works' )
  t.end()
})
