// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function ready() {
    $('[data-toggle="popover"]').popover();
    toggleNavBarLink();
}

function toggleNavBarLink() {
    $active_link = "#" + $('#active_tab').val();
    $('.navbar-nav').find('.active').removeClass('active');
    $('.navbar-nav').find($active_link).addClass('active');
}

(function () {
    $(document).on('ready turbolinks:load', ready);
}).call(this);
