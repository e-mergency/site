# This is how we require other JS deps!

#= require rails
#= require log_plugin
#= require facebox

#= require _helpers
#= require geolocation
#= require Hospital

@map = undefined

setupFacebox = ->
  $.facebox.settings.closeImage = '/assets/facebox/closelabel.png'
  $.facebox.settings.loadingImage = '/assets/facebox/loading.gif'
  $('a[rel*=facebox]').facebox()

loadHospitals = (map) ->
  return getHospitalJSON(parseHospitalJSON, map)

getHospitalJSON = (afterFunction, map) ->
  $.ajax '/hospitals/list_all',
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      return false
    success: (data, textStatus, jqXHR) ->
      afterFunction(data, map)
      return true

parseHospitalJSON = (hospitalJsonObjects, map) ->
  for hospitalJsonObject in hospitalJsonObjects
    hospital = new EMG.Hospital(hospitalJsonObject)
    hospital.placeOnMap(map)

$(document).ready ->
  setupFacebox()

  g = new EMG.Geolocation
  g.initialize()

  # Temp map stuff
  myOptions =
    zoom: 6
    mapTypeId: google.maps.MapTypeId.ROADMAP
  @map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  @map.setCenter (new google.maps.LatLng(54.851562,-3.977137))

  if !loadHospitals(@map)
    log "Failed to load hospital data"
