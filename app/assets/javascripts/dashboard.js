// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function toggleNavBarLink() {
    $active_link = "#" + $('#active_tab').val();
    $('.navbar-nav').find('.active').removeClass('active');
    $('.navbar-nav').find($active_link).addClass('active');
}

$(document).on('page:change turbolinks:load', function(){
    $('[data-toggle="popover"]').popover();
    toggleNavBarLink();
});