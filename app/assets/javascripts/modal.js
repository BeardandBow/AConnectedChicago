$("#modal").ready(function(){
  var currentDate = new Date().toDateString()
  noClicks()
  if (localStorage.getItem("lastVisited")) {
    checkDate(currentDate)
  } else {
    //double tap functionality. The client wanted this
    var body = document.querySelector("body")
    body.addEventListener('click', addClickListeners)

    body.addEventListener('touchend', addClickListeners)

    localStorage.setItem("lastVisited", currentDate)
    $("#navbar").hide()
    noClicks()
  }
})

function addClickListeners() {
  var body = document.querySelector("body")
  body.addEventListener('click', hideModal)
  body.addEventListener('touchend', hideModal)
}

function hideModal() {
  $("#navbar").show();
  $("#modal-container").hide();
  $("#map").show();
  $("#info-backdrop").show();
  this.removeEventListener('click', hideModal)
  this.removeEventListener('touchend', hideModal)
  this.removeEventListener('click', addClickListeners)
  this.removeEventListener('touchend', addClickListeners)
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
    var body = document.querySelector("body")
    body.addEventListener('click', addClickListeners)
    body.addEventListener('touchend', addClickListeners)
  } else {
    hideModal()
    $("#navbar").show();
    createMap();
  }
}
