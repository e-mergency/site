# This is how we require other JS deps!

#= require rails
#= require log_plugin
#= require facebox

#= require module_helper
#= require geolocation
#= require NHSLocation

@map = undefined

setupFacebox = ->
  $.facebox.settings.closeImage = '/assets/facebox/closelabel.png'
  $.facebox.settings.loadingImage = '/assets/facebox/loading.gif'
  $('a[rel*=facebox]').facebox()

getHospitalJSON = (afterFunction) ->
  $.ajax '/hospitals/list_all',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      return false
    success: (data, textStatus, jqXHR) ->
      afterFunction(data)
      return true

parseHospitalJSON = (hospitalJsonObjects) ->
  for hospitalJsonObject in hospitalJsonObjects
    hospital = new emg.NHSLocation(hospitalJsonObject)
    log hospital

$(document).ready ->
  setupFacebox()
  g = new emg.Geolocation
  g.initialize()
  
  if !getHospitalJSON(parseHospitalJSON)
    log "Failed to load hospital data"
  
  # Temp map stuff
  myOptions =
    zoom: 16
    mapTypeId: google.maps.MapTypeId.ROADMAP
  @map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  @map.setCenter (new google.maps.LatLng(54.851562,-3.977137))
  @map.setZoom(6)