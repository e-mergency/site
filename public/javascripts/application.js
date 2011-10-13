// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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
    var newGmapImage = "http://maps.googleapis.com/maps/api/staticmap?center=SW61SH,London&zoom=14&size=" + mapCanvas.width() + "x500&maptype=roadmap&sensor=false";
    mapCanvas.find('#gmapStatic').attr('src', newGmapImage).width(mapCanvas.width());
}