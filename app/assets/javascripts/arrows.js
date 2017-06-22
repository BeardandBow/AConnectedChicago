var currentIndex
var currentUser = findCurrentUser();
$(document).ready(function(){
  var hoodName = document.getElementById('left-arrow').firstChild.getAttribute("data-neighborhood");
  var submissionType = document.getElementById('left-arrow').firstChild.getAttribute("data-type");
  findAllSubmissions(hoodName, submissionType);
});

function incrementSubmission (submission, submissions, submissionType, hoodName){
  currentIndex = submissions.indexOf(submission);
  console.log(currentIndex)
  buildNewShowPage(submissionType, submission);
  findAllSubmissions(hoodName, submissionType);
};

function findAllSubmissions(hoodName, submissionType) {
  $.get("/api/v1/neighborhoods/" + hoodName, function(response){
  }).done(function(response){
    var currentTitle = document.getElementById('title').innerHTML;
    var submissions = response[submissionType]
    var next, previous
    submissions.forEach(function(submission){
      if (submission.title === currentTitle) {
        currentIndex = submissions.indexOf(submission);
      }

      if (currentIndex + 1 === submissions.length) {
        next = submissions[0]
      } else {
        next = submissions[currentIndex + 1]
      }
      if (currentIndex - 1 < 0) {
        previous = submissions[submissions.length - 1]
      } else {
        previous = submissions[currentIndex - 1]
      }
    })
    var leftArrow = document.getElementById('left-arrow');
    var rightArrow = document.getElementById('right-arrow');
    if (typeof previousSubmission != "undefined") {
      leftArrow.removeEventListener('click', previousSubmission)
    }
    leftArrow.addEventListener('click', previousSubmission = function(){
      incrementSubmission(previous, submissions, submissionType, hoodName);
    });
    if (typeof nextSubmission != "undefined") {
      rightArrow.removeEventListener('click', nextSubmission)
    }
    rightArrow.addEventListener('click', nextSubmission = function(){
      incrementSubmission(next, submissions, submissionType, hoodName);
    });
  });
}

function buildNewShowPage(type, submission) {
  if (type === 'artworks') {
    formatArtworkShow(submission);
  } else if (type === 'events') {
    formatEventShow(submission);
  } else {
    formatStoryShow(submission);
  };
};

function formatArtworkShow(artwork) {
  var currentUser = findCurrentUser();
  var title = document.getElementById("title");
  var artist = document.getElementById("artist");
  var description = document.getElementById("description");
  var image = document.getElementById("image");
  var address = document.getElementById("address");
  var formattedDateTime = document.getElementById("datetime");
  var deleteDiv = document.getElementById("delete");
  clearDiv(image);
  clearDiv(deleteDiv);
  title.innerHTML = artwork.title;
  description.innerHTML = artwork.description;
  artist.innerHTML = "By " + artwork.artist;
  address.innerHTML = artwork.address;
  formattedDateTime.innerHTML = "Posted On " + artwork.formatted_create_time;
  if (artwork.image_url) {
    var imgTag = document.createElement("img");
    imgTag.src = artwork.image_url;
    imgTag.alt = "artwork image";
    image.appendChild(imgTag);
  }
  if (isDeletable(artwork, currentUser)) {
    var deleteButton = document.createElement("button")
    deleteButton.addEventListener()
  }
}

function formatEventShow(event) {
  var title = document.getElementById("title");
  var image = document.getElementById("image");
  var organization = document.getElementById("organization");
  var dateTime = document.getElementById("formatted-date-time");
  var mailTo = document.getElementById("mail-to");
  var address = document.getElementById("address");
  var eventType = document.getElementById("type");
  var description = document.getElementById("description");
  var linkDiv = document.getElementById("link");
  var deleteDiv = document.getElementById("delete");
  clearDiv(image);
  clearDiv(mailTo);
  clearDiv(linkDiv);
  clearDiv(deleteDiv);
  title.innerHTML = event.title;
  if (event.organization.website) {
    organization.innerHTML = "Hosted By ";
    var orgLink = document.createElement("a");
    orgLink.href = event.organization.website;
    orgLink.innerHTML = event.organization.name;
    organization.appendChild(orgLink);
  } else {
    organization.innerHTML = "Hosted By " + event.organization.name
  }
  dateTime.innerHTML = event.formatted_date_time;
  var mailToLink = document.createElement("a")
  mailToLink.href = "mailto:" + event.host_contact
  mailToLink.innerHTML = "Contact for more information"
  mailTo.appendChild(mailToLink)
  address.innerHTML = event.address;
  eventType.innerHTML = event.type;
  description.innerHTML = event.description;
  var linkDivLink = document.createElement("a")
  linkDivLink.href = event.link
  linkDivLink.innerHTML = "View Event Page"
  linkDiv.appendChild(linkDivLink)
  if (event.image_url) {
    var imgTag = document.createElement("img");
    imgTag.src = event.image_url;
    imgTag.alt = "event image";
    image.appendChild(imgTag);
  }
  if (isDeletable(event, currentUser)) {
    var deleteButton = document.createElement("button")
    deleteButton.addEventListener()
  }
}

// function formatStoryShow(story) {
//   var title = document.getElementById("title");
//   var author = document.createElement("p");
//   var description = document.createElement("p");
//   var image = document.createElement("img");
//   heading.innerHTML = story.title.link("/stories/" + story.id);
//   description.innerHTML = stringTruncate(story.description, 50);
//   author.innerHTML = "by " + story.author
//   listing.appendChild(heading);
//   if (story.image.thumb.url) {
//     image.src = story.image.thumb.url;
//   }
// }

function findCurrentUser() {
  $.get("/api/v1/users/", function(response) {
    return response;
  });
};

function isDeletable(submission, currentUser) {
  if (currentUser) {
    if (submission.user_id == currentUser.id) {
      return true;
    } else if (currentUser.role == "admin") {
      return true;
    } else if (currentUser.role == "community_leader" && currentUser.organizations.some(function(e) {e.name === submission.organization.name}).length > 0) {
      return true;
    } else if (currentUser.role == "community_leader" && currentUser.neighborhood_id == submission.neighborhood_id) {
      return true;
    } else {
      return false;
    }
  }
}

function clearDiv(div) {
  while(div.firstChild) {
    div.removeChild(div.firstChild);
  }
}

function deleteArtwork(artwork, currentUser) {
  $.ajax({
    url: "/api/v1/artworks/" + artwork.id,
    type: 'DELETE',
    success: function() {
      window.location("/users/") + currentUser.id
    }
  });
};
