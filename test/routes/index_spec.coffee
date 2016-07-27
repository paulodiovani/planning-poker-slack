describe 'Index Route', ->
  option = null

  beforeEach ->
    req =
      method: 'POST'
      url: '/'
      payload: option

    server.inject(req).then (@res) =>

  context 'without option', ->
    it 'returns a 400 (bad request) status', (done) ->
      expect(@res.statusCode).to.equal 400
      done()

  context 'with a non fibonacci number as option', ->
    before (done) ->
      option = 10
      done()

    it 'returns a 400 (bad request) status', (done) ->
      expect(@res.statusCode).to.equal 400
      done()

  context 'with a fibonacci number as option', ->
    before (done) ->
      option = 13
      done()

    it 'returns a 200 (success) statys', (done) ->
      expect(@res.statusCode).to.equal 200
      done()
