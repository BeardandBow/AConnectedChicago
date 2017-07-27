$("#modal").ready(function(){
  var currentDate = new Date().toDateString()
  if (localStorage.getItem("lastVisited")) {
    checkDate(currentDate)
  } else {
    localStorage.setItem("lastVisited", currentDate)
    $("#navbar").hide();
    noClicks();
    hideModal();
  }
});

function hideModal() {
  var body = document.getElementsByTagName('body')[0];
  body.addEventListener('click', function (e) {
    $("#navbar").show();
    $("#modal-container").hide();
    $("#map").show();
    createMap();
    $("#info-backdrop").show();
  });
};

function noClicks() {
  $("#map").hide();
  $("#info-backdrop").hide();
  $("#navbar").hide();
}

function checkDate(currentDate) {
  if (currentDate !== localStorage.getItem("lastVisited")) {
    $("#navbar").hide();
    noClicks();
    hideModal();
  } else {
    $("#navbar").show();
    $("#modal-container").hide();
    $("#map").show();
    createMap();
    $("#info-backdrop").show();
  }
}
