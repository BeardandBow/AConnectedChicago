function createMap(){
  handler = Gmaps.build('Google');
  handler.buildMap({provider: {
                                disableDefaultUI: true,
                                center: new google.maps.LatLng(41.8781136, -87.6297982),
                                minZoom: 10,
                                scrollwheel: false,
                                disableDoubleClickZoom: true,
                                styles: mapStyle
                              },
                    internal: {id: 'map'}
                   },
    function(){
      handler.addKml({url: "https://gist.githubusercontent.com/zackforbing/6775365ca4bf28dd1a73ef2db22f348a/raw/ff9e60a8ff19800207edbbd4745485d670865953/Neighborhoods.kml"});

      var hoods = document.getElementById("hood-select");
      hoods.addEventListener("change", showNeighborhood);
    }
  );
}

function showNeighborhood(e){
  var markers = []
  handler = Gmaps.build('Google');
  handler.buildMap({provider: {
                                disableDefaultUI: true,
                                scrollwheel: false,
                                disableDoubleClickZoom: false,
                                styles: mapStyle
                              },
                    internal: {id: 'map'}
                   },
    function(){
      handler.addKml({url: "https://gist.githubusercontent.com/zackforbing/6775365ca4bf28dd1a73ef2db22f348a/raw/ff9e60a8ff19800207edbbd4745485d670865953/Neighborhoods.kml"});
      var hoodName = e.target.options[e.target.selectedIndex].value
      $.get("api/v1/neighborhoods/" + hoodName, function(response){
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
        response.bounds.forEach(function(bound){
          markers.push(handler.addMarker({
            "lat": bound.lat,
            "lng": bound.lng,
            "picture": {
              "url": "",
              "height": 32,
              "width": 32
            }
          }))
        })
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
        "color": "#3E4660"
      }
    ]
  },
  {
    "featureType": "landscape",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#933B3B"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#933B3B"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4C2326"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4C2326"
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
        "color": "#4C2326"
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
        "color": "#933B3B"
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
        "color": "#933B3B"
      },
      {
        "weight": 0.7
      }
    ]
  }
]
