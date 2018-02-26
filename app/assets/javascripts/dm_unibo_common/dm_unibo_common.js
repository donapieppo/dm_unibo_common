$(document).ready(function() {
  $("input:submit").button();
  $("a.button").button();

  //$('input.date_picker').datepicker({
  //  language: 'it', 
  //  format: "dd/mm/yyyy"
  //});

  $('.modal-link').click(function(event){
    event.preventDefault();
    var url = $(this).attr('href');
    var separator = url.indexOf('?') > -1 ? '&' : '?';
    $('#main-modal .modal-body').load(url + separator + "modal=yyy");
    $('#main-modal').modal('show');
  });
});


