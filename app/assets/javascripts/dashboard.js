// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function toggleNavBarLink() {
    $active_link = "#" + $('#active_tab').val();
    $('.navbar-nav').find('.active').removeClass('active');
    $('.navbar-nav').find($active_link).addClass('active');
}

$(document).on('page:change turbolinks:load', function(){
    $('[data-toggle="popover"]').popover();

    $("div[data-time]").each(function() {
      const options = {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      }

      const reviewedDate = new Date($(this).data('time'));
      const currentDate = reviewedDate.toLocaleDateString("en-US", options);

      $(this).html(currentDate);
    });

    toggleNavBarLink();
});
