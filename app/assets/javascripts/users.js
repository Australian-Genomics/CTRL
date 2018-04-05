// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {
    $('.datepicker').datepicker();
});

$('#user_is_parent').change(function () {
    if ($(this).is(":checked")) {
        $('#kin').hide();
        $('#child').show();
    } else {
        $('#kin').show();
        $('#child').hide();
    }
})

$(window).on('load', function () {
    if ($('#user_is_parent').is(":checked")) {
        $('#kin').hide();
        $('#child').show();
    } else {
        $('#kin').show();
        $('#child').hide();
    }
})