process.env.NODE_ENV = 'test'

global.expect = require('chai').expect
global.server = require('../server')
