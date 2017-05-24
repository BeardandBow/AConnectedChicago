var kmlFile = "https://gist.githubusercontent.com/zackforbing/6775365ca4bf28dd1a73ef2db22f348a/raw/fa1163e6a81c7ad0826c4a4e6b56f4d38b728138/Neighborhoods.kml"
function createMap () {
  var handler = Gmaps.build('Google')
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
    handler.addKml({url: kmlFile}, {preserveViewport: true});
    var xCenter = window.innerWidth * 0.15 / 2;
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
  var openedMarker = null;
  var markers = [];
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
      handler.addKml({url: kmlFile}, {preserveViewport: true});
      if (e.target !== undefined) {
        var hoodName = e.target.options[e.target.selectedIndex].value;
      } else {
        var hoodName = e.options[e.selectedIndex].value;
      }
      if (hoodName === "All Neighborhoods") {
        createMap();
        $("#instructions").show();
        $("#artwork-listings").hide();
        $("#event-listings").hide();
        $("#peace-circle-listings").hide();
        $("#story-listings").hide();
      } else {
        $.get("api/v1/neighborhoods/" + hoodName, function(response){
          if (response.events.length !== 0) {
            response.events.forEach(function(event) {
              if (event.status === "approved") {
                var infowindow = new google.maps.InfoWindow({
                  content: '<h3>' + event.title.link("/events/" + event.id) + '</h3>' +
                           '<p>' + event.formatted_date_time + '</p>' +
                           '<p>' + event.type.name + '</p>' +
                           '<p>' + stringTruncate(event.description, 50) + '</p>'
                });
                document.getElementById("event-listings").appendChild(formatEvent(event));
                var marker = handler.addMarker(determineEventType(event));
                marker.key = event.pkey;
                marker.id = event.id;
                marker.type = event.type.name;
                marker.serviceObject.set('infowindow', infowindow)
                markers.push(marker);
                google.maps.event.addListener(marker.serviceObject, 'mouseover', function(e){
                  marker.serviceObject.infowindow.open(handler.map, marker.serviceObject)
                  if (openedMarker && openedMarker !== marker) {
                    openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                  }
                  openedMarker = marker
                })
              }
            });
            response.events.forEach(function(event) {
              if (event.status === "approved" && event.type.name === "Peace Circle") {
                document.getElementById("peace-circle-listings").appendChild(formatEvent(event));
              }
            });
          }
          if (response.stories.length !== 0) {
            response.stories.forEach(function(story){
              if (story.status === "approved") {
                var infowindow = new google.maps.InfoWindow({
                  content: '<h3>' + story.title.link("/stories/" + story.id) + '</h3>' +
                           '<p>' + "by " + story.author + '</p>' +
                           '<p>' + stringTruncate(story.description, 50) + '</p>'
                });
                document.getElementById("story-listings").appendChild(formatStory(story));
                var marker = handler.addMarker({
                  "lat": story.map_lat,
                  "lng": story.map_long,
                  "picture": {
                    "height": 32,
                    "width": 21,
                    "url": "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|933b3b"
                  }
                });
                marker.key = story.pkey;
                marker.id = story.id;
                marker.serviceObject.set('infowindow', infowindow);
                markers.push(marker);
                google.maps.event.addListener(marker.serviceObject, 'mouseover', function(e){
                  marker.serviceObject.infowindow.open(handler.map, marker.serviceObject)
                  if (openedMarker && openedMarker !== marker) {
                    openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                  }
                  openedMarker = marker
                })
              }
            });
          }
          if (response.artworks.length !== 0) {
            response.artworks.forEach(function(artwork){
              if (artwork.status === "approved") {
                var infowindow = new google.maps.InfoWindow({
                  content: '<h3>' + artwork.title.link("/artworks/" + artwork.id) + '</h3>' +
                            '<p>' + "by " + artwork.artist + '</p>' +
                            '<p>' + stringTruncate(artwork.description, 50) + '</p>'
                });
                document.getElementById("artwork-listings").appendChild(formatArtwork(artwork));
                var marker = handler.addMarker({
                  "lat": artwork.map_lat,
                  "lng": artwork.map_long,
                  "picture": {
                    "height": 32,
                    "width": 21,
                    "url": "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|d4b411"
                  }
                });
                marker.key = artwork.pkey;
                marker.id = artwork.id;
                marker.serviceObject.set('infowindow', infowindow)
                markers.push(marker);
                google.maps.event.addListener(marker.serviceObject, 'mouseover', function(e){
                  marker.serviceObject.infowindow.open(handler.map, marker.serviceObject)
                  if (openedMarker && openedMarker !== marker) {
                    openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                  }
                  openedMarker = marker
                })
              }
            });
          }
          if (response.locations.length !== 0) {
            response.locations.forEach(function(location){
              var infowindow = new google.maps.InfoWindow({
                content: '<h3>' + location.organization.name + '</h3>' +
                          '<p>' + "type: " + location.organization.type + '</p>' +
                          '<p>' + stringTruncate(location.organization.description, 50) + '</p>'
              });
              document.getElementById("org-listings").appendChild(formatOrganization(location.organization));
              var marker = handler.addMarker({
                "lat": location.map_lat,
                "lng": location.map_long,
                "picture": {
                  "height": 32,
                  "width": 21,
                  "url": "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|f442df"
                }
              });
              marker.key = "Org";
              marker.type = location.organization.type
              marker.id = location.organization.id;
              marker.serviceObject.set('infowindow', infowindow)
              markers.push(marker);
              google.maps.event.addListener(marker.serviceObject, 'mouseover', function(e){
                marker.serviceObject.infowindow.open(handler.map, marker.serviceObject)
                if (openedMarker && openedMarker !== marker) {
                  openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                }
                openedMarker = marker
              })
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

        var org_types = document.getElementById("org-select");

        org_types.addEventListener("change", function(e){
          for (var i = 0; i < markers.length; i++) {
            if (e.target.selectedIndex > 1) {
              if (markers[i].key === "Org" && markers[i].type === e.target.selectedOptions[0].innerText) {
                markers[i].serviceObject.setVisible(true)
                $("#instructions").hide()
                $("#artwork-listings").hide()
                $("#event-listings").hide()
                $("#peace-circle-listings").hide()
                $("#story-listings").hide()
                $("#org-listings").show()
                var listings = document.getElementById('org-listings').childNodes;
                listings.forEach(function(listing){
                  listing.addEventListener("mouseover", function(){
                    for (var i = 0; i < markers.length; i++) {
                      if (markers[i].key && markers[i].key === "Org" && markers[i].id === parseInt(listing.id)) {
                        markers[i].serviceObject.infowindow.open(markers[i].serviceObject.map, markers[i].serviceObject);
                        if (openedMarker) {
                          openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                        }
                        openedMarker = null
                      }
                    }
                  });
                  listing.addEventListener("mouseout", function(){
                    for (var i = 0; i < markers.length; i++) {
                      if (markers[i].key && markers[i].key === "Org" && markers[i].id === parseInt(listing.id)) {
                        markers[i].serviceObject.infowindow.close(markers[i].serviceObject.map, markers[i].serviceObject);
                      }
                    }
                  });
                });
              } else {
                markers[i].serviceObject.setVisible(false)
              }
            } else {
              if (markers[i].key === "Org") {
                markers[i].serviceObject.setVisible(true)
                $("#instructions").hide()
                $("#artwork-listings").hide()
                $("#event-listings").hide()
                $("#peace-circle-listings").hide()
                $("#story-listings").hide()
                $("#org-listings").show()
                var listings = document.getElementById('org-listings').childNodes;
                listings.forEach(function(listing){
                  listing.addEventListener("mouseover", function(){
                    for (var i = 0; i < markers.length; i++) {
                      if (markers[i].key && markers[i].key === "Org" && markers[i].id === parseInt(listing.id)) {
                        markers[i].serviceObject.infowindow.open(markers[i].serviceObject.map, markers[i].serviceObject);
                        if (openedMarker) {
                          openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                        }
                        openedMarker = null
                      }
                    }
                  });
                  listing.addEventListener("mouseout", function(){
                    for (var i = 0; i < markers.length; i++) {
                      if (markers[i].key && markers[i].key === "Org" && markers[i].id === parseInt(listing.id)) {
                        markers[i].serviceObject.infowindow.close(markers[i].serviceObject.map, markers[i].serviceObject);
                      }
                    }
                  });
                });
              } else {
                markers[i].serviceObject.setVisible(false)
              }
            }
          }
        })
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
          $("#instructions").show()
          $("#artwork-listings").hide()
          $("#event-listings").hide()
          $("#peace-circle-listings").hide()
          $("#story-listings").hide()
        });
        var artworkButton = document.getElementById("btn-artwork")
        artworkButton.addEventListener("click", function(){
          $("#artwork-listings")
          $("#instructions").hide()
          $("#artwork-listings").show()
          $("#event-listings").hide()
          $("#peace-circle-listings").hide()
          $("#story-listings").hide()
          var listings = document.getElementById('artwork-listings').childNodes;
          listings.forEach(function(listing){
            listing.addEventListener("mouseover", function(){
              for (var i = 0; i < markers.length; i++) {
                if (markers[i].key && markers[i].key[0] === "A" && markers[i].id === parseInt(listing.id)) {
                  markers[i].serviceObject.infowindow.open(markers[i].serviceObject.map, markers[i].serviceObject);
                  if (openedMarker) {
                    openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                  }
                  openedMarker = null
                }
              }
            });
            listing.addEventListener("mouseout", function(){
              for (var i = 0; i < markers.length; i++) {
                if (markers[i].key && markers[i].key[0] === "A" && markers[i].id === parseInt(listing.id)) {
                  markers[i].serviceObject.infowindow.close(markers[i].serviceObject.map, markers[i].serviceObject);
                }
              }
            });
          });
        });
        var eventButton = document.getElementById("btn-events")
        eventButton.addEventListener("click", function(){
          $("#instructions").hide()
          $("#artwork-listings").hide()
          $("#event-listings").show()
          $("#peace-circle-listings").hide()
          $("#story-listings").hide()
          var listings = document.getElementById('event-listings').childNodes;
          listings.forEach(function(listing){
            listing.addEventListener("mouseover", function(){
              for (var i = 0; i < markers.length; i++) {
                if (markers[i].key && markers[i].key[0] === "E" && markers[i].id === parseInt(listing.id)) {
                  markers[i].serviceObject.infowindow.open(markers[i].serviceObject.map, markers[i].serviceObject);
                  if (openedMarker) {
                    openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                  }
                  openedMarker = null
                }
              }
            });
            listing.addEventListener("mouseout", function(){
              for (var i = 0; i < markers.length; i++) {
                if (markers[i].key && markers[i].key[0] === "E" && markers[i].id === parseInt(listing.id)) {
                  markers[i].serviceObject.infowindow.close(markers[i].serviceObject.map, markers[i].serviceObject);
                }
              }
            });
          });
        });
        var peaceButton = document.getElementById("btn-peace-circles")
        peaceButton.addEventListener("click", function(){
          $("#instructions").hide()
          $("#artwork-listings").hide()
          $("#event-listings").hide()
          $("#peace-circle-listings").show()
          $("#story-listings").hide()
          var listings = document.getElementById('peace-circle-listings').childNodes;
          listings.forEach(function(listing){
            listing.addEventListener("mouseover", function(){
              for (var i = 0; i < markers.length; i++) {
                if (markers[i].key && markers[i].key[0] === "E" && markers[i].id === parseInt(listing.id)) {
                  markers[i].serviceObject.infowindow.open(markers[i].serviceObject.map, markers[i].serviceObject);
                  if (openedMarker) {
                    openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                  }
                  openedMarker = null
                }
              }
            });
            listing.addEventListener("mouseout", function(){
              for (var i = 0; i < markers.length; i++) {
                if (markers[i].key && markers[i].key[0] === "E" && markers[i].id === parseInt(listing.id)) {
                  markers[i].serviceObject.infowindow.close(markers[i].serviceObject.map, markers[i].serviceObject);
                }
              }
            });
          });
        });
        var storyButton = document.getElementById("btn-stories")
        storyButton.addEventListener("click", function(){
          $("#instructions").hide()
          $("#artwork-listings").hide()
          $("#event-listings").hide()
          $("#peace-circle-listings").hide()
          $("#story-listings").show()
          var listings = document.getElementById('story-listings').childNodes;
          listings.forEach(function(listing){
            listing.addEventListener("mouseover", function(){
              for (var i = 0; i < markers.length; i++) {
                if (markers[i].key && markers[i].key[0] === "S" && markers[i].id === parseInt(listing.id)) {
                  markers[i].serviceObject.infowindow.open(markers[i].serviceObject.map, markers[i].serviceObject);
                  if (openedMarker) {
                    openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                  }
                  openedMarker = null
                }
              }
            });
            listing.addEventListener("mouseout", function(){
              for (var i = 0; i < markers.length; i++) {
                if (markers[i].key && markers[i].key[0] === 'S' && markers[i].id === parseInt(listing.id)) {
                  markers[i].serviceObject.infowindow.close(markers[i].serviceObject.map, markers[i].serviceObject)
                }
              }
            })
          })
        })
      };
    }
  )
};

function stringTruncate(string, length) {
  if (string.length > length) {
    return string.substr(0, string.lastIndexOf(' ', length)) + " ...";
  } else {
    return string;
  }
}

function determineEventType(event) {
  if (event.type.name !== "Peace Circle") {
    return {
      "lat": event.map_lat,
      "lng": event.map_long,
      "visible": false,
      "picture": {
        "height": 32,
        "width": 21,
        "url": "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|08820e"
      }
    }
  } else {
    return {
      "lat": event.map_lat,
      "lng": event.map_long,
      "visible": false,
      "picture": {
        "height": 32,
        "width": 21,
        "url": "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|4e7eb7"
      }
    }
  }
}

function formatOrganization(organization) {
var listing = document.createElement("div");
var heading = document.createElement("h3");
var description = document.createElement("p");

heading.innerHTML = organization.name;
description.innerHTML = stringTruncate(organization.description, 50);
listing.appendChild(heading);
listing.appendChild(description);
listing.className = "listing";
listing.id = organization.id;
return listing;
}

function formatArtwork(artwork) {
var listing = document.createElement("div");
var heading = document.createElement("h3");
var artist = document.createElement("p");
var description = document.createElement("p");
heading.innerHTML = artwork.title.link("/artworks/" + artwork.id);
description.innerHTML = stringTruncate(artwork.description, 50);
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
listing.id = artwork.id;
return listing;
}

function formatEvent(event) {
var listing = document.createElement("div");
var heading = document.createElement("h3");
var dateTime = document.createElement("p");
var description = document.createElement("p");
var event_type = document.createElement("p");
heading.innerHTML = event.title.link("/events/" + event.id);
description.innerHTML = stringTruncate(event.description, 50);
dateTime.innerHTML = event.formatted_date_time
event_type.innerHTML = event.type.name
listing.appendChild(heading);
listing.appendChild(dateTime);
listing.appendChild(event_type);
listing.appendChild(description);
listing.className = "listing";
listing.id = event.id;
return listing;
}

function formatStory(story) {
  var listing = document.createElement("div");
  var heading = document.createElement("h3");
  var author = document.createElement("p");
  var description = document.createElement("p");
  heading.innerHTML = story.title.link("/stories/" + story.id);
  description.innerHTML = stringTruncate(story.description, 50);
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
  listing.id = story.id;
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
                "color": "#9ABBE2"
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
                "color": "#9ABBE2"
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
                "color": "#9ABBE2"
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
                "color": "#9ABBE2"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#9ABBE2"
            }
        ]
    },
    {
        "featureType": "landscape.natural",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#9ABBE2"
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
                "color": "#9ABBE2"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#9ABBE2"
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
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#a3c1e4"
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
                "color": "#9ABBE2"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#9ABBE2"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#9ABBE2"
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
                "color": "#9ABBE2"
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
                "color": "#9ABBE2"
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
                "color": "#9ABBE2"
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
                "color": "#9ABBE2"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#9ABBE2"
            }
        ]
    },
    {
        "featureType": "landscape.natural",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#9ABBE2"
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
                "color": "#9ABBE2"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#9ABBE2"
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
              "color": "#9ABBE2"
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
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#a3c1e4"
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
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#a3c1e4"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#9ABBE2"
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
