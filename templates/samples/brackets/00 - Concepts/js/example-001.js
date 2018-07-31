var screenX = window.innerHeight;
var screenY = window.innerWidth;

function showSlide(containerId, slideId) {
    $('#' + containerId).empty(); // clear all children elements.
    var html = $('#' + slideId).html();
    $('#' + containerId).append(html);
};

function showSlides(previewId, containerId, slideIds) {
    var screenX = screen.availWidth;
    var screenY = screen.availHeight;
    console.log('screen:', screenX, ', ', screenY);

    var container = $('#' + containerId);
    var preview = $('#' + previewId);
    var parent = $(preview).parent();

    for (var i in slideIds) {
        var thumbName = 'thumbnail-' + container.children().length.toString();
        var slide = $('#' + slideIds[i]);
        //console.log("slide : ", slide.width(), ", " + slide.height());
        var html = '<div class="slide-thumbnail-area"><div class="slide-thumbnail" id="' + thumbName + '">' + slide.html() + '</div></div>';
        container.append(html);

        var thumb = $('#' + thumbName);
        //var scale = Math.min(thumb.width() / preview.width(), thumb.height() / preview.height());
        //var scaleX = preview.outerWidth(true) / container.outerWidth(true);
        //var scaleY = preview.outerHeight(true) / container.outerHeight(true);
        var scaleX = preview.innerWidth() / container.innerWidth();
        var scaleY = preview.innerHeight() / container.innerHeight();
        //var scaleX = preview.width() / container.width();
        //var scaleY = preview.height() / container.height();
        //var scaleX = preview.width() / parent.width();
        //var scaleY = preview.height() / parent.height();
        var scale = Math.min(scaleX, scaleY);
        console.log('scale:', scale);
        console.log('scale:', scaleX, ', ', scaleY);

        //var scaleX = thumb.width() / container.width();
        //var scaleY = thumb.height() / container.height();
        /*
        $(thumb).css({
            "webkitTransform": "scale(" + scaleX + ", " + scaleY + ")",
            "MozTransform": "scale(" + scaleX + ", " + scaleY + ")",
            "msTransform": "scale(" + scaleX + ", " + scaleY + ")",
            "OTransform": "scale(" + scaleX + ", " + scaleY + ")",
            "transform": "scale(" + scaleX + ", " + scaleY + ")"
        });
        */

        $(thumb).css({
            "webkitTransform": "scale(" + scale + ")",
            "MozTransform": "scale(" + scale + ")",
            "msTransform": "scale(" + scale + ")",
            "OTransform": "scale(" + scale + ")",
            "transform": "scale(" + scale + ")"
        });
    }
};

;(function() {
    console.log('example 001 script load.');
})();
