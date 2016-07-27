Lab  = require('lab')
lab  = exports.lab = Lab.script()
Code = require('code')

global.describe   = lab.describe
global.context    = lab.describe
global.it         = lab.it
global.before     = lab.before
global.beforeEach = lab.beforeEach
global.after      = lab.after
global.afterEach  = lab.afterEach
global.expect     = Code.expect

global.server = require('../server')
