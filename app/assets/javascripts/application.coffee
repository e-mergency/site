# This is how we require other JS deps!

#= require rails
#= require log_plugin
#= require facebox

#= require _helpers
#= require geolocation
#= require location
#= require location_handler
#= require location_placer

@map = undefined

setupFacebox = ->
  $.facebox.settings.closeImage = '/assets/facebox/closelabel.png'
  $.facebox.settings.loadingImage = '/assets/facebox/loading.gif'
  $('a[rel*=facebox]').facebox()

loadHospitals = (map, sort = "none") ->
  for l in EMG.locations
    l.clearMarker()
    EMG.locations = []
  return getHospitalJSON(parseHospitalJSON, map, sort)

getHospitalJSON = (afterFunction, map, sort) ->
  $.ajax '/hospitals/json_list/sort/' + sort,
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      return false
    success: (data, textStatus, jqXHR) ->
      afterFunction(data, map)
      return true

parseHospitalJSON = (hospitalJsonObjects, map) ->
  placer = new EMG.LocationPlacer()
  for hospitalJsonObject in hospitalJsonObjects
    hospital = new EMG.Location(hospitalJsonObject)
    placer.placeOnMap(map, hospital)

resizeContentToWindow = ->
  $('#main').height($(window).height() - 80)

bindFilterButtons = ->
  $('#hospital_filter_button_distance').bind 'click', (event) =>
    loadHospitals(@map)
  $('#hospital_filter_button_agony').bind 'click', (event) =>
    loadHospitals(@map, 'agony')
  $('#hospital_filter_button_wait').bind 'click', (event) =>
    loadHospitals(@map, 'wait')

$(document).ready ->  
  resizeContentToWindow()
  $(window).resize resizeContentToWindow
  
  setupFacebox()
  
  bindFilterButtons();

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
