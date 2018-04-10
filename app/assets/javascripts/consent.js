// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function selectAllOptions() {
    $("#controlsUnselectAll").each(function () {
        this.checked = false
    });
    $(".options .controls__checkbox input").each(function () {
        this.checked = true
    });
    changeFormRoute();
}

function unselectAllOptions() {
    $("#controlsSelectAll").each(function () {
        this.checked = false
    });
    $(".options .controls__checkbox input").each(function () {
        this.checked = false
    });
    changeFormRoute();
}

function Options() {
    $("#controlsSelectAll").each(function () {
        this.checked = false
    });
    $("#controlsUnselectAll").each(function () {
        this.checked = false
    });
    changeFormRoute();
}
function changeFormRoute() {
    if ($('.options input[type="checkbox"]').length == $('.options input[type="checkbox"]:checked').length) {
        $("#step_two_form")[0].action = 'confirm_answers'
    } else {
        $("#step_two_form")[0].action = 'review_answers'
    }
}
