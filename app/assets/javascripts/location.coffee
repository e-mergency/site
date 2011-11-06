@module "EMG", ->
  class @Location
    constructor: (json) ->
      @lat = json.latitude
      @lon = json.longitude
      @name = json.name
      @odscode = json.odscode

    getLocation: ->
      return {
        'lat': @lat,
        'lon': @lon
      }

    getName: ->
      @name

    getOdsCode: ->
      @odscode
