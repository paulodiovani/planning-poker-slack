'use strict';

const isFibonacci = require('is-fibonacci');

module.exports = [{
  method : 'POST',
  path   : '/',
  handler: index
}];

function index(request, reply) {
  let option = request.payload;

  //no option
  if (!option) {
    return error(reply, 400, 'Option must be provided');
  }

  //command option
  // if (Number(option) == NaN) {
  // }

  option = Number(option);

  //number/vote
  if (!isFibonacci(option)) {
    return error(reply, 400, 'Not a fibonacci number');
  }

  reply({});
}

function error(reply, status = 500, message = '') {
  let response = reply(message);
  response.statusCode = status;
  return false;
}
