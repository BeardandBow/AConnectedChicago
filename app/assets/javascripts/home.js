$("#info-backdrop").ready(function(){
  centerDropdownText()
})

function centerDropdownText() {
  $('#org-select #org-prompt').each(function(){
    $('#texttest').html($(this).text());
    while($('#texttest').width() < $('#org-select').width()) {
        $('#texttest').html('&nbsp'+$('#texttest').text()+'&nbsp');
    }
    $(this).html($('#texttest').text());
  })

  $('#hood-select #hood-prompt').each(function(){
    $('#texttest').html($(this).text());
    while($('#texttest').width() < $('#hood-select').width()) {
        $('#texttest').html('&nbsp'+$('#texttest').text()+'&nbsp');
    }
    $(this).html($('#texttest').text());
  })
}
