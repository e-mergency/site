@module "EMG", ->
  class @Location
    constructor: (json) ->
      @lat = json.latitude
      @lon = json.longitude
      @name = json.name
      @odscode = json.odscode
      @hashcode = 0
      @marker = false

    getLocation: ->
      return {
        'lat': @lat,
        'lon': @lon
      }

    getName: ->
      @name

    getOdsCode: ->
      @odscode

    setMarker: (m) ->
      @marker = m
      
    setListElement: (le) ->
      @listElement = le

    clearMarker: ->
      @marker.setMap(null)

    clearListEntry: ->
      $(@listElement).remove();
    
    remove: ->
      this.clearMarker()
      this.clearListEntry()

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
