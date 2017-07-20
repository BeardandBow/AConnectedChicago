var markers = [];
var openedMarker;
var kmlFile = "https://raw.githubusercontent.com/BeardandBow/AConnectedChicago/master/app/assets/Neighborhoods.kml";

function createMap() {
  document.getElementById("org-select").selectedIndex = 0;
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
  function() {
    handler.addKml({url: kmlFile}, {preserveViewport: true, clickable: false});
    var xCenter = window.innerWidth * 0.15 / 2;
    handler.map.serviceObject.panBy(xCenter, 0);
    var hoods = document.getElementById("hood-select");
    var orgs = document.getElementById("org-select");
    var infoBackdrop = document.getElementById("info-backdrop");
    hoods.addEventListener("change", showNeighborhood);
    orgs.addEventListener("change", orgShow);
    infoBackdrop.addEventListener("click", function(e) {
      e.stopPropagation();
    })
    google.maps.event.addListener(handler.getMap(), 'click', function(e) {
      showNeighborhood(null, e.latLng)
    });
    if (hoods.selectedIndex > 1) {
      showNeighborhood(hoods);
    }
  });
}

function orgShow(e) {
  resetInfoWindow();
  $.get("api/v1/organizations", function(response) {
    if (response.length !== 0) {
      response.forEach(function(org) {
        document.getElementById("org-listings").appendChild(formatOrganization(org));
      })
    }
  }).done(function() {
    $("#instructions").hide()
    $("#artwork-listings").hide()
    $("#event-listings").hide()
    $("#peace-circle-listings").hide()
    $("#story-listings").hide()
    $("#org-listings").show()
    if (e.target.selectedIndex > 1) {
      var orgType = e.target.options[e.target.selectedIndex].value.toLowerCase().replace(/\s+/g, '-');
      var listings = document.getElementById('org-listings').children;
      for (var i = 0; i < listings.length; i++) {
        if (listings[i].classList.contains(orgType)) {
          $("#org-listings").find(listings[i]).show()
        } else {
          $("#org-listings").find(listings[i]).hide()
        }
      }
    }
  })
}

function showNeighborhood(e, latLong = false) {
  markers = [];
  resetInfoWindow();
  document.getElementById("org-select").selectedIndex = 0;
  document.getElementById("org-select").removeEventListener("change", orgShow);
  var handler = Gmaps.build('Google');
  handler.buildMap({ provider: { disableDefaultUI: true,
                                 scrollwheel: false,
                                 disableDoubleClickZoom: true,
                                 styles: hoodStyle
                               },
                     internal: {id: 'map'}
                   },
    function() {
      handler.addKml({url: kmlFile}, {preserveViewport: true, clickable: false});
      if (e) {
        if (e.target !== undefined) {
          var hoodName = e.target.options[e.target.selectedIndex].value;
        } else {
          var hoodName = e.options[e.selectedIndex].value;
        }
      }
      google.maps.event.addListener(handler.getMap(), 'click', function(e) {
        showNeighborhood(null, e.latLng)
      });
      if (hoodName === "All Neighborhoods") {
        createMap();
        $("#instructions").show();
        $("#artwork-listings").hide();
        $("#event-listings").hide();
        $("#peace-circle-listings").hide();
        $("#story-listings").hide();
        $("#org-listings").hide();
      } else if (latLong) {
        $.ajax({
          url: "/api/v1/neighborhoods/find-neighborhood",
          data: {lat: latLong.lat(), lng: latLong.lng()},
          success: function(response) {
            document.getElementById("hood-select").value = response.name;
            buildMapWithMarkers(response, handler);
            setMapListeners();
          },
          error: function(response){
            console.log(response.statusText);
            var hoods = document.getElementById("hood-select");
            if (hoods.selectedIndex > 1) {
              showNeighborhood(hoods);
            } else {
              createMap()
            }
          }
        })
      } else {
        $.get("api/v1/neighborhoods/" + hoodName, function(response) {
          buildMapWithMarkers(response, handler)
          setMapListeners();
        }).done(function(){
          if (window.innerWidth < 450) {
            markers.forEach(function(marker){
              marker.serviceObject.setVisible(false);
            })
          }
        })
      }
    }
  )
};

function buildMapWithMarkers(response, handler) {
  buildMapArtworks(response, handler);
  buildMapEvents(response, handler);
  buildMapStories(response, handler);
  buildMapOrganizations(response, handler);
  buildNeighborhoodBounds(response, handler);
  setUpMap(handler);
  buildOrgListings();
}

function setMapListeners() {
  setSubmissionButtonListener();
  setAllButtonListener();
  setArtworkListingListener();
  setEventListingListener();
  setPeaceCircleListingListener();
  setStoryListingListener();
}

function buildMapArtworks(response, handler) {
  if (response.artworks.length !== 0) {
    response.artworks.forEach(function(artwork) {
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
        google.maps.event.addListener(marker.serviceObject, 'mouseover', function(e) {
          marker.serviceObject.infowindow.open(handler.map, marker.serviceObject)
          if (openedMarker && openedMarker !== marker) {
            openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
          }
          openedMarker = marker
        })
      }
    });
  } else {
    var none = document.createElement("h4");
    none.innerHTML = "There is no artwork to show for this neighborhood.";
    none.className = "none";
    document.getElementById("artwork-listings").appendChild(none);
  }
}

function setArtworkListingListener() {
  var artworkButton = document.getElementById("btn-artwork")
  artworkButton.addEventListener("click", function() {
    $("#artwork-listings")
    $("#instructions").hide()
    $("#artwork-listings").show()
    $("#event-listings").hide()
    $("#peace-circle-listings").hide()
    $("#story-listings").hide()
    $("#org-listings").hide()
    document.getElementById("org-select").selectedIndex = 0
    if (window.innerWidth > 450) {
      var listings = document.getElementById('artwork-listings').childNodes;
      listings.forEach(function(listing) {
        listing.addEventListener("mouseover", function() {
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
        listing.addEventListener("mouseout", function() {
          for (var i = 0; i < markers.length; i++) {
            if (markers[i].key && markers[i].key[0] === "A" && markers[i].id === parseInt(listing.id)) {
              markers[i].serviceObject.infowindow.close(markers[i].serviceObject.map, markers[i].serviceObject);
            }
          }
        });
      });
    }
  });
}

function buildMapEvents(response, handler) {
  if (response.events.length !== 0) {
    response.events.forEach(function(event) {
      if (event.status === "approved") {
        var infowindow = new google.maps.InfoWindow({
          content: '<h3>' + event.title.link("/events/" + event.id) + '</h3>' +
                   '<p>' + event.formatted_date_time + '</p>' +
                   '<p>' + event.type + '</p>' +
                   '<p>' + stringTruncate(event.description, 50) + '</p>'
        });
        document.getElementById("event-listings").appendChild(formatEvent(event));
        var marker = handler.addMarker(determineEventType(event));
        marker.key = event.pkey;
        marker.id = event.id;
        marker.type = event.type;
        marker.serviceObject.set('infowindow', infowindow)
        markers.push(marker);
        google.maps.event.addListener(marker.serviceObject, 'mouseover', function(e) {
          marker.serviceObject.infowindow.open(handler.map, marker.serviceObject)
          if (openedMarker && openedMarker !== marker) {
            openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
          }
          openedMarker = marker
        })
      }
    });
    response.events.forEach(function(event) {
      if (event.status === "approved" && event.type === "Peace Circle") {
        document.getElementById("peace-circle-listings").appendChild(formatEvent(event));
      }
    });
  } else {
    var none = document.createElement("h4");
    none.innerHTML = "There are no events to show for this neighborhood.";
    none.className = "none";
    document.getElementById("event-listings").appendChild(none);
  }
}

function setEventListingListener() {
  var eventButton = document.getElementById("btn-events")
  eventButton.addEventListener("click", function() {
    $("#instructions").hide()
    $("#artwork-listings").hide()
    $("#event-listings").show()
    $("#peace-circle-listings").hide()
    $("#story-listings").hide()
    $("#org-listings").hide()
    document.getElementById("org-select").selectedIndex = 0
    if (window.innerWidth > 450) {
      var listings = document.getElementById('event-listings').childNodes;
      listings.forEach(function(listing) {
        listing.addEventListener("mouseover", function() {
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
        listing.addEventListener("mouseout", function() {
          for (var i = 0; i < markers.length; i++) {
            if (markers[i].key && markers[i].key[0] === "E" && markers[i].id === parseInt(listing.id)) {
              markers[i].serviceObject.infowindow.close(markers[i].serviceObject.map, markers[i].serviceObject);
            }
          }
        });
      });
    }
  });
}

function setPeaceCircleListingListener() {
  var peaceButton = document.getElementById("btn-peace-circles")
  peaceButton.addEventListener("click", function() {
    $("#instructions").hide()
    $("#artwork-listings").hide()
    $("#event-listings").hide()
    $("#peace-circle-listings").show()
    $("#story-listings").hide()
    $("#org-listings").hide()
    document.getElementById("org-select").selectedIndex = 0
    if (window.innerWidth > 450) {
      var listings = document.getElementById('peace-circle-listings').childNodes;
      listings.forEach(function(listing) {
        listing.addEventListener("mouseover", function() {
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
        listing.addEventListener("mouseout", function() {
          for (var i = 0; i < markers.length; i++) {
            if (markers[i].key && markers[i].key[0] === "E" && markers[i].id === parseInt(listing.id)) {
              markers[i].serviceObject.infowindow.close(markers[i].serviceObject.map, markers[i].serviceObject);
            }
          }
        });
      });
    }
  });
}

function buildMapStories(response, handler) {
  if (response.stories.length !== 0) {
    response.stories.forEach(function(story) {
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
            "url": "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|b9600e"
          }
        });
        marker.key = story.pkey;
        marker.id = story.id;
        marker.serviceObject.set('infowindow', infowindow);
        markers.push(marker);
        google.maps.event.addListener(marker.serviceObject, 'mouseover', function(e) {
          marker.serviceObject.infowindow.open(handler.map, marker.serviceObject)
          if (openedMarker && openedMarker !== marker) {
            openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
          }
          openedMarker = marker
        })
      }
    });
  } else {
    var none = document.createElement("h4");
    none.innerHTML = "There are no stories to show for this neighborhood.";
    none.className = "none";
    document.getElementById("story-listings").appendChild(none);
  }
}

function setStoryListingListener() {
  var storyButton = document.getElementById("btn-stories")
  storyButton.addEventListener("click", function() {
    $("#instructions").hide()
    $("#artwork-listings").hide()
    $("#event-listings").hide()
    $("#peace-circle-listings").hide()
    $("#story-listings").show()
    $("#org-listings").hide()
    document.getElementById("org-select").selectedIndex = 0
    if (window.innerWidth > 450) {
      var listings = document.getElementById('story-listings').childNodes;
      listings.forEach(function(listing) {
        listing.addEventListener("mouseover", function() {
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
        listing.addEventListener("mouseout", function() {
          for (var i = 0; i < markers.length; i++) {
            if (markers[i].key && markers[i].key[0] === 'S' && markers[i].id === parseInt(listing.id)) {
              markers[i].serviceObject.infowindow.close(markers[i].serviceObject.map, markers[i].serviceObject)
            }
          }
        })
      })
    }
  })
}

function setSubmissionButtonListener() {
  var buttons = document.getElementById('homepage-controls').querySelectorAll(".btn")
  buttons.forEach(function(button) {
    button.addEventListener("click", function() {
      if (window.innerWidth > 450) {
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
      }
    });
  });
}

function buildMapOrganizations(response, handler) {
  if (response.locations.length !== 0) {
    response.locations.forEach(function(location) {
      var infowindow = new google.maps.InfoWindow({
        content: '<h3>' + location.organization.name + '</h3>' +
                  '<p>' + location.organization.type + '</p>' +
                  '<p>' + location.address + '</p>' +
                  '<p>' + stringTruncate(location.organization.description, 50) + '</p>'
      });
      document.getElementById("org-listings").appendChild(formatOrganizationForNeighborhood(location));
      var marker = handler.addMarker({
        "lat": location.map_lat,
        "lng": location.map_long,
        "picture": {
          "height": 32,
          "width": 21,
          "url": "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|933b3b"
        }
      });
      marker.key = "Org";
      if (location.organization.type !== undefined) {
        marker.type = location.organization.type.toLowerCase().replace(/\s+/g, '-')
      }
      marker.id = location.organization.id;
      marker.serviceObject.set('infowindow', infowindow)
      markers.push(marker);
      google.maps.event.addListener(marker.serviceObject, 'mouseover', function(e) {
        marker.serviceObject.infowindow.open(handler.map, marker.serviceObject)
        if (openedMarker && openedMarker !== marker) {
          openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
        }
        openedMarker = marker;
      })
    });
  }
}

function buildOrgListings() {
  var org_types = document.getElementById("org-select");
  org_types.addEventListener("change", function(e) {
    for (var i = 0; i < markers.length; i++) {
      if (e.target.selectedIndex > 1) {
        if (markers[i].key === "Org" && markers[i].type === e.target.selectedOptions[0].innerText.toLowerCase().replace(/\s+/g, '-')) {
          markers[i].serviceObject.setVisible(true)
          $("#instructions").hide()
          $("#artwork-listings").hide()
          $("#event-listings").hide()
          $("#peace-circle-listings").hide()
          $("#story-listings").hide()
          $("#org-listings").show()
          if (window.innerWidth > 450) {
            var listings = document.getElementById('org-listings').getElementsByClassName('listing');
            for (var ii = 0; ii < listings.length; ii++) {
              var listing = listings[ii]
              listing.addEventListener("mouseover", function(e) {
                for (var j = 0; j < markers.length; j++) {
                  if (markers[j].key && markers[j].key === "Org" && markers[j].id === parseInt(e.currentTarget.id)) {
                    markers[j].serviceObject.infowindow.open(markers[j].serviceObject.map, markers[j].serviceObject);
                    if (openedMarker) {
                      openedMarker.serviceObject.infowindow.close(handler.map, openedMarker.serviceObject)
                    }
                    openedMarker = null
                  }
                }
              })
            }
          }
        } else {
          markers[i].serviceObject.setVisible(false)
        }
      }
    }
  });
}

function setAllButtonListener() {
  var allButton = document.getElementById("btn-all")
  allButton.addEventListener("click", function() {
    $("#instructions").show()
    $("#artwork-listings").hide()
    $("#event-listings").hide()
    $("#peace-circle-listings").hide()
    $("#story-listings").hide()
    $("#org-listings").hide()
    document.getElementById("org-select").selectedIndex = 0
  });
}

function buildNeighborhoodBounds(response, handler) {
  response.bounds.forEach(function(bound) {
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
}

function setUpMap(handler) {
  handler.resetBounds();
  handler.bounds.extendWith(markers);
  handler.fitMapToBounds();
  handler.getMap().setZoom(14);
  if (window.innerWidth > 600) {
    var xCenter = window.innerWidth * 0.3 / 2
    handler.map.serviceObject.panBy(xCenter, 0);
  }
};

function stringTruncate(string, length) {
  if (string.length > length) {
    return string.substr(0, string.lastIndexOf(' ', length)) + " ...";
  } else {
    return string;
  }
}

function determineEventType(event) {
  if (event.type !== "Peace Circle") {
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
  var heading = document.createElement("a");
  var headingText = document.createElement("h3");
  var type = document.createElement("p");
  var link = document.createAttribute("href");
  var description = document.createElement("p");

  heading.appendChild(headingText);
  headingText.innerHTML = organization.name;
  heading.href = organization.website;
  heading.target = "_blank";
  type.innerHTML = organization.type;
  description.innerHTML = stringTruncate(organization.description, 500);
  listing.appendChild(heading);
  if (organization.type !== undefined) {
    listing.appendChild(type);
    listing.className = "listing " + organization.type.toLowerCase().replace(/\s+/g, '-');
  }
  if (organization.locations.length !== 0) {
    organization.locations.forEach(function(location) {
      var address = document.createElement("p");
      address.innerHTML = location.address;
      listing.appendChild(address);
    })
  }
  listing.appendChild(description);
  listing.id = organization.id;
  return listing;
}

function formatOrganizationForNeighborhood(location) {
  var listing = document.createElement("div");
  var heading = document.createElement("a");
  var headingText = document.createElement("h3");
  var type = document.createElement("p");
  var address = document.createElement("p");
  var description = document.createElement("p");

  headingText.innerHTML = location.organization.name;
  heading.appendChild(headingText);
  heading.href = location.organization.website;
  heading.target = "_blank";
  type.innerHTML = location.organization.type;
  address.innerHTML = location.address;
  description.innerHTML = stringTruncate(location.organization.description, 500);
  listing.appendChild(heading);
  listing.appendChild(type);
  listing.appendChild(address);
  listing.appendChild(description);
  listing.className = "listing " + location.organization.type.toLowerCase().replace(/\s+/g, '-');
  listing.id = location.organization.id;
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
  if (artwork.thumb_url) {
    var image = document.createElement("img");
    image.src = artwork.thumb_url;
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
  event_type.innerHTML = event.type
  listing.appendChild(heading);
  if (event.thumb_url) {
    var image = document.createElement("img");
    image.src = event.thumb_url;
    listing.appendChild(image);
  }
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
  if (story.thumb_url) {
    var image = document.createElement("img");
    image.src = story.thumb_url;
    listing.appendChild(image);
  }
  listing.appendChild(author);
  listing.appendChild(description);
  listing.className = "listing";
  listing.id = story.id;
  return listing;
}

function resetInfoWindow() {
  $('#instructions').show();
  $('#artwork-listings').hide();
  $('#artwork-listings').empty();
  $('#event-listings').hide();
  $('#event-listings').empty();
  $('#peace-circle-listings').hide();
  $('#peace-circle-listings').empty();
  $('#story-listings').hide();
  $('#story-listings').empty();
  $('#org-listings').hide();
  $('#org-listings').empty();
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
