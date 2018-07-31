// Resize Sensor.
function EventQueue(elem) {
    var q = [];
    var element = elem;
    this.add = function (ev) {
        q.push(ev);
    };

    var i, j;
    this.call = function (element, evt) {
        for (i = 0, j = q.length; i < j; i++) {
            q[i].call(null, element, evt);
        }
    };

    this.remove = function (ev) {
        var newQueue = [];
        for (i = 0, j = q.length; i < j; i++) {
            if (q[i] !== ev) newQueue.push(q[i]);
        }
        q = newQueue;
    }

    this.length = function () {
        return q.length;
    }
};

var gRenderSensor = function () {
    // Make sure it does not throw in a SSR (Server Side Rendering) situation
    if (typeof window === "undefined") {
        return null;
    }
    // Only used for the dirty checking, so the event callback count is limited to max 1 call per fps per sensor.
    // In combination with the event based resize sensor this saves cpu time, because the sensor is too fast and
    // would generate too many unnecessary events.
    var requestAnimationFrame = window.requestAnimationFrame ||
        window.mozRequestAnimationFrame ||
        window.webkitRequestAnimationFrame ||
        function (fn) {
            return window.setTimeout(fn, 20);
        };
    /**
     * Iterate over each of the provided element(s).
     *
     * @param {HTMLElement|HTMLElement[]} elements
     * @param {Function}                  callback
     */
    function forEachElement(elements, callback) {
        var elementsType = Object.prototype.toString.call(elements);
        var isCollectionTyped = ('[object Array]' === elementsType
            || ('[object NodeList]' === elementsType)
            || ('[object HTMLCollection]' === elementsType)
            || ('[object Object]' === elementsType)
            || ('undefined' !== typeof jQuery && elements instanceof jQuery) //jquery
            || ('undefined' !== typeof Elements && elements instanceof Elements) //mootools
        );
        var i = 0, j = elements.length;
        if (isCollectionTyped) {
            for (; i < j; i++) {
                callback(elements[i]);
            }
        } else {
            callback(elements);
        }
    }
    /**
     * Class for dimension change detection.
     *
     * @param {Element|Element[]|Elements|jQuery} element
     * @param {Function} callback
     *
     * @constructor
     */
    var ResizeSensor = function (element, callback) {
        /**
         *
         * @param {HTMLElement} element
         * @param {Function}    resized
         */
        function attachResizeEvent(element, resized) {
            if (!element) return;
            if (element.resizedAttached) {
                element.resizedAttached.add(resized);
                return;
            }

            element.resizedAttached = new EventQueue(element);
            element.resizedAttached.add(resized);

            element.resizeSensor = document.createElement('div');
            element.resizeSensor.className = 'resize-sensor';
            var style = 'position: absolute; left: 0; top: 0; right: 0; bottom: 0; overflow: hidden; z-index: -1; visibility: hidden;';
            var styleChild = 'position: absolute; left: 0; top: 0; transition: 0s;';

            element.resizeSensor.style.cssText = style;
            element.resizeSensor.innerHTML =
                '<div class="resize-sensor-expand" style="' + style + '">' +
                '<div style="' + styleChild + '"></div>' +
                '</div>' +
                '<div class="resize-sensor-shrink" style="' + style + '">' +
                '<div style="' + styleChild + ' width: 200%; height: 200%"></div>' +
                '</div>';
            element.appendChild(element.resizeSensor);

            if (element.resizeSensor.offsetParent !== element) {
                element.style.position = 'relative';
            }

            var expand = element.resizeSensor.childNodes[0];
            var expandChild = expand.childNodes[0];
            var shrink = element.resizeSensor.childNodes[1];
            var dirty, rafId, newWidth, newHeight;
            var lastWidth = element.offsetWidth;
            var lastHeight = element.offsetHeight;

            var reset = function () {
                expandChild.style.width = '100000px';
                expandChild.style.height = '100000px';

                expand.scrollLeft = 100000;
                expand.scrollTop = 100000;

                shrink.scrollLeft = 100000;
                shrink.scrollTop = 100000;
            };

            reset();

            var onResized = function (evt) {
                rafId = 0;
                if (!dirty) return;

                lastWidth = newWidth;
                lastHeight = newHeight;

                if (element.resizedAttached) {
                    element.resizedAttached.call(element, evt);
                }
            };

            var onScroll = function (evt) {
                newWidth = element.offsetWidth;
                newHeight = element.offsetHeight;
                dirty = newWidth != lastWidth || newHeight != lastHeight;
                if (dirty && !rafId) {
                    rafId = requestAnimationFrame(function () {
                        //onResized(arguments);
                        onResized(evt);
                    });
                }
                reset();
            };

            var addEvent = function (el, name, cb) {
                if (el.attachEvent) {
                    el.attachEvent('on' + name, cb);
                } else {
                    el.addEventListener(name, cb);
                }
            };

            addEvent(expand, 'scroll', onScroll);
            addEvent(shrink, 'scroll', onScroll);
        }

        forEachElement(element, function (elem) {
            attachResizeEvent(elem, callback);
        });

        this.detach = function (ev) {
            ResizeSensor.detach(element, ev);
        };
    };

    ResizeSensor.detach = function (element, ev) {
        forEachElement(element, function (elem) {
            if (!elem) return
            if (elem.resizedAttached && typeof ev == "function") {
                elem.resizedAttached.remove(ev);
                if (elem.resizedAttached.length()) return;
            }
            if (elem.resizeSensor) {
                if (elem.contains(elem.resizeSensor)) {
                    elem.removeChild(elem.resizeSensor);
                }
                delete elem.resizeSensor;
                delete elem.resizedAttached;
            }
        });
    };
    return ResizeSensor;
};

; (function (root, factory) {
    if (typeof define === "function" && define.amd) {
        define(factory);
    } else if (typeof exports === "object") {
        module.exports = factory();
    } else {
        root.ResizeSensor = factory();
    }
}(typeof window !== 'undefined' ? window : this, gRenderSensor));

// Dock Layout.
function DockLayout(elem) {
    this.self = this;
    this.element = elem;
    var __this = this;
    var area = {};

    function updateLayouts(el) {
        var iChildCnt = el.childNodes.length;
        area = {
            left: el.left,
            top: el.top,
            right: el.right,
            bottom: el.bottom,
            width: el.offsetWidth,
            height: el.offsetHeight        
        };

        for (var i = 0; i < iChildCnt; ++i) {
            updateChildLayout(el, el.childNodes[i]);
        }
    }

    function updateChildLayout(elem, child) {
        if (!elem || !child || !child.className) {
            return;
        }
        var classNames = child.className.split(' ');
        var margin = 0;
        var dft = 1;

        if (classNames.indexOf('dock-top') !== -1) {
            child.style.left = margin + ((area.left) ? area.left : child.left) + 'px';
            child.style.top = margin + ((area.top) ? area.top : child.top) + 'px';
            child.style.right = margin + ((area.right) ? area.right : child.right) + 'px';

            if (!area.top) area.top = child.offsetHeight - margin;
            else area.top += child.offsetHeight - margin;

            if (!area.height) area.height = child.offsetHeight;
            else area.height -= child.offsetHeight;

            elem.style['overflow'] = 'hidden';
        }
        else if (classNames.indexOf('dock-bottom') !== -1) {
            child.style.left = margin + ((area.left) ? area.left : child.left) + 'px';            
            child.style.right = margin + ((area.right) ? area.right : child.right) + 'px';
            child.style.bottom = margin + ((area.bottom) ? area.bottom : child.bottom) + 'px';
            if (!child.style.bottom) {
                child.bottom = dft;
                child.style.bottom = margin + dft + 'px';
                //console.log(child.bottom);
            }

            if (!area.bottom) area.bottom = child.offsetHeight;
            else area.bottom += child.offsetHeight;

            if (!area.height) area.height = child.offsetHeight;
            else area.height -= child.offsetHeight;

            elem.style['overflow'] = 'hidden';
        }
        else if (classNames.indexOf('dock-left') !== -1) {
            child.style.left = margin + ((area.left) ? area.left : child.left) + 'px';
            child.style.top = margin + ((area.top) ? area.top : child.top) + 'px';
            child.style.bottom = margin + ((area.bottom) ? area.bottom : child.bottom) + 'px';

            if (!area.left) area.left = child.offsetWidth;
            else area.left += child.offsetWidth;

            if (!area.width) area.width = child.offsetWidth;
            else area.width -= child.offsetWidth;

            elem.style['overflow'] = 'hidden';
        }
        else if (classNames.indexOf('dock-right') !== -1) {
            child.style.top = margin + ((area.top) ? area.top : child.top) + 'px';
            child.style.right = margin + ((area.right) ? area.right : child.right) + 'px';
            child.style.bottom = margin + ((area.bottom) ? area.bottom : child.bottom) + 'px';

            if (!area.right) area.right = child.offsetWidth;
            else area.right += child.offsetWidth;

            if (!area.width) area.width = child.offsetWidth;
            else area.width -= child.offsetWidth;

            elem.style['overflow'] = 'hidden';
        }
        else {
            if (classNames.indexOf('dock-client') !== -1) {
                elem.style['overflow'] = 'hidden';
            }
            /*            
            child.style.left = margin + ((area.left) ? area.left : dft) + 'px';
            child.style.top = margin + ((area.top) ? area.top : dft) + 'px';
            child.style.right = margin + ((area.right) ? area.right : dft) + 'px';
            child.style.bottom = margin + ((area.bottom) ? area.bottom : dft) + 'px';
            */
            child.style.left = margin + ((area.left) ? area.left : child.left) + 'px';
            child.style.top = margin + ((area.top) ? area.top : child.top) + 'px';
            child.style.right = margin + ((area.right) ? area.right : child.right) + 'px';
            child.style.bottom = margin + ((area.bottom) ? area.bottom : child.bottom) + 'px';
        }
    }

    function resizeHandler(el, evt) {
        //console.log('resize: ', el.tagName.toLowerCase(), '(', el.offsetWidth, ', ', el.offsetHeight, ')');
        updateLayouts(el);
    };

    if (this.element) {
        updateLayouts(this.element);
        new ResizeSensor(this.element, resizeHandler);
    }
    else {
        console.log('no element.');
    }
};

; (function () {
    var hosts = document.getElementsByClassName('dock-layout');
    if (!hosts) {
        console.log('dock layout not found.');
        return;
    }
    var len = hosts.length;
    for (var i = 0; i < len; ++i) {
        new DockLayout(hosts[i]);
    };
})();
