describe 'Index Route', ->
  option = null

  payload = (option) ->
    token: 'd74735605d5e35f005c09054c2f6684c'
    team_id: 'T0001'
    team_domain: 'example'
    channel_id: 'C2147483705'
    channel_name: 'test'
    user_id: 'U2147483697'
    user_name: 'Steve'
    command: '/planningpoker'
    text: option
    response_url: 'https://hooks.slack.com/commands/1234/5678'

  beforeEach ->
    req =
      method: 'POST'
      url: '/'
      payload: payload(option)

    server.inject(req).then (@res) =>

  context 'without option', ->
    it 'returns a 400 (bad request) status', (done) ->
      expect(@res.statusCode).to.equal 400
      done()

    it 'returns an error message', (done) ->
      expect(@res.result).to
        .include error: 'Must provide command begin|end or a number'
      done()

  context 'with invalid command as option', ->
    before (done) ->
      option = 'foo bar'
      done()

    it 'returns a 400 (bad request) status', (done) ->
      expect(@res.statusCode).to.equal 400
      done()

    it 'returns an error message', (done) ->
      expect(@res.result).to
        .include error: 'Must provide command begin|end or a number'
      done()

  context 'with a non fibonacci number as option', ->
    before (done) ->
      option = 10
      done()

    it 'returns a 400 (bad request) status', (done) ->
      expect(@res.statusCode).to.equal 400
      done()

    it 'returns an error message', (done) ->
      expect(@res.result).to
        .include error: 'Must be a fibonacci number (0, 1, 2, 3, 5, 8...) or `?`'
      done()

  context 'with a fibonacci number as option', ->
    before (done) ->
      option = 13
      done()

    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'returns an success message', (done) ->
      expect(@res.result).to
        .include message: "Voted #{option}"
      done()

  context 'with an `?` as option', ->
    before (done) ->
      option = '?'
      done()

    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'returns an success message', (done) ->
      expect(@res.result).to
        .include message: "Voted #{option}"
      done()

  context 'with begin command as option', ->
    before (done) ->
      option = 'begin'
      done()

    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'starts a new session', (done) ->
      expect(@res.result).to
        .include message: 'Started new planning poker session'
      done()

  context 'with end command as option', ->
    before (done) ->
      option = 'end'
      done()

    beforeEach ->
      server.inject(method: 'POST', url: '/', payload: payload('begin') )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload(5) )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload(3) )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload(8) )

    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'ends current session', (done) ->
      expect(@res.result.message).to
        .match /Finished planning poker session/
      done()

    it 'prints votes', (done) ->
      expect(@res.result.message).to
        .match /Votes: 5, 3, 8/
      done()

    it 'prints average point value', (done) ->
      expect(@res.result.message).to
        .match /Average point value: 5/
      done()
