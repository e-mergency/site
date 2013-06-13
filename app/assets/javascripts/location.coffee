@module "EMG", ->
  class @Location
    constructor: (json) ->
      @id = json._id
      @lat = json.location[1]
      @lon = json.location[0]
      @name = json.name
      @postcode = json.postcode
      @distance = json.distance
      @delay = json.delay
      @last_updated_at = json.last_updated_at
      @odscode = json.odscode
      @hashcode = this.hash()
      @marker = false
      @infowindow = new google.maps.InfoWindow
        content: "<h1>" + @name + "</h1>" +
                 @postcode + "</br>"  +
                 "Distance: " + @distance + " km</br></br>"  +
                 "<h2>Current waiting time: " + @delay + " min</h2>" +
                 "Updated " + @last_updated_at +
                 "</br><a href='/hospitals/" + @id + "/delays'>Last week's waiting time</a>"

    getLocation: ->
      return {
        'lat': @lat,
        'lon': @lon
      }
    
    getHashcode: ->
      return @hashcode

    getId: ->
      @id

    getName: ->
      @name

    getOdsCode: ->
      @odscode

    setMarker: (m) ->
      @marker = m
      
    setListElement: (le) ->
      @listElement = le
    
    paintToSidebar: ->
      $("ul#hospital_list").append(@listElement)

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
      @infowindow.open(EMG.map,@marker)
      @listElement.addClass("highlighted")
    
    removeHighlight: ->
      @infowindow.close()
      @listElement.removeClass("highlighted")
