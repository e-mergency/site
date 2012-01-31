@module "EMG", ->
  class @LocationHandler
    constructor: () ->
      
    unhighlightAllLocations: () ->
      for location in EMG.locations
        log location
        location.removeHighlight()
    
    paintLocationToSidebar: (location) ->
      log location
      name = location.getName()
      $("ul#hospital_list").append("<li id='" + location.hashcode + "'>" + name + "</li>")

    # Repaints both the sidebar using the list that we have
    repaintLocationsSidebar: () ->
      $("ul#hospital_list").empty()
      for location in EMG.locations
        this.paintLocationToSidebar(location)
