// DOM Helper functions.
function hasClass(elem, className) {
    if (!elem) {
        return false;
    }
    return !!elem.className.match(new RegExp('(\\s|^)' + className + '(\\s|$)'))
};

function addClass(elem, className) {
    if (!elem) {
        return;
    }
    if (!hasClass(elem, className)) elem.className += ' ' + className
};

function removeClass(elem, className) {
    if (!elem) {
        return;
    }
    if (hasClass(elem, className)) {
        var reg = new RegExp('(\\s|^)' + className + '(\\s|$)')
        elem.className = elem.className.replace(reg, '')
    }
};

/*
function EventHandler(elem) {
    this.listeners = { }
    this.element = elem;
}

EventHandler.prototype.addListener = function (eventName, handler, capture) {
    element.addEventListener(event, handler, capture);
    listeners[eventName] = {
        element = this.element,
        eventName = eventName,
        handler = handler,
        capture = capture
    };
};

EventHandler.prototype.removeListener = function (eventName) {
    if (eventName in this.listeners) {
        var h = listeners[eventName];
        h.element.removeEventListener(h.eventName, h.handler, h.capture);
        delete listeners[eventName];
    }
};

// From: https://stackoverflow.com/questions/5660131/how-to-removeeventlistener-that-is-addeventlistener-with-anonymous-function
// Handler
var Handler = (function(){
    var i = 1,
        listeners = {};

    return {
        addListener: function(element, event, handler, capture) {
            element.addEventListener(event, handler, capture);
            listeners[i] = {element: element,
                             event: event,
                             handler: handler,
                             capture: capture};
            return i++;
        },
        removeListener: function(id) {
            if(id in listeners) {
                var h = listeners[id];
                h.element.removeEventListener(h.event, h.handler, h.capture);
                delete listeners[id];
            }
        }
    };
}());

// To used.
function doSomethingWith(param) {
    return Handler.addListener(document.body, 'scroll', function() {
        document.write(param);
    }, false);
}

var handler = doSomethingWith('Test. ');

setTimeout(function() {
     Handler.removeListener(handler);
}, 3000);
*/

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

var gRenderSensor = function() {
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
                    rafId = requestAnimationFrame(function(){
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

;(function (root, factory) {
    if (typeof define === "function" && define.amd) {
        define(factory);
    } else if (typeof exports === "object") {
        module.exports = factory();
    } else {
        root.ResizeSensor = factory();
    }
}(typeof window !== 'undefined' ? window : this, gRenderSensor));


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
            updateChildLayout(el.childNodes[i]);
        }
    }

    function updateChildLayout(child) {
        if (!child || !child.className ) {
            return;
        }
        var classNames = child.className.split(' ');
        var margin = 0;
        //var dft = 1;

        if (classNames.indexOf('dock-top') !== -1) {
            child.style.left = margin + ((area.left) ? area.left : child.left) + 'px';
            child.style.top = margin + ((area.top) ? area.top : child.top) + 'px';
            child.style.right = margin + ((area.right) ? area.right : child.right) + 'px';

            if (!area.top) area.top = child.offsetHeight - margin;
            else area.top += child.offsetHeight - margin;

            if (!area.height) area.height = child.offsetHeight;
            else area.height -= child.offsetHeight;
        }
        else if (classNames.indexOf('dock-bottom') !== -1) {
            child.style.left = margin + ((area.left) ? area.left : child.left) + 'px';
            child.style.bottom = margin + ((area.bottom) ? area.bottom : child.bottom) + 'px';
            child.style.right = margin + ((area.right) ? area.right : child.right) + 'px';

            if (!area.bottom) area.bottom = child.offsetHeight;
            else area.bottom += child.offsetHeight;
            
            if (!area.height) area.height = child.offsetHeight;
            else area.height -= child.offsetHeight;
        }
        else if (classNames.indexOf('dock-left') !== -1) {
            child.style.left = margin + ((area.left) ? area.left : child.left) + 'px';
            child.style.top = margin + ((area.top) ? area.top : child.top) + 'px';
            child.style.bottom = margin + ((area.bottom) ? area.bottom : child.bottom) + 'px';

            if (!area.left) area.left = child.offsetWidth;
            else area.left += child.offsetWidth;

            if (!area.width) area.width = child.offsetWidth;
            else area.width -= child.offsetWidth;
        }
        else if (classNames.indexOf('dock-right') !== -1) {
            child.style.top = margin + ((area.top) ? area.top : child.top) + 'px';
            child.style.right = margin + ((area.right) ? area.right : child.right) + 'px';
            child.style.bottom = margin + ((area.bottom) ? area.bottom : child.bottom) + 'px';

            if (!area.right) area.right = child.offsetWidth;
            else area.right += child.offsetWidth;

            if (!area.width) area.width = child.offsetWidth;
            else area.width -= child.offsetWidth;
        }
        else {
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
        console.log('resize: ', el.tagName.toLowerCase(), '(', el.offsetWidth, ', ', el.offsetHeight, ')' );
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

function ide(dsgnElem, toolBoxElem, propEditElem) {
    this.Designer = new Designer(dsgnElem, this);
    this.ToolBox = new Toolbox(toolBoxElem, this);
    this.PropertyEditor = new PropertyEditor(propEditElem, this);
};

function Toolbox(elem, ide) {
    this.Element = elem;
    this.ide = ide;
};

function PropertyEditor(elem, ide) {
    this.Element = elem;
    this.ide = ide;
    this.properties = []; // keep all property editors.

    this.editObject = null;

    this.LoadProperties();
};

PropertyEditor.prototype.LoadProperties = function() {
    // This should call one time.
    this.properties = [];

    var inlineProps = this.Element.getElementsByClassName('inline');
    var iCnt = inlineProps.length;
    for (var i = 0; i < iCnt; ++i) {
        var propName = inlineProps[i].getAttribute('css-property');
        var inputEditor = inlineProps[i].childNodes[3];
        var self = this;
        var handler = function(evt) {
            if (self.editObject) {
                //console.log(evt);
                //console.log(evt.target.parentNode);
                //console.log(propertyName);
                var propertyName = evt.target.parentNode.getAttribute('css-property');
                var propertyValue = evt.target.value;
                var propertyUnit = evt.target.getAttribute('unit');
                self.editObject.Element.style[propertyName] = propertyValue.toString() + propertyUnit;
            }
            else {
                //console.log('Edit object is null.');
            }
        };
        inputEditor.addEventListener('input', handler);
    }
};

PropertyEditor.prototype.addEditObject = function(dsgnObj) {
    this.editObject = dsgnObj;
    //console.log('Edit object:', this.editObject);
};

PropertyEditor.prototype.removeEditObject = function (dsgnObj) {
    this.editObject = null;
    //console.log('Edit object:', this.editObject);
};

function Designer(dsgnElem, ide) {
    this.designerElement = dsgnElem;
    this.ide = ide;

    this.Objects = []; // The design object array.
    this.refresh(); // load all design objects.

    var self = this;

    this.designerElement.addEventListener('mouseup', function (evt) {
        console.log('Designer Mouse Up.');
        self.deSelectAll();
        evt.preventDefault();
        evt.stopPropagation();
    });
};

Designer.prototype.refresh = function() {
    this.Objects = []; // The design object array.

    var objs = this.designerElement.getElementsByClassName('design-obj');
    var objCnt = objs.length;
    for (var i = 0; i < objCnt; ++i) {
        this.add(objs[i]);
    }
};

Designer.prototype.add = function(dsgnElement) {
    if (dsgnElement) {
        var dsgnObj = new DesignObject(this, dsgnElement);
        this.Objects.push(dsgnObj);
    }
    else {
        console.log('cannot add object that is not has "design-obj" class');
    }
};

Designer.prototype.deSelectAll = function() {
    var objLen = this.Objects.length;
    for (var i = 0; i < objLen; ++i) {
        var obj = this.Objects[i];
        if (obj.isSelected()) {
            obj.deselect();
        }
    }
};

function DesignObject(designer, elem) {
    this.Designer = designer;
    this.Element = elem;
    var self = this;
    /*
    this.Element.addEventListener('mousedown', function(evt) {
        
    });
    */
    this.Element.addEventListener('mouseup', function (evt) {
        //console.log('Element Mouse Up.');
        self.select();
        evt.preventDefault();
        evt.stopPropagation();
    });
};

DesignObject.prototype.isSelected =  function() {
    return hasClass(this.Element, 'selected');
};

/*
function makeEditable(elem){
    elem.setAttribute('contenteditable', 'true');
    elem.addEventListener('blur', function (evt) {
        elem.removeAttribute('contenteditable');
        elem.removeEventListener('blur', evt.target);
    });
    elem.focus();
}

makeEditable(document.getElementById('myHeader'))

*/


DesignObject.prototype.select = function() {
    if (this.isSelected()) {
        // Already selected so enable contenteditable.
        //this.Element.contenteditable = true;
        this.Element.setAttribute('contenteditable', true);
        this.Element.style['cursor'] = 'auto'; // change pointer.
        // auto focus it.
        var self = this;
        this.Element.addEventListener('blur', function (evt) {
            self.Element.removeAttribute('contenteditable');
            self.Element.removeEventListener('blur', evt.target);
        });
        this.Element.focus();
    }
    else {
        this.Designer.deSelectAll();
        // Not selected so select it.
        addClass(this.Element, 'selected');
        this.Element.style['cursor'] = 'move'; // change pointer.
        // add current select object.
        this.Designer.ide.PropertyEditor.addEditObject(this);
    }
};

DesignObject.prototype.deselect = function () {
    if (this.isSelected()) {
        // Already selected so disable contenteditable.
        //this.Element.contenteditable = true;
        this.Element.removeAttribute('contenteditable');
        this.Element.contenteditable = false;
        removeClass(this.Element, 'selected');
        this.Element.style['cursor'] = 'pointer'; // change pointer.
    }
    // remove current edit object.
    //console.log(this.Designer.ide);
    this.Designer.ide.PropertyEditor.removeEditObject(this);
};

;(function() {
    var hosts = document.getElementsByClassName('dock-layout');
    if (!hosts) {
        console.log('dock layout not found.');
        return;
    }
    var len = hosts.length;
    for (var i = 0; i < len; ++i) {
        new DockLayout(hosts[i]);
    };

    var designer = document.getElementById('designer');
    var toolBox = document.getElementById('toolBox');
    var propertyEditor = document.getElementById('propertyEdit');
    new ide(designer, toolBox, propertyEditor);
})();