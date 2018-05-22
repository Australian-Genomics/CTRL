// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function ready() {
    $('[data-toggle="popover"]').popover();
    userIsParentChangeHandler();
    showDetails();
}

function userIsParentChangeHandler() {
    $('#user_is_parent').change(function () {
        $(':input', '#kin').val('');
        $(':input', '#child').val('');
        if ($(this).is(":checked")) {
            $('#kin').hide();
            $('#child').show();
        } else {
            $('#kin').show();
            $('#child').hide();
        }
    });
}

function showDetails() {
    if ($('#user_is_parent').is(":checked")) {
        $('#kin').hide();
        $('#child').show();
    } else {
        $('#kin').show();
        $('#child').hide();
    }
}

(function () {
    $(document).on('ready turbolinks:load', ready);
}).call(this);
