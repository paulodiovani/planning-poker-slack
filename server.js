'use strict';

const Hapi   = require('hapi');
const Good   = require('good');
const Config = require('./config');

const server = new Hapi.Server();

server.connection({
  port: process.env.PORT || Config.connection.port
});

server.register({
  register: Good,
  options: {
    reporters: {
      console: [{
        module: 'good-squeeze',
        name: 'Squeeze',
        args: [Config.goodSqueeze]
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
