# This is how we require other JS deps!
#= require rails
#= require plugins

@reloadGMapTimer = undefined
@map = undefined

reloadGMap = ->
  console.log "reloading Google map"
  mapCanvas = $("#map-canvas")
  mapImage = $("gmapStatic")
  newGmapImage = "http://maps.googleapis.com/maps/api/staticmap?center=SW61SH,London&zoom=14&size=" + mapImage.width() + "x" + mapImage.height() + "&maptype=roadmap&sensor=false"
  mapImage.attr "src", newGmapImage

fitMapToWindow = ->
  mapCanvas = $("#map-canvas")
  hospitalList = $("#hospital-list")
  compensation = 2
  mapImage = $("#gmapStatic")
  mapCanvas.width $(window).width() - hospitalList.width() - compensation
  mapImage.width mapCanvas.width()
  clearTimeout reloadGMapTimer
  @reloadGMapTimer = setTimeout(reloadGMap(), 1000)

initialize = ->
  latlng =  new google.maps.LatLng(-34.397, 150.644)
  
  myOptions =
    zoom: 16
    mapTypeId: google.maps.MapTypeId.ROADMAP
    
  @map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

trygeolocation = ->
  if navigator.geolocation
      navigator.geolocation.getCurrentPosition ((position) ->
        pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
        infowindow = new google.maps.InfoWindow(
          map: map
          position: pos
          content: "Location found using HTML5."
        )
        @map.setCenter pos
      ), ->
        handleNoGeolocation true
    else
      handleNoGeolocation false

$(document).ready ->
    initialize()
    trygeolocation()
  # fitMapToWindow()
  # $(window).resize fitMapToWindow
