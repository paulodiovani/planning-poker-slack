'use strict';

const Redis = require('redis');

const client = Redis.createClient(process.env.REDIS_URL);

const FIBONACCI = [0, 1, 1, 2, 3, 5, 8, 13, 21];
const KEY = 'planning-poker';

const index = (request, reply) => {

    let option = request.payload.option;

    //no option
    if (!option) {
        return error(reply, 400, 'Must provide command begin|end or a number');
    }

    //begin session
    if (option === 'begin') {
        return client.del(KEY, (err) => {

            if (err) {
                return error(reply, 500, err.message);
            }
            reply({ message: 'Started new planning poker session' });
        });
    }

    //end option
    if (option === 'end') {
        return client.lrange(KEY, 0, -1, (err, values) => {

            if (err) {
                return error(reply, 500, err.message);
            }

            let message = '';
            message += 'Finished planning poker session\n';
            message += `Votes: ${values.join(', ')}\n`;
            message += `Average point value: ${avg(values)}`;

            client.del(KEY, (err) => {

                if (err) {
                    return error(reply, 500, err.message);
                }
                reply({ message: message });
            });
        });
    }

    if (option === '?') {
        //ignore vote
        return reply({ message: `Voted ${option}` });
    }

    if (!Number(option)) {
        return error(reply, 400, 'Must provide command begin|end or a number');
    }

    option = Number(option);

    //number/vote
    if (!FIBONACCI.includes(option)) {
        return error(reply, 400, 'Must be a fibonacci number (0, 1, 2, 3, 5, 8, 13, 21) or `?`');
    }

    client.rpush(KEY, option, (err) => {

        if (err) {
            return error(reply, 500, err.message);
        }
        reply({ message: `Voted ${option}` });
    });
};

const error = (reply, status = 500, message = '') => {

    const response = reply({ error: message });
    response.statusCode = status;
    return false;
};

const avg = (values) => {

    const sum = values.reduce(((memo, value) => memo + Number(value)), 0);
    return sum / values.length;
};

module.exports = [{
    method : 'POST',
    path   : '/',
    handler: index
}];
