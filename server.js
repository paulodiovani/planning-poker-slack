'use strict';

const Hapi   = require('hapi');
const Good   = require('good');
const config = require('./config');

const server = new Hapi.Server();

server.connection({
  port: process.env.PORT || config.connection.port
});

server.register({
  register: Good,
  options: {
    reporters: {
      console: [{
        module: 'good-squeeze',
        name: 'Squeeze',
        args: [config['good-squeeze']]
      }, {
        module: 'good-console'
      }, 'stdout']
    }
  }
}, (err) => {
  if (err) {
    throw err;
  }
});

// Routes goes here
server.route(require('./routes/index'));

module.exports = server;
