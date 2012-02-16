@module "EMG", ->
  class @GeolocationHandler
    constructor: ->
      @location = {'lat': 54.851562, 'lon': -3.977137, 'postcode': ''}
    
    getLocation: ->
      return @location
    
    #Initiated process of setting the user's location
    locateUser: ->
      if this.browserGeolocationEnabled()
        this.setLocationUsingBrowser()
      else
        this.locateWithPostcode()
    
    # Centers the map on the current user's recorded location
    centerMapOnLocation: ->
      c = new google.maps.LatLng(@location.lat, @location.lon)
      EMG.map.setCenter(c)
    
    # Binds the buttons for the various forms in facebox popups relating 
    # to the geolocation
    bindFaceboxButtons: ->
      if $('#facebox #verify_location')
        $('#facebox #verify_location_button_yes').bind 'click', (event) =>
          this.setLocationVerified(true)
          $.facebox('Thank you for verifying your location.')
          $.doTimeout 1000, =>
            $(document).trigger('close.facebox')
            this.locateUser()
        
        $('#facebox #verify_location_button_no').bind 'click', (event) =>
          this.setLocationVerified(false)
          this.locateWithPostcode()
      if $('#facebox #postcode_form')
        $('#facebox #postcode_button_submit').bind 'click', (event) =>
          this.geocodePostcode()

    placeUserMarker: (location = @location) ->
      placer = new EMG.LocationPlacer()
      return placer.placeUserOnMap(EMG.map, location)

    # Sets the user's location to 'latlon'
    setLocation: (latlon) ->
      log "Setting location: ",latlon
      @location = latlon
      marker = this.placeUserMarker()

      infowindow = new google.maps.InfoWindow
        content: "<div id='verify_location'>
                    <p>This is where we think you are!</p>
                    <div class='clear'></div>
                    <div class='button negative' id='location_incorrect_button'>Not correct?</div>
                  </div>"

      $('#verify_location #location_incorrect_button').live 'click', () =>
        infowindow.setContent "<div id='postcode_form'>
                                <p>Please enter your postcode:</p>
                                <div class='clear'></div>
                                <input id='postcode_text' size='10' type='text' value='" + @location.postcode + "'>
                                <div class='button positive' id='postcode_button_submit'>Find Me!</div>
                              </div>"
        # Submit form when clicking the button
        $('#postcode_form #postcode_button_submit').live 'click', () =>
          infowindow.setMap(null)
          marker.setMap(null)
          this.geocodePostcode()
        # Submit form when hitting enter
        $('#postcode_form #postcode_text').live 'keypress', (e) =>
          if e.which == 13
            infowindow.setMap(null)
            marker.setMap(null)
            this.geocodePostcode()
            return false

      google.maps.event.addListener marker, 'click', () =>
        infowindow.open(EMG.map,marker)

      infowindow.open(EMG.map,marker)

    # Zooms in to current location and initiates prompt to get user to verify 
    # the suggested location. Opens the facebox and binds the buttons
    verifyLocation: ->
      this.centerMapOnLocation()
      EMG.map.setZoom(16)
      if !EMG.loadHospitals()
        log "Failed to load hospitals"
    
    # Set whether the location has been verified
    setLocationVerified: (lv) ->
      @locationBeenVerified = lv
    
    # Returns whether the location can be obtained from the browser
    browserGeolocationEnabled: ->
      return navigator.geolocation
    
    # Returns whether the user's location has been verified
    locationVerified: ->
      return @locationBeenVerified
    
    # Begins the process of locating the user using their postcode, opens the 
    # facebox and binds the buttons
    locateWithPostcode: ->
      $.facebox({div : '#postcode_form_container'}, 'postcode_form')
      this.bindFaceboxButtons()
    
    # Uses the postcode input textbox, asks google for a geocoded latlong.
    # If google returns one, ask the user to verify if the location is correct
    geocodePostcode: ->
      log 'Geocode Postcode'
      postcode = $('#postcode_form #postcode_text').val()
      log postcode
      if checkPostCode(postcode)
        geocoder = new google.maps.Geocoder();
        geocoder.geocode {'address': postcode + ', UK'}, (result, status) =>
          if status == google.maps.GeocoderStatus.OK
            log result
            latlon = result[0].geometry.location
            this.setLocation {'lat': latlon.lat(), 'lon': latlon.lng(), 'postcode': postcode}
            this.verifyLocation()
          else
            $.facebox("Geocode was not successful for the following reason: " + status)
    
    # Gets the user's location from the browser and sets it. Then asks the user 
    # to verify the location is correct
    setLocationUsingBrowser: ->
        if navigator.geolocation
            navigator.geolocation.getCurrentPosition (position) =>
              log "Location successfully found using HTML5.", position
              this.setLocation {'lat': position.coords.latitude, 'lon': position.coords.longitude, 'postcode': ''}
              this.verifyLocation()
            , =>
              $.facebox("Error: The Geolocation service failed.")
        else
            $.facebox("Error: Your browser doesn't support geolocation.")
        
