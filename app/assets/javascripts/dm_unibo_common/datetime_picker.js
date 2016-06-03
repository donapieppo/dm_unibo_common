//= require moment
//= require moment/it
//= require bootstrap-datetimepicker

$(function () {
  $('input.datetime_picker').datetimepicker({
    locale: 'it', 
    stepping: 5
  });
});

