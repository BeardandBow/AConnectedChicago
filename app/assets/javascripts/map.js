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
      if (hoods.selectedIndex !== 0) {
        showNeighborhood(hoods);
      }
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
      if (e.target !== undefined) {
        var hoodName = e.target.options[e.target.selectedIndex].value
      } else {
        var hoodName = e.options[e.selectedIndex].value
      }
      $.get("api/v1/neighborhoods/" + hoodName, function(response){
        if (response.events.length !== 0) {
          response.events.forEach(function(event) {
            var marker = handler.addMarker({
              "lat": event.map_lat,
              "lng": event.map_long,
              "visible": false,
              "picture": {
                "height": 32,
                "width": 32
              },
              "infowindow": '<a href="/events/"' + event.id + '>' + event.title + '</a>'
            });
            marker.type = event.pkey;
            markers.push(marker);
          });
        }
        if (response.stories.length !== 0) {
          response.stories.forEach(function(story){
            var marker = handler.addMarker({
              "lat": story.map_lat,
              "lng": story.map_long,
              "picture": {
                "height": 32,
                "width": 32
              },
              "infowindow": '<a href="/stories/"' + story.id + '>' + story.title + '</a>'
            });
            marker.type = story.pkey;
            markers.push(marker);
          });
        }
        if (response.artworks.length !== 0) {
          response.artworks.forEach(function(artwork){
            var marker = handler.addMarker({
              "lat": artwork.map_lat,
              "lng": artwork.map_long,
              "picture": {
                "height": 32,
                "width": 32
              },
              "infowindow": '<a href="/artworks/"' + artwork.id + '>' + artwork.title + '</a>'
            });
            marker.type = artwork.pkey;
            markers.push(marker);
          });
        }
        response.bounds.forEach(function(bound){
          markers.push(handler.addMarker({
            "lat": bound.lat,
            "lng": bound.lng,
            "picture": {
              "url": "",
              "height": 32,
              "width": 32
            }
          }));
        });
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
      });
      var buttons = document.getElementById('homepage-controls').querySelectorAll(".btn")
      buttons.forEach(function(button){
        button.addEventListener("click", function(){
          for (var i = 0; i < markers.length; i++) {
            if (markers[i].type[0] !== button.innerText[0]) {
              markers[i].serviceObject.setVisible(false)
            } else {
              markers[i].serviceObject.setVisible(true)
            }
          }
        });
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
