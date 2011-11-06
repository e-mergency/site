@module "EMG", ->
  class @Location
    constructor: (json) ->
      @lat = json.lat
      @lon = json.lon
      @name = json.name

    getLocation: ->
      return {
        'lat': @lat,
        'lon': @lon
      }

    getName: ->
      @name
