@module "EMG", ->
    class @Geolocation
        initialize: ->
            this.trygeolocation()

        trygeolocation: ->
            if navigator.geolocation
                navigator.geolocation.getCurrentPosition ((position) ->
                    # pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
                    $("#geo_location_message").text("Location successfully found using HTML5.")
                    jQuery.facebox(div : '#geo_location_message')
                ), ->
                this.handleNoGeolocation true
            else
                this.handleNoGeolocation false

        handleNoGeolocation: (errorFlag) ->
            if errorFlag
                content = "Error: The Geolocation service failed."
            else
            content = "Error: Your browser doesn't support geolocation."
            $("#geo_location_message").text(content)
            jQuery.facebox(div : '#geo_location_message')
