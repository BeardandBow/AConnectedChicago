function createMap(){
  handler = Gmaps.build('Google');
  handler.buildMap({ provider: {disableDefaultUI: true}, internal: {id: 'map'}}, function(){
    markers = handler.addMarkers([
      {
        "lat": 41.8781136,
        "lng": -87.6297982,
        "picture": {
          "url": "",
          "width":  32,
          "height": 32
        },
        "infowindow": "hello!"
      }
    ]);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    handler.getMap().setZoom(11);
  });
  // var geocoder = new google.maps.Geocoder();
  //
  // var map = new google.maps.Map(document.getElementById('map'), {
  //         zoom: 12,
  //         center: {
  //           lat: 41.8781136,
  //           lng: -87.6297982
  //         }
  //       });
}
