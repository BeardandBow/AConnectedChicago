$("#modal").ready(function(){
  var touches = 0
  var currentDate = new Date().toDateString()
  if (localStorage.getItem("lastVisited")) {
    checkDate(currentDate)
  } else {
    var body = document.querySelector("body")
    body.addEventListener('click', hideModal, false)
    body.addEventListener('touchend', function() {
      touches += 1
      if (touches >= 2) {
        hideModal()
      }
    })

    localStorage.setItem("lastVisited", currentDate)
    $("#navbar").hide();
    noClicks();
  }
});

function hideModal() {
  $("#navbar").show();
  $("#modal-container").hide();
  $("#map").show();
  $("#info-backdrop").show();
  this.removeEventListener('click', hideModal, false)
  createMap()
 }

function noClicks() {
  $("#map").hide();
  $("#info-backdrop").hide();
  $("#navbar").hide();
}

function checkDate(currentDate) {
  if (currentDate !== localStorage.getItem("lastVisited")) {
    localStorage.setItem("lastVisited", currentDate)
    noClicks();
  } else {
    hideModal()
    createMap();
  }
}
