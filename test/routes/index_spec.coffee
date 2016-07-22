describe 'Index Route', ->
  beforeEach ->
    req =
      method: 'GET'
      url: '/'
    server.inject(req).then (@res) =>

  it 'returns a 200 (ok) status', ->
    expect(@res.statusCode).to.eql 200
