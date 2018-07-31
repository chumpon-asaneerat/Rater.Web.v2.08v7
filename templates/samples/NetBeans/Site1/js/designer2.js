/* DOM Utils */
function NDOM() { }
NDOM.Events = { };
NDOM.Events.addListener = function(elem, type, callback) {
    //console.log('addEventListener');
    if (elem === null || typeof(elem) === 'undefined')
        return;
    if (elem.addEventListener) {
        elem.addEventListener(type, callback, false);
    }
    else if (elem.attachEvent) {
        elem.attachEvent("on" + type, callback);
    }
    else {
        elem["on" + type] = callback;
    }
};

/* Screen/Window */
function NScreen() {
    // init width and height in pixel.
    this.width = screen.availWidth;
    this.height = screen.availHeight;
};

function NWindow() {
    // init width and height in pixel.
    this.width = window.innerWidth;
    this.height = window.innerHeight;
    this.screen = new NScreen(); // init screen object.
    this.$window = $(window);    
    this.$output = null;
    
    function CreateDiv() {
        var html = '<div id="scr-sz"><p id="scr-sz-p">Size w:00, H:00</p></div>';
        var style = '{ position: absolute; }';        
        var $outputDiv = $(html);
        $outputDiv.css(style);
        $outputDiv.appendTo('body');
        
        self.update();
    };
    
    var self = this;
    // Window Events
    var _onLoad = function(evt) {
        //console.log('loaded');
        //console.log(evt);
        evt.preventDefault();
    };
    var _onResize = function(evt) {
        //console.log('resized');
        //console.log(evt);
        evt.preventDefault();
        self.update();
    };
    NDOM.Events.addListener(window, 'load', _onLoad);
    NDOM.Events.addListener(window, 'resize', _onResize);
    
    CreateDiv();
};

NWindow.prototype.update = function() {
    var sOut = 'Size w:' + window.innerWidth + ', H:' + window.innerHeight;
    if (this.$output === null || this.$output === 'undefined' ||
        typeof this.$output === 'undefined') {
        this.$output = $('#scr-sz-p');    
    };
    this.$output.css({
        position: 'absolute',
        top: window.innerHeight - (2 * this.$output.outerHeight()),
        left: 5
    });    
    this.$output.text(sOut);
};

var Window = null;

$(function() {
    Window = new NWindow();
});
