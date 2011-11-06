@module "EMG", ->
    class @LocationPlacer
      placeOnMap: (map, location) ->
        latlon = location.getLocation()
        @marker = new google.maps.Marker(
            position: new google.maps.LatLng(latlon.lat, latlon.lon);
            map: map
            title: "Hello World!"
        );