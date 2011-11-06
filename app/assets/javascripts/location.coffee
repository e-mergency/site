@module "EMG", ->
  class @Location
    constructor: (json) ->
      @lat = json.latitude
      @lon = json.longitude
      @name = json.name

    getLocation: ->
      return {
        'lat': @lat,
        'lon': @lon
      }

    getName: ->
      @name
