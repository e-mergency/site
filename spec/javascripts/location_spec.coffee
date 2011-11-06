describe 'Location', ->
  it 'Given input variables, it should be able to produce them', ->
    response = {'lat': 51.495569, 'lon': -0.176414}
    l = new EMG.Location(response)
    expect(l.getLocation()).toEqual response
