'use strict';

const IsFibonacci = require('is-fibonacci');

const index = (request, reply) => {

    let option = request.payload.option;

    //no option
    if (!option) {
        return error(reply, 400, 'Must provide command begin|end or a number');
    }

    //begin session
    if (option === 'begin') {
        return reply({ message: 'Started new planning poker session' });
    }

    //end option
    if (option === 'end') {
        return reply({ message: 'Finished planning poker session' });
    }

    if (!Number(option)) {
        return error(reply, 400, 'Must provide command begin|end or a number');
    }

    option = Number(option);

    //number/vote
    if (!IsFibonacci(option)) {
        return error(reply, 400, 'Must be a fibonacci number (1, 2, 3, 5, 8, 13...)');
    }

    reply({ message: `Voted ${option}` });
};

const error = (reply, status = 500, message = '') => {

    const response = reply({ error: message });
    response.statusCode = status;
    return false;
};

module.exports = [{
    method : 'POST',
    path   : '/',
    handler: index
}];
