# This is how we require other JS deps!
//= require rails
//= require plugins

@reloadGMapTimer = undefined

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

$(document).ready ->
  fitMapToWindow()
  $(window).resize fitMapToWindow
