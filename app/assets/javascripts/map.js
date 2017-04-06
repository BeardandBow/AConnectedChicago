function createMap(){
  var handler = Gmaps.build('Google');
  handler.buildMap({provider: {
                                disableDefaultUI: true,
                                zoom: 11,
                                scrollwheel: false,
                                center: new google.maps.LatLng(41.8581136, -87.6297982),
                                disableDoubleClickZoom: true,
                                styles: mapStyle
                              },
                    internal: {id: 'map'}
                   },
  function(){
    handler.addKml({url: "https://gist.githubusercontent.com/zackforbing/6775365ca4bf28dd1a73ef2db22f348a/raw/6981eff719cd212aa72a2e962dcef74e9ea5a0ab/Neighborhoods.kml"}, {preserveViewport: true});
    var xCenter = window.innerWidth * 0.15 / 2
    handler.map.serviceObject.panBy(xCenter, 0);
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
  var handler = Gmaps.build('Google');
  handler.buildMap({provider: {
                                disableDefaultUI: true,
                                scrollwheel: false,
                                disableDoubleClickZoom: true,
                                styles: hoodStyle
                              },
                    internal: {id: 'map'}
                   },
    function(){
      handler.addKml({url: "https://gist.githubusercontent.com/zackforbing/6775365ca4bf28dd1a73ef2db22f348a/raw/6981eff719cd212aa72a2e962dcef74e9ea5a0ab/Neighborhoods.kml"}, {preserveViewport: true});
      if (e.target !== undefined) {
        var hoodName = e.target.options[e.target.selectedIndex].value
      } else {
        var hoodName = e.options[e.selectedIndex].value
      }
      if (hoodName === "All Neighborhoods") {
        createMap();
        $("#about-us").show();
        $("#artwork-listings").hide()
        $("#event-listings").hide()
        $("#peace-circle-listings").hide()
        $("#story-listings").hide()
      } else {
        $.get("api/v1/neighborhoods/" + hoodName, function(response){
          if (response.events.length !== 0) {
            response.events.forEach(function(event) {
              if (event.status === "approved") {
                document.getElementById("event-listings").appendChild(formatEvent(event));
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
            response.events.forEach(function(event) {
              if (event.status === "approved" && event.event_type === "Peace Circle") {
                document.getElementById("peace-circle-listings").appendChild(formatEvent(event));
              }
            });
          }
          if (response.stories.length !== 0) {
            response.stories.forEach(function(story){
              if (story.status === "approved") {
                document.getElementById("story-listings").appendChild(formatStory(story));
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
                document.getElementById("artwork-listings").appendChild(formatArtwork(artwork));
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
            var marker = handler.addMarker({
              "lat": bound.lat,
              "lng": bound.lng,
              "picture": {
                "url": "",
                "height": 32,
                "width": 32
              }
            });
            markers.push(marker);
          });
          handler.bounds.extendWith(markers);
          handler.fitMapToBounds();
          handler.getMap().setZoom(14);
          var xCenter = window.innerWidth * 0.3 / 2
          handler.map.serviceObject.panBy(xCenter, 0);

        });
        var buttons = document.getElementById('homepage-controls').querySelectorAll(".btn")
        buttons.forEach(function(button){
          button.addEventListener("click", function(){
            for (var i = 0; i < markers.length; i++) {
              if (markers[i].key && markers[i].key.substring(0, 2).toLowerCase() === button.innerText.substring(0, 2).toLowerCase()) {
                markers[i].serviceObject.setVisible(true)
              } else if (button.innerText[0] === "P" && markers[i].type && markers[i].type === "Peace Circle") {
                markers[i].serviceObject.setVisible(true)
              } else if (button.innerText === "All") {
                markers[i].serviceObject.setVisible(true)
              } else {
                markers[i].serviceObject.setVisible(false)
              }
            }
          });
        });
        var allButton = document.getElementById("btn-all")
        allButton.addEventListener("click", function(){
          console.log("artwork")
          $("#about-us").show()
          $("#artwork-listings").hide()
          $("#event-listings").hide()
          $("#peace-circle-listings").hide()
          $("#story-listings").hide()
        });
        var artworkButton = document.getElementById("btn-artwork")
        artworkButton.addEventListener("click", function(){
          console.log("artwork")
          $("#about-us").hide()
          $("#artwork-listings").show()
          $("#event-listings").hide()
          $("#peace-circle-listings").hide()
          $("#story-listings").hide()
        });
        var eventButton = document.getElementById("btn-events")
        eventButton.addEventListener("click", function(){
          console.log("event")
          $("#about-us").hide()
          $("#artwork-listings").hide()
          $("#event-listings").show()
          $("#peace-circle-listings").hide()
          $("#story-listings").hide()
        });
        var peaceButton = document.getElementById("btn-peace-circles")
        peaceButton.addEventListener("click", function(){
          console.log("peace")
          $("#about-us").hide()
          $("#artwork-listings").hide()
          $("#event-listings").hide()
          $("#peace-circle-listings").show()
          $("#story-listings").hide()
        });
        var storyButton = document.getElementById("btn-stories")
        storyButton.addEventListener("click", function(){
          console.log("story")
          $("#about-us").hide()
          $("#artwork-listings").hide()
          $("#event-listings").hide()
          $("#peace-circle-listings").hide()
          $("#story-listings").show()
        });
      }
    }
  );
};



function formatArtwork(artwork) {
var listing = document.createElement("div");
var heading = document.createElement("h3");
var artist = document.createElement("p");
var description = document.createElement("p");
heading.innerHTML = artwork.title.link("/artworks/" + artwork.id);
description.innerHTML = artwork.description.split(" ", 25).join(" ") + "...";
artist.innerHTML = "by " + artwork.artist
listing.appendChild(heading);
if (artwork.image.thumb.url) {
  var image = document.createElement("img");
  image.src = artwork.image.thumb.url;
  listing.appendChild(image);
}
listing.appendChild(artist);
listing.appendChild(description);
listing.className = "listing";
listing.id = artwork.pkey;
return listing;
}

function formatEvent(event) {
var listing = document.createElement("div");
var heading = document.createElement("h3");
var dateTime = document.createElement("p");
var description = document.createElement("p");
var event_type = document.createElement("p");
heading.innerHTML = event.title.link("/events/" + event.id);
description.innerHTML = event.description.split(" ", 25).join(" ") + "...";
dateTime.innerHTML = event.formatted_date_time
event_type.innerHTML = event.event_type
listing.appendChild(heading);
listing.appendChild(dateTime);
listing.appendChild(event_type);
listing.appendChild(description);
listing.className = "listing";
listing.id = event.pkey;
return listing;
}

function formatStory(story) {
  var listing = document.createElement("div");
  var heading = document.createElement("h3");
  var author = document.createElement("p");
  var description = document.createElement("p");
  heading.innerHTML = story.title.link("/stories/" + story.id);
  description.innerHTML = story.description.split(" ", 25).join(" ") + "...";
  author.innerHTML = "by " + story.author
  listing.appendChild(heading);
  if (story.image.thumb.url) {
    var image = document.createElement("img");
    image.src = story.image.thumb.url;
    listing.appendChild(image);
  }
  listing.appendChild(author);
  listing.appendChild(description);
  listing.className = "listing";
  listing.id = story.pkey;
  return listing;
}

function clearSubmissionDivs() {
  $('#artwork-listings').empty();
  $('#event-listings').empty();
  $('#peace-circle-listings').empty();
  $('#story-listings').empty();
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
                "color": "#717782"
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
                "color": "#717782"
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
                "color": "#717782"
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
                "color": "#717782"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#717782"
            }
        ]
    },
    {
        "featureType": "landscape.natural",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#717782"
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
                "color": "#717782"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#717782"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#676c75"
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
                "color": "#717782"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#717782"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#717782"
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

var hoodStyle = [
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
        "featureType": "administrative.neighborhoods",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "saturation": 36
            },
            {
                "color": "#FFFFFF"
            },
            {
                "lightness": 40
            },
            {
                "visibility": "on"
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
                "color": "#717782"
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
                "color": "#717782"
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
                "color": "#717782"
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
                "color": "#717782"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#717782"
            }
        ]
    },
    {
        "featureType": "landscape.natural",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#717782"
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
                "color": "#717782"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#717782"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "labels",
        "stylers": [
          {
              "visibility": "off"
          },
          {
              "color": "#717782"
          }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#676c75"
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
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#676c75"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#717782"
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
