# Planning Poker Bot for Slack

A Slack App to help using planning poker for SCRUM projects

## Dependencies

- Node.js ^6.2.2
- Redis

## Spec tests

```bash
npm install
npm test
```

## Running local

```bash
npm install
npm start
```

You can test with `curl`.

```bash
curl  -X POST -H 'Content-Type: application/json' -d '{"option": "begin"}' http://localhost:3000/
{"message":"Started new planning poker session"}

curl  -X POST -H 'Content-Type: application/json' -d '{"option": "8"}' http://localhost:3000/
{"message":"Voted 8"}

curl  -X POST -H 'Content-Type: application/json' -d '{"option": "8"}' http://localhost:3000/
{"message":"Voted 8"}

curl  -X POST -H 'Content-Type: application/json' -d '{"option": "8"}' http://localhost:3000/
{"message":"Voted 8"}

curl  -X POST -H 'Content-Type: application/json' -d '{"option": "13"}' http://localhost:3000/
{"message":"Voted 13"}

curl  -X POST -H 'Content-Type: application/json' -d '{"option": "21"}' http://localhost:3000/
{"message":"Voted 21"}

curl  -X POST -H 'Content-Type: application/json' -d '{"option": "3"}' http://localhost:3000/
{"message":"Voted 3"}

curl  -X POST -H 'Content-Type: application/json' -d '{"option": "end"}' http://localhost:3000/
{"message":"Finished planning poker session\nVotes: 8, 8, 8, 13, 21, 3\nAverage point value: 8"}
```
