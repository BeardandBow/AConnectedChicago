$("#map").ready(function(){
  $("#navbar").hide();
  noClicks();
  hideModal();
});

function hideModal() {
  var body = document.getElementsByTagName('body')[0];
  body.addEventListener('click', function (e) {
    $("#navbar").show();
    $("#modal-container").hide();
    $("#map").show();
    $("#info-backdrop").show();
  });
};

function noClicks() {
  $("#map").hide();
  $("#info-backdrop").hide();
  $("#navbar").hide();
}
