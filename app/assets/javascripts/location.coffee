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

    highlight: ->
      # TODO: Complete this call to set the CSS to highlight
      # for the relevant item in our list.
      log "TODO: It highlights!"
