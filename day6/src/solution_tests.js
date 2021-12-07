const assert = require('assert')
const solution = require('./solution')

assert.equal(solution.countLanternfish([3,4,3,1,2], 18), 26)
assert.equal(solution.countLanternfish([3,4,3,1,2], 80), 5934)
