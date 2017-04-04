function createMap(){
  handler = Gmaps.build('Google');
  handler.buildMap({provider: {
                                disableDefaultUI: true,
                                zoom: 11,
                                scrollwheel: false,
                                center: new google.maps.LatLng(41.8581136, -87.5297982),
                                disableDoubleClickZoom: true,
                                styles: mapStyle
                              },
                    internal: {id: 'map'}
                   },
  function(){
    handler.addKml({url: "https://gist.githubusercontent.com/zackforbing/6775365ca4bf28dd1a73ef2db22f348a/raw/ff9e60a8ff19800207edbbd4745485d670865953/Neighborhoods.kml"}, {preserveViewport: true});
    var hoods = document.getElementById("hood-select");
    if (hoods.selectedIndex > 1) {
      showNeighborhood(hoods);
    }
    hoods.addEventListener("change", showNeighborhood);
  });
}

function showNeighborhood(e){
  clearSubmissionDivs();
  var markers = []
  handler = Gmaps.build('Google');
  handler.buildMap({provider: {
                                disableDefaultUI: true,
                                scrollwheel: false,
                                disableDoubleClickZoom: true,
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
      if (hoodName === "All Neighborhoods") {
        createMap();
      } else {
        $.get("api/v1/neighborhoods/" + hoodName, function(response){
          if (response.events.length !== 0) {
            response.events.forEach(function(event) {
              document.getElementById("events").appendChild(formatEvent(event));
              if (event.status === "approved") {
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
                marker.key = event.pkey;
                marker.type = event.event_type;
                markers.push(marker);
              }
            });
          }
          if (response.stories.length !== 0) {
            response.stories.forEach(function(story){
              if (story.status === "approved") {
                var marker = handler.addMarker({
                  "lat": story.map_lat,
                  "lng": story.map_long,
                  "picture": {
                    "height": 32,
                    "width": 32
                  },
                  "infowindow": '<a href="/stories/' + story.id + '">' + story.title + '</a>'
                });
                marker.key = story.pkey;
                markers.push(marker);
              }
            });
          }
          if (response.artworks.length !== 0) {
            response.artworks.forEach(function(artwork){
              if (artwork.status === "approved") {
                var marker = handler.addMarker({
                  "lat": artwork.map_lat,
                  "lng": artwork.map_long,
                  "picture": {
                    "height": 32,
                    "width": 32
                  },
                  "infowindow": '<a href="/artworks/' + artwork.id + '">' + artwork.title + '</a>'
                });
                marker.key = artwork.pkey;
                markers.push(marker);
              }
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
              if (markers[i].key && markers[i].key[0] === button.innerText[0]) {
                markers[i].serviceObject.setVisible(true)
              } else if (button.innerText[0] === "P" && markers[i].type && markers[i].type === "Peace Circle") {
                markers[i].serviceObject.setVisible(true)
              } else {
                markers[i].serviceObject.setVisible(false)
              }
            }
          });
        })
      }
    }
  );
};

function formatEvent(event) {
var listing = document.createElement("div");
var heading = document.createElement("h3");
var dateTime = document.createElement("p");
var description = document.createElement("p");
heading.innerHTML = event.title.link("/events/" + event.id);
description.innerHTML = event.description.split(" ", 25).join(" ") + "...";
dateTime.innerHTML = event.time
listing.appendChild(heading);
listing.appendChild(dateTime);
listing.appendChild(description);
return listing;
}

function clearSubmissionDivs() {
  $('#artwork').empty();
  $('#events').empty();
  $('#peace-circles').empty();
  $('#stories').empty();
}

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
