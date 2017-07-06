var currentIndex;
$(document).ready(function(){
  var currentUser;
  findCurrentUser();
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
      $("#submission").fadeOut(300, function() {
        incrementSubmission(previous, submissions, submissionType, hoodName);
      });
      setTimeout(function() {$("#submission").fadeIn(300)}, 300);
    });
    if (typeof nextSubmission != "undefined") {
      rightArrow.removeEventListener('click', nextSubmission)
    }
    rightArrow.addEventListener('click', nextSubmission = function(){
      $("#submission").fadeOut(300, function() {
        incrementSubmission(next, submissions, submissionType, hoodName);
      });
      setTimeout(function() {$("#submission").fadeIn(300)}, 300);
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
  if (isDeletable(artwork)) {
    var deleteButton = document.createElement("button");
    deleteButton.className = "btn btn-danger";
    deleteButton.innerHTML = "Delete";
    deleteButton.addEventListener("click", function() {
      deleteArtwork(artwork);
    });
    deleteDiv.appendChild(deleteButton);
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
  if (isDeletable(event)) {
    var deleteButton = document.createElement("button");
    deleteButton.className = "btn btn-danger";
    deleteButton.innerHTML = "Delete";
    deleteButton.addEventListener("click", function() {
      deleteEvent(event);
    });
    deleteDiv.appendChild(deleteButton);
  }
}

function formatStoryShow(story) {
  var title = document.getElementById("title");
  var author = document.getElementById("author");
  var youtubeDiv = document.getElementById("youtube");
  var description = document.getElementById("description");
  var body = document.getElementById("body");
  var createdAt = document.getElementById("created_at");
  var deleteDiv = document.getElementById("delete");

  clearDiv(youtubeDiv);
  clearDiv(deleteDiv);

  title.innerHTML = story.title;
  author.innerHTML = "By " + story.author
  if (story.youtube_link) {
    var iFrameDiv = document.createElement("div");
    iFrameDiv.className = "iframe";
    var youtubeIFrame = document.createElement("iframe");
    youtubeIFrame.src = story.youtube_link;
    iFrameDiv.appendChild(youtubeIFrame);
    youtubeDiv.appendChild(iFrameDiv);
  }
  description.innerHTML = story.description;
  body.innerHTML = story.body;
  createdAt.innerHTML = story.formatted_create_time;
  if (isDeletable(story)) {
    var deleteButton = document.createElement("button");
    deleteButton.className = "btn btn-danger";
    deleteButton.innerHTML = "Delete";
    deleteButton.addEventListener("click", function() {
      deleteStory(story);
    });
    deleteDiv.appendChild(deleteButton);
  }
}

function findCurrentUser() {
  $.get("/api/v1/users/").then(function(response) {
    currentUser = response;
  });
};

function isDeletable(submission) {
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

function deleteArtwork(artwork) {
  $.ajax({
    url: "/api/v1/artworks/" + artwork.id,
    type: 'DELETE',
    success: function() {
      window.location("/users/") + currentUser.id
    }
  });
};

function deleteEvent(event) {
  $.ajax({
    url: "/api/v1/events/" + event.id,
    type: 'DELETE',
    success: function() {
      window.location("/users/") + currentUser.id
    }
  });
};

function deleteStory(story) {
  $.ajax({
    url: "/api/v1/stories/" + story.id,
    type: 'DELETE',
    success: function() {
      window.location.href = "/users/" + currentUser.id
    }
  });
};
