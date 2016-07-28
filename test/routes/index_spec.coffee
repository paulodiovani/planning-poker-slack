describe 'Index Route', ->
  option = null
  channel_id = 'C2147483705'

  payload = (option, channel_id) ->
    token: 'd74735605d5e35f005c09054c2f6684c'
    team_id: 'T0001'
    team_domain: 'example'
    channel_id: channel_id
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
      payload: payload(option, channel_id)

    server.inject(req).then (@res) =>

  context 'without option', ->
    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'returns an ephemeral response', (done) ->
      expect(@res.result).to
        .include response_type: 'ephemeral'
      done()

    it 'returns an error message', (done) ->
      expect(@res.result).to
        .include text: 'Must provide command begin|end or a number'
      done()

  context 'with invalid command as option', ->
    before (done) ->
      option = 'foo bar'
      done()

    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'returns an ephemeral response', (done) ->
      expect(@res.result).to
        .include response_type: 'ephemeral'
      done()

    it 'returns an error message', (done) ->
      expect(@res.result).to
        .include text: 'Must provide command begin|end or a number'
      done()

  context 'with a non fibonacci number as option', ->
    before (done) ->
      option = 10
      done()

    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'returns an ephemeral response', (done) ->
      expect(@res.result).to
        .include response_type: 'ephemeral'
      done()

    it 'returns an error message', (done) ->
      expect(@res.result).to
        .include text: 'Must be a fibonacci number (0, 1, 2, 3, 5, 8...) or `?`'
      done()

  context 'with a fibonacci number as option', ->
    before (done) ->
      option = 13
      done()

    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'returns an ephemeral response', (done) ->
      expect(@res.result).to
        .include response_type: 'ephemeral'
      done()

    it 'returns an success message', (done) ->
      expect(@res.result).to
        .include text: "Voted #{option}"
      done()

  context 'with an `?` as option', ->
    before (done) ->
      option = '?'
      done()

    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'returns an ephemeral response', (done) ->
      expect(@res.result).to
        .include response_type: 'ephemeral'
      done()

    it 'returns an success message', (done) ->
      expect(@res.result).to
        .include text: "Voted #{option}"
      done()

  context 'with begin command as option', ->
    before (done) ->
      option = 'begin'
      done()

    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'returns an in_channel response', (done) ->
      expect(@res.result).to
        .include response_type: 'in_channel'
      done()

    it 'starts a new session', (done) ->
      expect(@res.result).to
        .include text: 'Started new planning poker session'
      done()

  context 'with end command as option', ->
    before (done) ->
      option = 'end'
      done()

    beforeEach ->
      server.inject(method: 'POST', url: '/', payload: payload('begin', channel_id) )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload(5, channel_id) )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload(3, channel_id) )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload(8, channel_id) )

    it 'returns a 200 (success) status', (done) ->
      expect(@res.statusCode).to.equal 200
      done()

    it 'returns an in_channel response', (done) ->
      expect(@res.result).to
        .include response_type: 'in_channel'
      done()

    it 'ends current session', (done) ->
      expect(@res.result).to
        .include text: 'Finished planning poker session'
      done()

    it 'prints votes', (done) ->
      expect(@res.result.attachments).to
        .include text: 'Votes: 5, 3, 8'
      done()

    it 'prints average point value', (done) ->
      expect(@res.result.attachments).to
        .include text: 'Average point value: 5'
      done()

  context 'when used with concurrency', ->
    beforeEach ->
      server.inject(method: 'POST', url: '/', payload: payload('begin', 'chan1') )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload('begin', 'chan2') )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload(5, 'chan1') )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload(13, 'chan2') )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload(5, 'chan1') )
        .then ->
          server.inject(method: 'POST', url: '/', payload: payload(13, 'chan2') )

    describe 'channel 1', ->
      before (done) ->
        option = 'end'
        channel_id = 'chan1'
        done()

      it 'checks only channel 1 votes', (done) ->
        expect(@res.result.attachments).to
          .include text: 'Votes: 5, 5'
        done()

      it 'calculates only channel 1 votes', (done) ->
        expect(@res.result.attachments).to
          .include text: 'Average point value: 5'
        done()

    describe 'channel 2', ->
      before (done) ->
        option = 'end'
        channel_id = 'chan2'
        done()

      it 'checks only channel 1 votes', (done) ->
        expect(@res.result.attachments).to
          .include text: 'Votes: 13, 13'
        done()

      it 'calculates only channel 2 votes', (done) ->
        expect(@res.result.attachments).to
          .include text: 'Average point value: 13'
        done()
