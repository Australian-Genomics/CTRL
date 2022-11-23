$(document).on('ready turbolinks:load', function() {
  $('#user_dob').datetimepicker({
    format: 'DD-MM-YYYY',
    useCurrent: false,
    icons: {
      previous: 'icon__prev',
      next: 'icon__next'
    }
  });
  $('#date-of-birth').datepicker({
    container: '#date-of-birth-pos',
    format: 'dd-mm-yyyy'
  });
  $('#child-date-of-birth').datepicker({
    container: '#child-date-of-birth-pos',
    format: 'dd-mm-yyyy'
  });
})
