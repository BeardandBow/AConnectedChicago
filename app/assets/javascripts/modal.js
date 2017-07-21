$(document).ready(function(){
  hideModal();
});

function hideModal(){
  var body = document.getElementsByTagName('body')[0];
  body.addEventListener('click', function (e) {
    $("#modal-center").hide();
    $("#map").css("pointer-events", "auto")
    $("#info-backdrop").css("pointer-events", "auto")
    $("navbar-default").css("pointer-events", "auto")
  });
};
