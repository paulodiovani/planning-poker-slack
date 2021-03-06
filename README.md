[![Build Status](https://travis-ci.org/paulodiovani/planning-poker-slack.svg?branch=master)](https://travis-ci.org/paulodiovani/planning-poker-slack)
[![Dependency Status](https://david-dm.org/paulodiovani/planning-poker-slack.svg)](https://david-dm.org/paulodiovani/planning-poker-slack)
[![devDependency Status](https://david-dm.org/paulodiovani/planning-poker-slack/dev-status.svg)](https://david-dm.org/paulodiovani/planning-poker-slack#info=devDependencies)
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

# Planning Poker for Slack

A Slack App to help using planning poker for SCRUM projects

![example](docs/img/example.jpg)

## Dependencies

- Node.js ^6.2.2
- Redis

## Spec tests

```bash
npm install
npm test
```

## Set Up

1. Deploy to Heroku or you preferred hosting service.
2. Configure as a [_Slash Command_ for Slack](https://api.slack.com/slash-commands)

## Roadmap and TODO list

- [x] Version 0.1.0
    - [x] Create a default REST endpoint
    - [x] Parse simple commands or vote value
    - [x] Allow Fibonacci votes
    - [x] Build on Travis CI
    - [x] Prepare for heroku deploy
    - [x] Setup for work as a Slack App command (`/planning-poker` or `/pp`)
- [ ] Version 0.2.0
    - [ ] Add an index page and API docs
    - [x] Update README with how to set up on Slack
- [ ] Version 1.0.0
    - [ ] Split methods in reusable modules (probably under `lib/`)
    - [x] Allow concurrent poker sessions
    - [ ] Show which users already voted
    - [ ] Forbid duplicate votes per user
- [ ] Version 1.1.0
    - [ ] Allow Standart _Planning Poker_ votes (0, 1, 2, 3, 5, 8, 13, 20, 40, 100, ?, :coffee:)
- [ ] Version 1.2.0
    - [ ] Allow ordinary incremental points (0, 1, 2, 3, 4, 5, 6...)
