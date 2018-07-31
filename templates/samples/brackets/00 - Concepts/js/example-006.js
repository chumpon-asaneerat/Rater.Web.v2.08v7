function floatWindow (elem) {
    var element = elem;
    var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
    var resizer = null;

    //#region Drag Move Panel
    /**
     * Drag Move Panel.
     * 
     */
    function initDragElement() {
        if (element.firstElementChild) {
            /* if present, the header is where you move the DIV from:*/
            element.firstElementChild.onmousedown = dragMouseDown;
        } 
        else {
            /* otherwise, move the DIV from anywhere inside the DIV:*/
            element.onmousedown = dragMouseDown;
        }
    };

    function dragMouseDown (e) {
        e = e || window.event;
        // get the mouse cursor position at startup:
        pos3 = e.clientX;
        pos4 = e.clientY;
        document.onmouseup = closeDragElement;
        // call a function whenever the cursor moves:
        document.onmousemove = elementDrag;
        e.preventDefault();
        return false;
    };

    function elementDrag (e) {
        e = e || window.event;
        // calculate the new cursor position:
        pos1 = pos3 - e.clientX;
        pos2 = pos4 - e.clientY;
        pos3 = e.clientX;
        pos4 = e.clientY;
        // set the element's new position:
        element.style.top = (element.offsetTop - pos2) + "px";
        element.style.left = (element.offsetLeft - pos1) + "px";
        e.preventDefault();
        return false;
    };

    function closeDragElement() {
        /* stop moving when mouse button is released:*/
        document.onmouseup = null;
        document.onmousemove = null;
    };
    //#endregion

    //#region Resizer
    /**
     * Resizer.
     * 
     */
    function initResizer() {
        resizer = document.createElement('div');
        resizer.style.width = '5px';
        resizer.style.height = '5px';
        resizer.style.background = 'dimgray';
        resizer.style.position = 'absolute';
        resizer.style.right = 0;
        resizer.style.bottom = 0;
        resizer.style.cursor = 'se-resize';
        //Append Child to Element
        element.appendChild(resizer);
        //box function onmousemove
        resizer.addEventListener('mousedown', initResize, false);
    };
    //Window funtion mousemove & mouseup
    function initResize() {
        window.addEventListener('mousemove', Resize, false);
        window.addEventListener('mouseup', stopResize, false);
    };
    //resize the element
    function Resize(e) {
        element.style.width = (e.clientX - element.offsetLeft) + 'px';
        element.style.height = (e.clientY - element.offsetTop) + 'px';
        resizeContent();
        e.preventDefault();
        return false;
    };
    //on mouseup remove windows functions mousemove & mouseup
    function stopResize(e) {
        window.removeEventListener('mousemove', Resize, false);
        window.removeEventListener('mouseup', stopResize, false);
        resizeContent();
        e.preventDefault();
        return false;
    };

    function resizeContent() {
        var paddingWd = 4;
        var paddingHt = 8;
        var maxWd = element.offsetWidth;
        var maxHt = element.offsetHeight;
        //console.log('Parent Ht:', maxHt);
        var panelHeader = element.getElementsByClassName('float-panel-header')[0];
        var panelHdrHt = panelHeader.offsetHeight;
        //console.log('Panel Header Ht:', panelHdrHt);
        var tabHeader = element.getElementsByClassName('n-tab-header')[0];
        var tabHdrHt = tabHeader.offsetHeight;
        //console.log('Tab Header Ht:', tabHdrHt);
        var tabContent = element.getElementsByClassName('n-tab-content')[0];
        var wd = (maxWd - paddingWd);
        var ht = (maxHt - panelHdrHt - tabHdrHt - paddingHt);
        //console.log('Content Wd:', wd);
        //console.log('Content Ht:', ht);
        tabContent.style.width = wd + 'px';
        tabContent.style.height = ht + 'px';
        //console.log(tabContent.style.width);
        //console.log(tabContent.style.height);
    };
    //#endregion Resizer

    initDragElement(this.element);
    initResizer();
};

;(function () {
    var elements = document.getElementsByClassName('float-panel');
    for (var i = 0; i < elements.length; ++i) {
        new floatWindow(elements[i]);
    }
})();