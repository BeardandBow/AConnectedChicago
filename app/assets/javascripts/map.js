function createMap(){
  handler = Gmaps.build('Google');
  handler.buildMap({provider: {
                                disableDefaultUI: true,
                                center: new google.maps.LatLng(41.8781136, -87.6297982),
                                minZoom: 11,
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
              "infowindow": '<a href="/events/' + event.id + '">' + event.title + '</a>'
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
              "infowindow": '<a href="/stories/' + story.id + '">' + story.title + '</a>'
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
              "infowindow": '<a href="/artworks/' + artwork.id + '">' + artwork.title + '</a>'
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
        "featureType": "all",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "off"
            },
            {
                "saturation": "-100"
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "saturation": 36
            },
            {
                "color": "#4C2326"
            },
            {
                "lightness": 40
            },
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "visibility": "off"
            },
            {
                "color": "#4C2326"
            },
            {
                "lightness": 16
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#933B3B"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#933B3B"
            },
            {
                "lightness": 17
            },
            {
                "weight": 1.2
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#933B3B"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "landscape.natural",
        "elementType": "geometry.fill",
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
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
            {
                "visibility": "off"
            },
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#4C2326"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#933B3B"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
            {
                "color": "#3E4660"
            },
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#3E4660"
            },
            {
                "lightness": 17
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#3E4660"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#3E4660"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels.text",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    }
]
