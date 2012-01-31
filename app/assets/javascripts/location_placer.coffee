@module "EMG", ->
    class @LocationPlacer
      placeOnMap: (map, location) ->
        @handler = new EMG.LocationHandler()
        latlon = location.getLocation()

        marker = new google.maps.Marker(
            position: new google.maps.LatLng(latlon.lat, latlon.lon);
            map: map
            title: "Hello World!"
        )
        
        listElement = $("<li class='hospital_element' id='" + location.getHashcode() + "'>" + location.getName() + "</li>")
        
        location.setMarker(marker)
        location.setListElement(listElement)
        location.paintToSidebar()
        EMG.locations.push(location)

        # Add a callback to call the highlight method on the
        # location object (pushed to the EMG.locations above).
        # This is how we're going to highlight the item in the
        # list.
        google.maps.event.addListener marker, 'click', () =>
          @handler.unhighlightAllLocations()
          location.highlight()
        
        listElement.bind 'click', () =>
          @handler.unhighlightAllLocations()
          location.highlight()
