//this js effect for help files/hints in applcation

$(document).ready(function() {
    $('.slickbox').hide();
    $('a.slick-toggle').click(function() {
        var dataID = $(this).attr("data-id");
        $("div[data-id=" + dataID + "].slickbox").toggle(400);
        return false;
    });
});

$(function() {
    $('.accordion').accordion({
        collapsible: true,
        active: false,
        autoHeight: false
    });
});
