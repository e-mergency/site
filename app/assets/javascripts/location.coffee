@module "EMG", ->
  class @Location
    constructor: (json) ->
      @lat = json.lat
      @lon = json.lon

    getLocation: ->
      return {
        'lat': @lat,
        'lon': @lon
      }
