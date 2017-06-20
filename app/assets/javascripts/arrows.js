var currentIndex
$(document).ready(function(){
  var hoodName = document.getElementById('left-arrow').firstChild.getAttribute("data-neighborhood");
  var submissionType = document.getElementById('left-arrow').firstChild.getAttribute("data-type");
  findAllSubmissions(hoodName, submissionType);
});

function showPrevious (previous, submissions){
  currentIndex = submissions.indexOf(previous);
  console.log(currentIndex);
  buildNewShowPage(submissionType, previous);

};

function showNext(next, submissions){
  currentIndex = submissions.indexOf(next);
  console.log(currentIndex);
};

function findAllSubmissions(hoodName, submissionType){
  $.get("/api/v1/neighborhoods/" + hoodName, function(response){
  }).done(function(response){
    var currentTitle = document.getElementById('title').innerHTML;
    var submissions = response[submissionType]
    var next
    var previous
    submissions.forEach(function(submission){
      if (submission.title === currentTitle) {
        currentIndex = submissions.indexOf(submission);
      }

      if (++currentIndex === submissions.length) {
        next = submissions[0]
      } else {
        next = submissions[++currentIndex]
      }

      if (--currentIndex < 0) {
        previous = submissions[-1]
      } else {
        previous = submissions[--currentIndex]
      }
    })
    var leftArrow = document.getElementById('left-arrow');
    var rightArrow = document.getElementById('right-arrow');
    leftArrow.addEventListener('click', function(){
      showPrevious(previous, submissions);
    });
    rightArrow.addEventListener('click', function(){
      showNext(next, submissions);
    });
  });

  function buildNewShowPage(type, submission) {
    if (type === 'artworks') {
      formatArtwork(submission);
    } else if (type === 'events') {
      formatEvent(submission);
    } else {
      formatStory(submission);
    };
  };

  function formatArtwork(artwork) {
    var title = document.getElementById("title");
    var artist = document.getElementById("artist");
    var description = document.getElementById("description");
    var image = document.getElementById("image");
    var address = document.getElementById("address");
    var formattedDateTime = document.getElementById("datetime");
    title.innerHTML = artwork.title;
    description.innerHTML = artwork.description;
    artist.innerHTML = "By " + artwork.artist;
    address.innerHTML = artwork.address;
    formattedDateTime.innerHTML = "Posted On " + artwork.formatted_date_time;
    if (artwork.image.url) {
      image.src = artwork.image.url;
    }
  }

  function formatEvent(event) {
    var title = document.getElementById("title");
    var image = document.getElementById("image");
    var dateTime = document.createElement("p");
    var description = document.createElement("p");
    var event_type = document.createElement("p");
    description.innerHTML = event.description
    dateTime.innerHTML = event.formatted_date_time
    event_type.innerHTML = event.type
  }

  function formatStory(story) {
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
};
