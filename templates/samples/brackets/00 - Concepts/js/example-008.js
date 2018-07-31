function Overlay(parentElement, overlayId) {
    this.parent = parentElement;
    this.id = overlayId;
    this.element = null;
};

Overlay.prototype.create = function() {
    if (this.parent && !this.element) {
        this.element = document.createElement('div');        
        this.element.setAttribute('designer-object-overlay-id', this.id);
        this.element.style.position = 'absolute';
        this.element.style.margin = 0 + 'px';
        this.element.style.padding = 0 + 'px';
        this.element.style.zorder = 50;
        //this.element.style.pointerEvents = 'auto';

        this.parent.appendChild(this.element);
    }
    
    return this.element;
};

Overlay.prototype.remove = function() {
    if (!this.parent || !this.element) {
        return null;
    }
    this.parent.remove(this.element);
    this.element = null;
}

function Hotspot(elem) {
    this.element = elem;
    this.size = {
        width: 0,
        height: 0
    }
};

Hotspot.prototype.setSize = function (newSize) {
    if (!newSize) {
        return;
    }
    this.size.width = newSize;
    this.size.height = newSize;
};

Hotspot.prototype.setWidth = function (newWidth) {
    if (!newWidth) {
        return;
    }
    this.size.width = newWidth;
};

Hotspot.prototype.setHeight = function (newHeight) {
    if (!newHeight) {
        return;
    }
    this.size.height = newHeight;
};

function Selection(elem, opts) {
    this.__me = this;

    this.element = elem;
    if (this.element) {
        this.selectionId = this.element.getAttribute("designer-object-id");
    }    

    this.overlays = {};
    this.options = {
        hotspot: {
            width: 9,
            height: 9,
            show: true,
            background: 'royalblue',
            border: {
                radius: '50%',
                size: 1,
                color: 'cornflowerblue'
            },
            resizeDirection: 'both'
        },
        border: {
            show: true,
            size: 2,
            style: 'dotted',
            color: 'red'
        }
    }

    if (opts) {
        // Hotspot.
        if (opts.hotspot) {
            this.options.hotspot.width = (opts.hotspot.width) ? opts.hotspot.width : 9; 
            this.options.hotspot.height = (opts.hotspot.height) ? opts.hotspot.height : 9; 
            this.options.hotspot.show = (opts.hotspot.show) ? opts.hotspot.show : 9;
            this.options.hotspot.background = (opts.hotspot.background) ? opts.hotspot.background : 9;
            this.options.hotspot.resizeDirection = (opts.hotspot.resizeDirection) ? opts.hotspot.resizeDirection : 'both';

            if (this.options.hotspot.border) {
                this.options.hotspot.border.radius = (opts.hotspot.border.radius) ? opts.hotspot.border.radius : '50%';
                this.options.hotspot.border.size = (opts.hotspot.border.size) ? opts.hotspot.border.size : 1;
                this.options.hotspot.border.color = (opts.hotspot.border.color) ? opts.hotspot.border.color : 'cornflowerblue';
            }
            else {
                this.options.hotspot.border.radius = '50%';
                this.options.hotspot.border.size = 1;
                this.options.hotspot.border.color = 'cornflowerblue';
            }
        }
        // border.
        if (opts.border) {
            this.options.border.show = (opts.border.show) ? opts.border.show : true;
            this.options.border.size = (opts.border.size) ? opts.border.size : 2;
            this.options.border.style = (opts.border.style) ? opts.border.style : 'dotted';
            this.options.border.color = (opts.border.color) ? opts.border.color : 'red';
        }
    }

    this.__initialize();
}

Selection.prototype.getOverlayId = function (id) {
    return this.selectionId + '-' + id;
};

Selection.prototype.__initialize = function () {
    if (this.options.border && this.options.border.show) {
        this.__addOverlay(this.getOverlayId('border'));
    }

    if (this.options.hotspot.show) {
        if (this.options.hotspot.resizeDirection === 'vert' ||
            this.options.hotspot.resizeDirection === 'both') {
            this.__addOverlay(this.getOverlayId('hs-n'));
            this.__addOverlay(this.getOverlayId('hs-s'));
        }
        if (this.options.hotspot.resizeDirection === 'horz' ||
            this.options.hotspot.resizeDirection === 'both') {
            this.__addOverlay(this.getOverlayId('hs-e'));
            this.__addOverlay(this.getOverlayId('hs-w'));
        }
        if (this.options.hotspot.resizeDirection === 'both') {
            this.__addOverlay(this.getOverlayId('hs-ne'));
            this.__addOverlay(this.getOverlayId('hs-nw'));
            this.__addOverlay(this.getOverlayId('hs-se'));
            this.__addOverlay(this.getOverlayId('hs-sw'));
        }
    }
};

Selection.prototype.__addOverlay = function (id) {
    var overlay = new Overlay(this.element, id);
    this.overlays[id] = overlay;
};

Selection.prototype.__getOverlay = function (id) {
    var overlay = this.overlays[id];
    if (overlay && overlay.parent && !overlay.element) {
        overlay.create();
    }
    return overlay;
};

Selection.prototype.__setOverlayStyle = function (id, style) {
    if (!style) {
        return;
    }
    var overlay = this.__getOverlay(id);
    if (overlay && overlay.element && overlay.element.style) {
        var elStyle = overlay.element.style;
        var names = Object.getOwnPropertyNames(style);
        for (var i = 0; i < names.length; ++i) {
            var name = names[i];
            if (/*elStyle.hasOwnProperty(name) &&*/ style.hasOwnProperty(name)) {
                elStyle[name] = style[name];
            }
            else {
                console.log('style: ', name, ' is not exist.');
            }
        }
    }
    else {
        console.log('cannot set style to overlay: ', overlay);
    }
};

Selection.prototype.__removeOverlay = function (id) {
    var overlay = this.overlays[id];
    if (overlay) {
        overlay.remove();
    }
};

Selection.prototype.getRect = function () {
    var wd = this.options.hotspot.width;
    var wd2 = (wd / 2);
    var ht = this.options.hotspot.height;
    var ht2 = (ht / 2);
    var ewd = (!this.element) ? 0 : this.element.clientWidth + wd + 1.25;
    var eht = (!this.element) ? 0 : this.element.clientHeight + ht + 1.25;
    var rect = { };


    rect.width = ewd;
    rect.height = eht;

    rect.left = -wd2 - .5;
    rect.top = -ht2 - .5;
    rect.right = 0;
    rect.bottom = 0;

    return rect;
};

Selection.prototype.show = function () {
    //this.element.style.pointerEvents = 'none';

    var rect = this.getRect();
    var style = { };
    if (this.options.border && this.options.border.show) {        
        style = {
            'width': rect.width + 'px',
            'height': rect.height + 'px',
            'cursor': 'auto',
            'border': this.options.border.size + 'px ' + this.options.border.style + ' ' + this.options.border.color,
            'left': rect.left + 'px',
            'top': rect.top + 'px'
        };
        this.__setOverlayStyle(this.getOverlayId('border'), style);
    }

    if (this.options.hotspot.show) {
        if (this.options.hotspot.resizeDirection === 'vert' ||
            this.options.hotspot.resizeDirection === 'both') {
            style = {
                'width': this.options.hotspot.width + 'px',
                'height': this.options.hotspot.height + 'px',
                'background': this.options.hotspot.background,
                '-moz-border-radius': this.options.hotspot.border.radius,
                '-webkit-border-radius': this.options.hotspot.border.radius,
                'border-radius': this.options.hotspot.border.radius,
                'border': this.options.hotspot.border.size + 'px solid ' + this.options.hotspot.border.color,
                'cursor': 'n-resize',
                'left': (-this.options.hotspot.width + (rect.width / 2)) + 'px',
                'top': (-(this.options.hotspot.height) + 1) + 'px'
            };
            this.__setOverlayStyle(this.getOverlayId('hs-n'), style);

            style = {
                'width': this.options.hotspot.width + 'px',
                'height': this.options.hotspot.height + 'px',
                'background': this.options.hotspot.background,
                '-moz-border-radius': this.options.hotspot.border.radius,
                '-webkit-border-radius': this.options.hotspot.border.radius,
                'border-radius': this.options.hotspot.border.radius,
                'border': this.options.hotspot.border.size + 'px solid ' + this.options.hotspot.border.color,
                'cursor': 's-resize',
                'left': (-this.options.hotspot.width + (rect.width / 2)) + 'px',
                'bottom': (-(this.options.hotspot.height) + 1) + 'px'
            };
            this.__setOverlayStyle(this.getOverlayId('hs-s'), style);
        }
        if (this.options.hotspot.resizeDirection === 'horz' ||
            this.options.hotspot.resizeDirection === 'both') {
            style = {
                'width': this.options.hotspot.width + 'px',
                'height': this.options.hotspot.height + 'px',
                'background': this.options.hotspot.background,
                '-moz-border-radius': this.options.hotspot.border.radius,
                '-webkit-border-radius': this.options.hotspot.border.radius,
                'border-radius': this.options.hotspot.border.radius,
                'border': this.options.hotspot.border.size + 'px solid ' + this.options.hotspot.border.color,
                'cursor': 'w-resize',
                'left': (-(this.options.hotspot.width) + 1) + 'px',
                'top': (-this.options.hotspot.height + (rect.height / 2)) + 'px'
            };
            this.__setOverlayStyle(this.getOverlayId('hs-e'), style);

            style = {
                'width': this.options.hotspot.width + 'px',
                'height': this.options.hotspot.height + 'px',
                'background': this.options.hotspot.background,
                '-moz-border-radius': this.options.hotspot.border.radius,
                '-webkit-border-radius': this.options.hotspot.border.radius,
                'border-radius': this.options.hotspot.border.radius,
                'border': this.options.hotspot.border.size + 'px solid ' + this.options.hotspot.border.color,
                'cursor': 'e-resize',
                'right': (-(this.options.hotspot.width) + 1) + 'px',
                'top': (-this.options.hotspot.height + (rect.height / 2)) + 'px'
            };
            this.__setOverlayStyle(this.getOverlayId('hs-w'), style);
        }
        if (this.options.hotspot.resizeDirection === 'both') {
            style = {
                'width': this.options.hotspot.width + 'px',
                'height': this.options.hotspot.height + 'px',
                'background': this.options.hotspot.background,
                '-moz-border-radius': this.options.hotspot.border.radius,
                '-webkit-border-radius': this.options.hotspot.border.radius,
                'border-radius': this.options.hotspot.border.radius,
                'border': this.options.hotspot.border.size + 'px solid ' + this.options.hotspot.border.color,
                'cursor': 'nw-resize',
                'left': (-(this.options.hotspot.width) + 1) + 'px',
                'top': (-(this.options.hotspot.height) + 1) + 'px'
            };
            this.__setOverlayStyle(this.getOverlayId('hs-nw'), style);
            
            style = {
                'width': this.options.hotspot.width + 'px',
                'height': this.options.hotspot.height + 'px',
                'background': this.options.hotspot.background,
                '-moz-border-radius': this.options.hotspot.border.radius,
                '-webkit-border-radius': this.options.hotspot.border.radius,
                'border-radius': this.options.hotspot.border.radius,
                'border': this.options.hotspot.border.size + 'px solid ' + this.options.hotspot.border.color,
                'cursor': 'ne-resize',
                'right': (-(this.options.hotspot.width) + 1) + 'px',
                'top': (-(this.options.hotspot.height) + 1) + 'px'
            };
            this.__setOverlayStyle(this.getOverlayId('hs-ne'), style);

            style = {
                'width': this.options.hotspot.width + 'px',
                'height': this.options.hotspot.height + 'px',
                'background': this.options.hotspot.background,
                '-moz-border-radius': this.options.hotspot.border.radius,
                '-webkit-border-radius': this.options.hotspot.border.radius,
                'border-radius': this.options.hotspot.border.radius,
                'border': this.options.hotspot.border.size + 'px solid ' + this.options.hotspot.border.color,
                'cursor': 'sw-resize',
                'left': (-(this.options.hotspot.width) + 1) + 'px',
                'bottom': (-(this.options.hotspot.height) + 1) + 'px'
            };
            this.__setOverlayStyle(this.getOverlayId('hs-sw'), style);
            
            style = {
                'width': this.options.hotspot.width + 'px',
                'height': this.options.hotspot.height + 'px',
                'background': this.options.hotspot.background,
                '-moz-border-radius': this.options.hotspot.border.radius,
                '-webkit-border-radius': this.options.hotspot.border.radius,
                'border-radius': this.options.hotspot.border.radius,
                'border': this.options.hotspot.border.size + 'px solid ' + this.options.hotspot.border.color,
                'cursor': 'se-resize',
                'right': (-(this.options.hotspot.width) + 1) + 'px',
                'bottom': (-(this.options.hotspot.height) + 1) + 'px'
            };
            this.__setOverlayStyle(this.getOverlayId('hs-se'), style);
        }
    }
};

Selection.prototype.hide = function () {
    if (this.options.hotspot.show) {
        if (this.options.hotspot.resizeDirection === 'vert' ||
            this.options.hotspot.resizeDirection === 'both') {
            this.__removeOverlay(this.getOverlayId('hs-n'));
            this.__removeOverlay(this.getOverlayId('hs-s'));
        }
        if (this.options.hotspot.resizeDirection === 'horz' ||
            this.options.hotspot.resizeDirection === 'both') {
            this.__removeOverlay(this.getOverlayId('hs-e'));
            this.__removeOverlay(this.getOverlayId('hs-w'));
        }
        if (this.options.hotspot.resizeDirection === 'both') {
            this.__removeOverlay(this.getOverlayId('hs-ne'));
            this.__removeOverlay(this.getOverlayId('hs-nw'));
            this.__removeOverlay(this.getOverlayId('hs-se'));
            this.__removeOverlay(this.getOverlayId('hs-sw'));
        }
    }

    if (this.options.border && this.options.border.show) {
        this.__removeOverlay(this.getOverlayId('border'));
    }

    //this.element.style.pointerEvents = 'auto';
};

var selectElement = {};

function guidGenerator() {
    var S4 = function () {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    };
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

function initResizer(element, resizePosition) {
    var selId = element.getAttribute('designer-object-id');

    if (!selId) {
        selId = '_' + guidGenerator();
        element.setAttribute('designer-object-id', selId);
        selectElement[selId] = new Selection(element);
    }

    var sel = selectElement[selId];
    console.log(sel);
    sel.show();
}

function ApplyStyle1(element) {
    var target = document.getElementById('test');
    initResizer(target, 'both');
}

function ApplyStyle2(element) {
    var target = document.getElementById('test');
    initResizer(element, 'both');    
}

function ApplyStyle3(element) {
    var target2 = document.getElementById('test2');
    initResizer(target2, 'both');
}

;(function () {
    var buttons = document.getElementsByClassName('tool-button');
    for (var i = 0; i < buttons.length; ++i) {
        // use closure to prevent variable hoisting.
        (function() {
            // create new param object.
            var param = {
                functionName: "ApplyStyle" + (i + 1).toString(),
                target: buttons[i]
            };
            buttons[i].addEventListener('click', function () {
                window[param.functionName](param.target);
            }, false);
        })();
    }
})();