'use strict';

const IsFibonacci = require('is-fibonacci');

const index = (request, reply) => {

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
    if (!IsFibonacci(option)) {
        return error(reply, 400, 'Not a fibonacci number');
    }

    reply({});
};

const error = (reply, status = 500, message = '') => {

    const response = reply(message);
    response.statusCode = status;
    return false;
};

module.exports = [{
    method : 'POST',
    path   : '/',
    handler: index
}];
