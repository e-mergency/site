@module "emg", ->
    class @NHSLocation
        constructor: (@jsonObject) ->
          @lat = @jsonObject.latitude
          @long = @jsonObject.longitude
          @name = @jsonObject.name