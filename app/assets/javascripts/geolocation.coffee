@module "EMG", ->
  class @GeolocationHandler
    constructor: ->
      @location = {'lat': 54.851562, 'lon': -3.977137}
      @locationBeenVerified = false
    
    locateUser: ->
      if this.browserGeolocationEnabled()
        log "Geoloc enabled"
        if this.locationVerified()
          this.centerMapOnLocation()
        else
          this.setLocationUsingBrowser()
      else
        this.locateWithPostcode()
    
    centerMapOnLocation: ->
      log "Center map on location"
      c = new google.maps.LatLng(@location.lat, @location.lon)
      EMG.map.setCenter(c)
    
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
    
    setLocation: (latlon) ->
      log "Setting location:"
      log latlon
      @location = latlon
    
    verifyLocation: ->
      this.centerMapOnLocation()
      $.facebox({div : '#verify_location_container'}, 'verify_location')
      this.bindFaceboxButtons()
    
    setLocationVerified: (lv) ->
      @locationBeenVerified = lv

    browserGeolocationEnabled: ->
      return navigator.geolocation
    
    locationVerified: ->
      return @locationBeenVerified
    
    locateWithPostcode: ->
      $.facebox({div : '#postcode_form_container'}, 'postcode_form')
      this.bindFaceboxButtons()
    
    geocodePostcode: ->
      log 'Geocode Postcode'
      postcode = $('#facebox #postcode_text').val()
      log postcode
      if checkPostCode(postcode)
        geocoder = new google.maps.Geocoder();
        geocoder.geocode {'address': postcode + ', UK'}, (result, status) =>
          if status == google.maps.GeocoderStatus.OK
            log result
            latlon = result[0].geometry.location
            this.setLocation {'lat': latlon.lat(), 'lon': latlon.lng()}
            EMG.map.setZoom(16)
            this.verifyLocation()
          else
            $.facebox("Geocode was not successful for the following reason: " + status)
    
    setLocationUsingBrowser: ->
        if navigator.geolocation
            navigator.geolocation.getCurrentPosition (position) =>
              @location = {'lat': position.coords.latitude, 'lon': position.coords.longitude}
              $.facebox("Location successfully found using HTML5.")
              EMG.map.setZoom(16)
              this.verifyLocation()
            , =>
              this.handleNoGeolocation true
        else
            this.handleNoGeolocation false

    handleNoGeolocation: (errorFlag) ->
        if errorFlag
          content = "Error: The Geolocation service failed."
        else
          content = "Error: Your browser doesn't support geolocation."
        jQuery.facebox(content)
