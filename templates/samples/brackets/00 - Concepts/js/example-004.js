function designObject(elem) {
    this.element = elem;
};

// Properties
console.log('register properties');
Object.defineProperty(designObject.prototype, 'left', {
    get: function () {
        if (!this.element)
            return NaN;
        return this.element.offsetLeft;
    },
    set: function (value) {
        if (value && typeof value == 'number')
            this.element.style.left = value.toString() + 'px';
    }
});

Object.defineProperty(designObject.prototype, 'top', {
    get: function () {
        if (!this.element)
            return NaN;
        return this.element.offsetTop;
    },
    set: function (value) {
        if (value && typeof value == 'number')
            this.element.style.top = value.toString() + 'px';
    }
});

Object.defineProperty(designObject.prototype, 'width', {
    get: function () {
        if (!this.element)
            return NaN;
        return this.element.offsetWidth;
    },
    set: function (value) {
        if (value && typeof value == 'number')
            this.element.style.width = value.toString() + 'px';
    }
});

Object.defineProperty(designObject.prototype, 'height', {
    get: function () {
        if (!this.element)
            return NaN;
        return this.element.offsetHeight;
    },
    set: function (value) {
        if (value && typeof value == 'number')
            this.element.style.height = value.toString() + 'px';
    }
});

designObject.prototype.moveTo = function (x, y) {
    this.left = x;
    this.top = y;
};

designObject.prototype.moveBy = function (dx, dy) {
    if (!this.element)
        return;

    if (dx && typeof dx == 'number') {
        var x = this.element.offsetLeft + dx;
        this.element.style.left = x.toString() + 'px';
    }
    if (dy && typeof dy == 'number') {
        var y = this.element.offsetTop + dy;
        this.element.style.top = y.toString() + 'px';
    }
};

designObject.prototype.setSize = function (w, h) {
    if (!this.element)
        return;

    if (w && typeof w == 'number')
        this.element.style.width = w.toString() + 'px';
    if (h && typeof h == 'number')
        this.element.style.height = h.toString() + 'px';
};




function mouseDragState() {
    this.beginDrag = { X: -1, Y: -1 };
    this.endDrag = { X: -1, Y: -1 };
    this.onDrag = false;
};

mouseDragState.prototype.dragBegin = function (evt) {
    // set flag;
    this.onDrag = true;
    // set begin drag value.
    this.beginDrag.X = evt.clientX;
    this.beginDrag.Y = evt.clientY;
    // reset end drag value.
    this.endDrag.X = -1; 
    this.endDrag.Y = -1;

    return this.beginDrag;
};

mouseDragState.prototype.dragMove = function (evt) {
    if (!this.onDrag)
        return;
    // set end drag value.
    this.endDrag.X = evt.clientX;
    this.endDrag.Y = evt.clientY;
};

mouseDragState.prototype.dragEnd = function (evt) {
    if (!this.onDrag)
        return;
    // set end drag value.
    this.endDrag.X = evt.clientX;
    this.endDrag.Y = evt.clientY;
    // reset flag;
    this.onDrag = false;
};

mouseDragState.prototype.delta = function () {
    return { 
        X: (this.endDrag.X - this.beginDrag.X),
        Y: (this.endDrag.Y - this.beginDrag.Y) 
    };
};

mouseDragState.prototype.reset = function() {
    this.beginDrag.X = -1;
    this.beginDrag.Y = -1;

    this.endDrag.X = -1;
    this.endDrag.Y = -1;

    this.onDrag = false;
};

mouseDragState.prototype.isDrag = function() {
    return this.onDrag;
};

function designer() {
    // Private variables.
    this.objects = [];
    
    // Private Method(s).
    function Init() {
        console.log('designer is init.');
    }
};

designer.prototype.add = function() {
    var i, obj;
    if (!arguments || arguments.length <= 0) {
        //console.log('no object addd to designer.');
        return;
    }
    for (i in arguments) {
        obj = arguments[i];
        //console.log(obj);
        if (obj) {
            if (obj['length'] && obj.length > 0) {
                var j;
                for (j in obj)
                    this.objects.push(new designElement(obj[j]));
            }
            else {
                this.objects.push(new designElement(obj));
            } 
        }
    }
}

designer.prototype.Test = function() {
    this.Init();
};

function designElement(elem) {
    this.target = elem;
    this.dragState = new mouseDragState();

    function InitEvents(host) {
        //console.log(host);
        //console.log(host.target);
        if (host.target) {
            // Resize events.
            host.target.onresize = function () {
                //console.log(host.target, ' resize detected.');
            };
            // Mouse Events
            host.target.onclick = function (evt) {
                //console.log(host.target, ' click detected.');
                //console.log('event: ', evt);
            };
            host.target.onmouseenter = function (evt) {
                //console.log(host.target, ' mouseenter detected.');
                //console.log('event: ', evt);
            };
            host.target.onmousedown = function (evt) {
                //console.log(host.target, ' mousedown detected.');
                //console.log('event: ', evt);
                host.target.draggable = true;
                var pos = host.dragState.dragBegin(evt);
                host.target.offsetleft
            };
            host.target.onmousemove = function (evt) {
                //console.log(self.target, ' mousemove detected.');
                //console.log('event: ', evt);
                if (!host.dragState.isDrag())
                    return;
                host.dragState.dragMove(evt);
                var delta = host.dragState.delta();
                host.target.offsetLeft += delta.X;
                host.target.offsetTop += delta.Y;                
            };
            host.target.onmouseup = function (evt) {
                //console.log(self.target, ' mouseup detected.');
                //console.log('event: ', evt);
                host.dragState.dragEnd(evt);
                host.target.draggable = false;
                var delta = host.dragState.delta();
                host.target.offsetLeft += delta.X;
                host.target.offsetTop += delta.Y;
            };
            host.target.onmouseleave = function (evt) {
                //console.log(self.target, ' mouseleave detected.');
                //console.log('event: ', evt);
                host.dragState.reset();
            };
        }
    };

    InitEvents(this);
};

designElement.prototype.element = function () {
    return this.target;
};

;(function(){
    var dsgn = new designer();
    var objs = document.getElementsByClassName('design-object');
    dsgn.add(objs);

    /*
    var elems = document.getElementsByTagName('body'); // returns object list.
    if (elems && elems.length > 0)
    {
        var bodyElem = new designElement(elems[0]);
    };
    var elem = document.querys; // returns one object.
    */

    var dsgnObj = new designObject(objs[0]);
    var dsgnObj2 = new designObject(objs[1]);
    dsgnObj.left = 150;
    dsgnObj.width = 20;
    dsgnObj2.moveBy(20, 20);
})();