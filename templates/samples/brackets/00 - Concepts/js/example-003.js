;(function () {
    /*
    var config = {
        width: 1024,  // assumed width of each step (step contents should fit into 1024 pixels width)
        height: 768,  // assumed height of each step (step contents should fit into 768 pixels height)
        maxScale: 1,  // maximum scale of presentation (1 means it won't get bigger than it's standard size even if window gets bigger)
        minScale: 0   // minimum scale of presentation (0 means it will get as small as needed)
    }    

    var computeWindowScale = function (config) {
        var hScale = window.innerHeight / config.height,
            wScale = window.innerWidth / config.width,
            scale = hScale > wScale ? wScale : hScale;

        if (config.maxScale && scale > config.maxScale) {
            scale = config.maxScale;
        }

        if (config.minScale && scale < config.minScale) {
            scale = config.minScale;
        }

        return scale;
    };

    window.addEventListener('resize', function() {
        var shower = document.getElementsByClassName('shower')[0];
        var scale = computeWindowScale(config);
        shower.style.transform = 'scale(' + scale + ')';
    });
    */
})();