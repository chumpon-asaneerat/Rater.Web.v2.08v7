
$(document).ready(function() {
    var elements = $('.design-object');
    for (var element in elements) {
        showHotSpot(element);
    }
});

function showHotSpot(id) {
    var elem = $(id);
    elem.addClass("HS-TL");
    elem.addClass("HS-TM");
    elem.addClass("HS-TR");
    elem.addClass("HS-CL");
    elem.addClass("HS-CM");
    elem.addClass("HS-CR");
    elem.addClass("HS-BL");
    elem.addClass("HS-BM");
    elem.addClass("HS-BR");
};

function hodeHotSpot(id) {
    var elem = $(id);
    elem.removeClass("HS-TL");
    elem.removeClass("HS-TM");
    elem.removeClass("HS-TR");
    elem.removeClass("HS-CL");
    elem.removeClass("HS-CM");
    elem.removeClass("HS-CR");
    elem.removeClass("HS-BL");
    elem.removeClass("HS-BM");
    elem.removeClass("HS-BR");
};

