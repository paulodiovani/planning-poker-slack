'use strict';

const environment = process.env.NODE_ENV || 'development';

module.exports = require(`./environment/${environment}`);
