@module "EMG", ->
  class @Location
    constructor: (json) ->
      @lat = json.latitude
      @lon = json.longitude
      @name = json.name
      @odscode = json.odscode
      @hashcode = 0

    getLocation: ->
      return {
        'lat': @lat,
        'lon': @lon
      }

    getName: ->
      @name

    getOdsCode: ->
      @odscode

    hash: ->
      # Memoize the return value! If this class gets updated,
      # make sure to call this function (minus memoizing) again!
      return @hashode if @hashcode != 0
      filter = " " + @lat + @lon + @name + @odscode
      hash = 0
      for f in filter
        hash = ((hash << 5) - hash) + f.charCodeAt()
        @hashcode = Math.abs(hash & hash) # Make it 32bit
      return @hashcode

    highlight: ->
      # TODO: Complete this call to set the CSS to highlight
      # for the relevant item in our list.
      log "TODO: Highlight me with CSS! [hash: " + this.hash() + " ]"