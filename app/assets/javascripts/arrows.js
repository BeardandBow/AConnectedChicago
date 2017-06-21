var currentIndex
$(document).ready(function(){
  var hoodName = document.getElementById('left-arrow').firstChild.getAttribute("data-neighborhood");
  var submissionType = document.getElementById('left-arrow').firstChild.getAttribute("data-type");
  findAllSubmissions(hoodName, submissionType);
});

function showPrevious (previous, submissions){
  currentIndex = submissions.indexOf(previous);
  console.log(currentIndex);

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
};
