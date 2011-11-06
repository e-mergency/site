describe 'Location', ->
  it 'should be able to produce a location hash when asked', ->
    response = {'lat': 51.495569, 'lon': -0.176414}
    l = new EMG.Location(response)
    expect(l.getLocation()).toEqual response

  it 'shows the name when asked', ->
    expected = {
      'name': 'A location',
      'lat': 0,
      'lon': 0
    }
    l = new EMG.Location(expected)
    expect(l.getName()).toEqual expected['name']
