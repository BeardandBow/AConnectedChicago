var currentIndex
$(document).ready(function(){
  var hoodName = document.getElementById('left-arrow').firstChild.getAttribute("data-neighborhood");
  var submissionType = document.getElementById('left-arrow').firstChild.getAttribute("data-type");
  var currentUser = findCurrentUser();
  findAllSubmissions(hoodName, submissionType);
});

function showPrevious (previous, submissions, submissionType, hoodName){
  currentIndex = submissions.indexOf(previous);
  console.log(currentIndex)
  buildNewShowPage(submissionType, previous);
  findAllSubmissions(hoodName, submissionType);
};

function showNext(next, submissions, submissionType, hoodName){
  currentIndex = submissions.indexOf(next);
  console.log(currentIndex)
  buildNewShowPage(submissionType, next);
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
        next = submissions[++currentIndex]
      }

      if (currentIndex - 1 < 0) {
        previous = submissions[-1]
      } else {
        previous = submissions[--currentIndex]
      }
    })
    var leftArrow = document.getElementById('left-arrow');
    var rightArrow = document.getElementById('right-arrow');
    leftArrow.addEventListener('click', function(){
      showPrevious(previous, submissions, submissionType, hoodName);
    });
    rightArrow.addEventListener('click', function(){
      showNext(next, submissions, submissionType, hoodName);
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
  title.innerHTML = artwork.title;
  description.innerHTML = artwork.description;
  artist.innerHTML = "By " + artwork.artist;
  address.innerHTML = artwork.address;
  formattedDateTime.innerHTML = "Posted On " + artwork.formatted_create_time;
  clearDiv(image);
  clearDiv(deleteDiv);
  if (artwork.image.url) {
    var imgTag = document.createElement("img");
    imgTag.src = artwork.image.url;
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
  var dateTime = document.createElement("p");
  var description = document.createElement("p");
  var event_type = document.createElement("p");
  description.innerHTML = event.description
  dateTime.innerHTML = event.formatted_date_time
  event_type.innerHTML = event.type
}

function formatStoryShow(story) {
  var title = document.getElementById("title");
  var author = document.createElement("p");
  var description = document.createElement("p");
  var image = document.createElement("img");
  heading.innerHTML = story.title.link("/stories/" + story.id);
  description.innerHTML = stringTruncate(story.description, 50);
  author.innerHTML = "by " + story.author
  listing.appendChild(heading);
  if (story.image.thumb.url) {
    image.src = story.image.thumb.url;
  }
}

function findCurrentUser() {
  $.get("/api/v1/users/", function(response) {
    return response;
  });
};

function isDeletable(submission, currentUser) {
  if (currentUser) {
    if (submission.user_id == currentUser.id) {
      return true;
    } else if (currentUser.role == "community_leader" && currentUser.organizations.some(function(e) {e.name === submission.organization.name}).length > 0) {
      return true;
    } else if (currentUser.role == "community_leader" && currentUser.neighborhood_id == submission.neighborhood_id) {
      return true;
    } else if (currentUser.role == "admin") {
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
