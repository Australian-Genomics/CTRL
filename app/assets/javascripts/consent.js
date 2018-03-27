// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function selectAllOptions() {
        $("#controlsUnselectAll").each(function () {
            this.checked = false
        });
        $(".options .controls__checkbox input").each(function () {
            this.checked = true
        });
    // debugger
}

function unselectAllOptions() {
    $("#controlsSelectAll").each(function () {
        this.checked = false
    });
    $(".options .controls__checkbox input").each(function () {
        this.checked = false
    });
}

function Options() {
    $("#controlsSelectAll").each(function () {
        this.checked = false
    });
    $("#controlsUnselectAll").each(function () {
        this.checked = false
    });
}

function ButtonOptions() {
    if ($(".options .controls__checkbox input")) {
        this.checked = false
    }
    location.href = "/review_answers"
}
