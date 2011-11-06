@module "EMG", ->
  class @LocationHandler
    constructor: ->

    highlight: (lat, lon) ->
      for location in EMG.locations
        ll = location.getLocation()
        if lat == ll.lat and lon == ll.lon
          location.highlight()
          # Found our location; return true to caller
          return true
      # Not been able to find this marker in our locations array!
      # Make sure we return false to our caller
      return false
