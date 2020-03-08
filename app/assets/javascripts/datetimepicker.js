$(document).ready(function() {
  $('#user_dob').datetimepicker({
    format: 'DD-MM-YYYY',
    defaultDate: "01/01/1995",
    icons: {
      previous: 'icon__prev',
      next: 'icon__next'
    }
  });
})