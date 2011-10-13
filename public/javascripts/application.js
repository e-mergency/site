// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var reloadGMapTimer;
$(document).ready(function() {
    fitMapToWindow();
});

$(window).resize(fitMapToWindow);

function fitMapToWindow(){
    var mapCanvas = $('#map-canvas');
    var hospitalList = $('#hospital-list');
    var compensation = 2; //For borders
    mapCanvas.width($(window).width() - hospitalList.width() - compensation);
    
    //Set the new static map size
    clearTimeout(reloadGMapTimer);
    reloadGMapTimer = setTimeout('reloadGMap()', 1000); //$(document).oneTime(1000, reloadGMap());
}

function reloadGMap(){
    console.log("reloading Google map");
    var mapCanvas = $('#map-canvas');
    var newGmapImage = "http://maps.googleapis.com/maps/api/staticmap?center=SW61SH,London&zoom=14&size=" + mapCanvas.width() + "x500&maptype=roadmap&sensor=false";
    mapCanvas.find('#gmapStatic').attr('src', newGmapImage).width(mapCanvas.width());
}