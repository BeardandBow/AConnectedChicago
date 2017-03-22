function createMap(){
  handler = Gmaps.build('Google');
  handler.buildMap({provider: {
                                disableDefaultUI: true,
                                center: new google.maps.LatLng(41.8781136, -87.6297982),
                                zoom: 11,
                                styles: mapStyle
                              },
                    internal: {id: 'map'}
                   },
    function(){
      var hoods = document.getElementById("hood-select");
      hoods.addEventListener("change", showNeighborhood)
    }
  );
}

function showNeighborhood(e){
  var markers = []
  handler = Gmaps.build('Google');
  handler.buildMap({provider: {
                                disableDefaultUI: true,
                                styles: mapStyle
                              },
                    internal: {id: 'map'}
                   },
    function(){
      var hoodName = e.target.options[e.target.selectedIndex].value
      $.get("api/v1/neighborhoods/" + hoodName, function(response){
        console.log(response);
        response.events.forEach(function(event) {
          markers.push(handler.addMarker({
            "lat": event.map_lat,
            "lng": event.map_long,
            "picture": {
              "height": 32,
              "width": 32
            },
            "infowindow": "event!"
          }))
        });
        response.stories.forEach(function(story){
          markers.push(handler.addMarker({
            "lat": story.map_lat,
            "lng": story.map_long,
            "picture": {
              "height": 32,
              "width": 32
            },
            "infowindow": "story!"
          }))
        });
        response.artworks.forEach(function(artwork){
          markers.push(handler.addMarker({
            "lat": artwork.map_lat,
            "lng": artwork.map_long,
            "picture": {
              "height": 32,
              "width": 32
            },
            "infowindow": "artwork!"
          }))
        });
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
      })
    }
  );
};


var mapStyle = [
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#004358"
      }
    ]
  },
  {
    "featureType": "landscape",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1f8a70"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1f8a70"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1f8a70"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1f8a70"
      },
      {
        "lightness": -20
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1f8a70"
      },
      {
        "lightness": -17
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#ffffff"
      },
      {
        "visibility": "on"
      },
      {
        "weight": 0.9
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "visibility": "on"
      },
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1f8a70"
      },
      {
        "lightness": -10
      }
    ]
  },
  {},
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1f8a70"
      },
      {
        "weight": 0.7
      }
    ]
  }
]
