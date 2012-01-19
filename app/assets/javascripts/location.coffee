@module "EMG", ->
  class @Location
    constructor: (json) ->
      @lat = json.latitude
      @lon = json.longitude
      @name = json.name
      @odscode = json.odscode
      @hashcode = this.hash()
      @marker = false
      @infowindow = new google.maps.InfoWindow
        content: @name

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
      google.maps.event.addListener @marker, 'click', () =>
        @infowindow.open(EMG.map,@marker);
      
    setListElement: (le) ->
      @listElement = le

    clearMarker: ->
      @marker.setMap(null)

    clearListEntry: ->
      $('#' + @hascode).remove();
    
    remove: ->
      this.clearMarker()
      this.clearListEntry()

    hash: ->
      # Memoize the return value! If this class gets updated,
      # make sure to call this function (minus memoizing) again!
      return @hashcode if @hashcode != 0
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
