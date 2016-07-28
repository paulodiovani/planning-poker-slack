'use strict';

const Redis = require('redis');

const client = Redis.createClient(process.env.REDIS_URL);

const FIBONACCI = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];

const index = (request, reply) => {

    let option = request.payload.text;
    const key = `${request.payload.team_id}:${request.payload.channel_id}`;

    //no option
    if (!option) {
        return reply(answer('Must provide command begin|end or a number'));
    }

    //begin session
    if (option === 'begin') {
        return client.del(key, (err) => {

            if (err) {
                return reply(answer(err.message));
            }
            reply(answer('Started new planning poker session', 'in_channel'));
        });
    }

    //end option
    if (option === 'end') {
        return client.lrange(key, 0, -1, (err, values) => {

            if (err) {
                return reply(answer(err.message));
            }

            const message = 'Finished planning poker session';
            const attachments = [{
                text: `Votes: ${values.join(', ')}`
            }, {
                text: `Average point value: ${resultFib(values)}`
            }];

            client.del(key, (err) => {

                if (err) {
                    return reply(answer(err.message));
                }
                reply(answer(message, 'in_channel', attachments));
            });
        });
    }

    if (option === '?') {
        //ignore vote
        return reply(answer(`Voted ${option}`));
    }

    if (!Number(option)) {
        return reply(answer('Must provide command begin|end or a number'));
    }

    option = Number(option);

    //number/vote
    if (!FIBONACCI.includes(option)) {
        return reply(answer('Must be a fibonacci number (0, 1, 2, 3, 5, 8...) or `?`'));
    }

    client.rpush(key, option, (err) => {

        if (err) {
            return reply(answer(err.message));
        }
        reply(answer(`Voted ${option}`));
    });
};

const answer = (text, response_type = 'ephemeral', attachments = []) => {

    return {
        response_type,
        text,
        attachments
    };
};

const resultFib = (values) => {

    const sum = values.reduce(((memo, value) => memo + Number(value)), 0);
    const avg = sum / values.length;
    return FIBONACCI.reduce((prev, next) => {

        if (next < avg) {
            return next;
        }
        return (avg - prev < next - avg) ? prev : next;
    }, 0);
};

module.exports = [{
    method : 'POST',
    path   : '/',
    handler: index
}];
