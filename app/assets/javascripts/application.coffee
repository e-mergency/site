# This is how we require other JS deps!

#= require rails
#= require log_plugin
#= require dotimeout_plugin
#= require jspostcode
#= require facebox

#= require _helpers
#= require geolocation
#= require location
#= require location_handler
#= require location_placer

setupFacebox = ->
  $.facebox.settings.closeImage = '/assets/facebox/closelabel.png'
  $.facebox.settings.loadingImage = '/assets/facebox/loading.gif'
  $('a[rel*=facebox]').facebox()
  $(document).bind('loading.facebox', ->
    e = $('#facebox .content').first()
    e.removeAttr('class')
    e.addClass('content')
  )

loadHospitals = (map = EMG.map, sort = "none") ->
  for l in EMG.locations
    l.remove()
  EMG.locations = []
  return getHospitalJSON(parseHospitalJSON, map, sort)

getHospitalJSON = (afterFunction, map = EMG.map, sort) ->
  $.ajax '/hospitals/json_list/sort/' + sort,
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      return false
    success: (data, textStatus, jqXHR) ->
      afterFunction(data, map)
      return true

parseHospitalJSON = (hospitalJsonObjects, map = EMG.map) ->
  placer = new EMG.LocationPlacer()
  for hospitalJsonObject in hospitalJsonObjects
    hospital = new EMG.Location(hospitalJsonObject)
    placer.placeOnMap(map, hospital)

resizeContentToWindow = ->
  $('#main').height($(window).height() - 80)

bindFilterButtons = ->
  $('#hospital_filter_button_distance').bind 'click', (event) =>
    loadHospitals(EMG.map)
  $('#hospital_filter_button_agony').bind 'click', (event) =>
    loadHospitals(EMG.map, 'agony')
  $('#hospital_filter_button_wait').bind 'click', (event) =>
    loadHospitals(EMG.map, 'wait')

$(document).ready ->  
  resizeContentToWindow()
  $(window).resize resizeContentToWindow
  
  setupFacebox()
  
  bindFilterButtons();

  # Temp map stuff
  myOptions =
    zoom: 6
    mapTypeId: google.maps.MapTypeId.ROADMAP
  EMG.map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  EMG.map.setCenter (new google.maps.LatLng(54.851562,-3.977137))
  
  g = new EMG.GeolocationHandler()
  g.locateUser()

  if !loadHospitals(@map)
    log "Failed to load hospital data"
