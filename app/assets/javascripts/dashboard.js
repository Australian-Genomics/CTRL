// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function ready() {
    $('[data-toggle="popover"]').popover();
}

(function () {
    $(document).on('ready turbolinks:load', ready);
}).call(this);
