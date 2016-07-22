'use strict';

module.exports = [{
  method : 'GET',
  path   : '/',
  handler: index
}];

function index(request, reply) {
  reply('Hello!');
}
