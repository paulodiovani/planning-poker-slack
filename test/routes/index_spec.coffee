describe 'Index Route', ->
  option = null

  beforeEach ->
    req =
      method: 'POST'
      url: '/'
      payload: option

    server.inject(req).then (@res) =>

  context 'without option', ->
    it 'returns a 400 (bad request) status', ->
      expect(@res.statusCode).to.eql 400

  context 'with a non fibonacci number as option', ->
    before ->
      option = 10

    it 'returns a 400 (bad request) status', ->
      expect(@res.statusCode).to.eql 400

  context 'with a fibonacci number as option', ->
    before ->
      option = 13

    it 'returns a 200 (success) statys', ->
      expect(@res.statusCode).to.eql 200
