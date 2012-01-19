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

        # Push the provided location object onto our global
        # list for storage. Also add it to the sidebar.
        location.setMarker(marker)
        EMG.locations.push(location)
        @handler.paintLocationToSidebar(location)

        # Add a callback to call the highlight method on the
        # location object (pushed to the EMG.locations above).
        # This is how we're going to highlight the item in the
        # list.
        google.maps.event.addListener marker, 'click', () =>
          @handler.highlight(latlon.lat, latlon.lon)
