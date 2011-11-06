@module "EMG", ->
    class @Hospital
        constructor: (@jsonObject) ->
          @lat = @jsonObject.latitude
          @lon = @jsonObject.longitude
          @name = @jsonObject.name

        placeOnMap: (map) ->
          log "Placing #{@name} on map!"
          @marker = new google.maps.Marker(
              position: new google.maps.LatLng(@lat, @lon);
              map: map
              title: "Hello World!"
          );