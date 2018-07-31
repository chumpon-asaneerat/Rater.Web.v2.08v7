/**
 * Constructor.
 * @param {Object} ide 
 * @param {String} designerId
 */
function SlideDesigner(ide, designerId) {
    this.IDE = ide;
    this.Id = designerId;

    this.__selectedObject = null;

    var self = this;
    var clickHandler = function (evt) {
        var el = evt.target;
        if (nlib.dom.hasClass(el, 'design-object')) {
            self.select(el);
        }
        else {
            self.deselect();
        }
    };

    var dsgn = document.getElementById(this.Id);
    nlib.dom.addEvent(dsgn, 'click', clickHandler);
};

SlideDesigner.prototype.select = function (el) {
    if (this.__selectedObject !== null) {
        this.deselect();
    }

    this.__selectedObject = el;
    
    var self = this;

    function createHotspot(hsClass, hsId) {
        var hs = nlib.dom.createElement('div');
        hs.id = self.__selectedObject.id + '_' + hsId;
        nlib.dom.addClass(hs, hsClass);
        nlib.dom.addEvent(hs, 'mousedown');
        nlib.dom.addEvent(hs, 'mousemove');
        nlib.dom.addEvent(hs, 'mouseup');
        self.__selectedObject.appendChild(hs);
        return hs;
    }
    var hotspots = {};
    hotspots.hsnw = createHotspot('hs-nw', 'hsnw');
    hotspots.hsne = createHotspot('hs-ne', 'hsnw');
    hotspots.hssw = createHotspot('hs-sw', 'hsnw');
    hotspots.hsse = createHotspot('hs-se', 'hsnw');
    hotspots.hsselect = createHotspot('hs-select', 'hsselect');

    this.IDE.propertyEditor.refresh();
};

SlideDesigner.prototype.deselect = function () {
    if (this.__selectedObject) {
        var self = this;
        // clear all hot spot and event handlers.
        function removeHotspot(hsId) {
            var id = self.__selectedObject.id + '_' + hsId;
            var hs = document.getElementById(id);
            nlib.dom.removeEvent(hs, 'mousedown');
            nlib.dom.removeEvent(hs, 'mousemove');
            nlib.dom.removeEvent(hs, 'mouseup');
            self.__selectedObject.removeChild(hs);
        }

        removeHotspot('hsnw');
        removeHotspot('hsnw');
        removeHotspot('hsnw');
        removeHotspot('hsnw');
        removeHotspot('hsselect');
    }
    this.__selectedObject = null;
    this.IDE.propertyEditor.refresh();
};

SlideDesigner.prototype.addText = function(tagName, id, text) {
    var dsgn = document.getElementById(this.Id);    
    var el = document.createElement(tagName);
    el.id = id;
    el.setAttribute('contenteditable', true);
    
    el.innerHTML = (text) ? text : '';
    nlib.dom.addClass(el, 'design-object');
    el.style.left = '50px';
    el.style.top = '50px';
    //el.style.width = 'auto';
    //el.style.height = 'auto';
    dsgn.appendChild(el);
    return el;
};

SlideDesigner.prototype.addImage = function (id, url) {
    var dsgn = document.getElementById(this.Id);
    var el = document.createElement('div');
    el.id = id;
    el.style.backgroundImage = (url) ? 'url("' + url + '")' : '';
    el.style.backgroundRepeat = 'no-repeat';
    el.style.backgroundPosition = 'center';
    //el.style.backgroundSize = 'cover';
    el.style.backgroundSize = '100% 100%';

    nlib.dom.addClass(el, 'design-object');
    //el.style.background = '#EEEEEE';
    el.style.left = '50px';
    el.style.top = '50px';
    if (url) {
        //el.style.width = 'auto';
        //el.style.height = 'auto';
        el.style.width = '100px';
        el.style.height = '100px';
    }
    else {
        el.style.width = '100px';
        el.style.height = '100px';
    }
    dsgn.appendChild(el);
    return el;
};

/**
 * Constructor.
 * @param {Object} ide
 * @param {String} proeprtyEditorId
 */
function PropertyEditor(ide, proeprtyEditorId) {
    this.IDE = ide;
    this.Id = proeprtyEditorId;
};

PropertyEditor.prototype.initPropertyGroups = function () {
    var self = this;

    function createPropertyGroup(caption, id) {
        var parentId = 'accordion';
        var panel = document.createElement('div');
        panel.className = 'panel panel-default';
        panel['id'] = parentId;

        var headerDiv = document.createElement('div');
        headerDiv.className = 'panel-heading';

        var headerTitle = document.createElement('h6');
        headerTitle.className = 'panel-title';
        headerTitle.innerHTML = '<a data-toggle = "collapse" data-parent = "#' + parentId + '" href="#' + id + '">' + caption + '</a>'

        headerDiv.appendChild(headerTitle);

        var contentDiv = document.createElement('div');
        contentDiv.className = "panel-collapse collapse in";
        contentDiv['id'] = id;

        panel.appendChild(headerDiv);
        panel.appendChild(contentDiv);

        return panel;
    }
    
    function createTextStyleEditor(caption, styleName, value) {
        // Caption
        var styleEditDiv = document.createElement('div');
        styleEditDiv.className = 'ide-style-property';
        var styleLabel = document.createElement('label');
        styleLabel.innerHTML = caption + ': &nbsp;'
        styleEditDiv.appendChild(styleLabel);
        // Input
        var styleInput = document.createElement('input');
        styleInput.className = 'style-editor'
        styleInput.attributes['element-style'] = styleName;
        styleInput.attributes['type'] = 'text';
        styleInput.attributes['value'] = value;
        styleEditDiv.appendChild(styleInput);

        // Bind Handler
        function TextInputChangedHandler(evt) {
            //console.log('input changed.');
            var selectedObject = self.IDE.designer.__selectedObject
            if (selectedObject !== null) {
                var elStyle = styleInput.attributes['element-style'];
                selectedObject.style[elStyle] = styleInput.value;
                /*
                if (selectedObject.style[elStyle] === 'untitled' || 
                    selectedObject.style[elStyle] === null ||
                    selectedObject.style[elStyle] === '') {
                    selectedObject[elStyle] = styleInput.value;
                }
                */
            }
            else {
                console.log('no seleccted object.');
            }
        }

        styleInput.addEventListener('input', TextInputChangedHandler);

        return styleEditDiv;
    };

    var container = document.getElementById(this.Id);
    container.innerHTML = ''; // clear elements.

    // Font
    var fontGroup = createPropertyGroup('Font', 'fontGroup');
    container.appendChild(fontGroup);
    var content1 = document.getElementById('fontGroup');
    content1.appendChild(createTextStyleEditor('Family', 'fontFamily', ''));
    content1.appendChild(createTextStyleEditor('Size', 'fontSize', ''));
    content1.appendChild(createTextStyleEditor('Color', 'color', ''));

    // Background
    var bgGroup = createPropertyGroup('Background', 'bgGroup');
    container.appendChild(bgGroup);
    var content2 = document.getElementById('bgGroup');
    content2.appendChild(createTextStyleEditor('Color', 'backgroundColor', ''));
    content2.appendChild(createTextStyleEditor('Image', 'backgroundImage', ''));
    content2.appendChild(createTextStyleEditor('Position', 'backgroundPosition', ''));
    content2.appendChild(createTextStyleEditor('Size', 'backgroundSize', ''));
    content2.appendChild(createTextStyleEditor('Repeat', 'backgroundRepeat', ''));
    
    // Position and Size
    var positionGroup = createPropertyGroup('Position & Size', 'positionGroup');
    container.appendChild(positionGroup);
    var content3 = document.getElementById('positionGroup');
    content3.appendChild(createTextStyleEditor('Left', 'left', ''));
    content3.appendChild(createTextStyleEditor('Top', 'top', ''));
    content3.appendChild(createTextStyleEditor('Right', 'right', ''));
    content3.appendChild(createTextStyleEditor('Bottom', 'bottom', ''));
    content3.appendChild(createTextStyleEditor('Width', 'width', ''));
    content3.appendChild(createTextStyleEditor('Height', 'height', ''));

    // Image
    /*
    var imgGroup = createPropertyGroup('Image', 'imgGroup');
    container.appendChild(imgGroup);
    var content4 = document.getElementById('imgGroup');
    content4.appendChild(createTextStyleEditor('Source', 'src', ''));
    */
    
    // Margin
    var marginGroup = createPropertyGroup('Margin', 'marginGroup');
    container.appendChild(marginGroup);
    var content8 = document.getElementById('marginGroup');
    content8.appendChild(createTextStyleEditor('Left', 'marginLeft', ''));
    content8.appendChild(createTextStyleEditor('Top', 'marginTop', ''));
    content8.appendChild(createTextStyleEditor('Right', 'marginRight', ''));
    content8.appendChild(createTextStyleEditor('Bottom', 'marginBottom', ''));

    // Padding
    var paddingGroup = createPropertyGroup('Padding', 'paddingGroup');
    container.appendChild(paddingGroup);
    var content9 = document.getElementById('paddingGroup');
    content9.appendChild(createTextStyleEditor('Left', 'paddingLeft', ''));
    content9.appendChild(createTextStyleEditor('Top', 'paddingTop', ''));
    content9.appendChild(createTextStyleEditor('Right', 'paddingRight', ''));
    content9.appendChild(createTextStyleEditor('Bottom', 'paddingBottom', ''));
};

PropertyEditor.prototype.refresh = function() {
    var selectObject = this.IDE.designer.__selectedObject;

    var styleInputs = document.getElementsByClassName('style-editor');

    for (var i = 0; i < styleInputs.length; ++i) {
        var styleName = styleInputs[i].attributes['element-style'];
        if (selectObject !== null) {
            /*
            if (selectObject[styleName] === 'untitled')
                styleInputs[i].value = selectObject.style[styleName];
            else styleInputs[i].value = selectObject[styleName];
            */
            styleInputs[i].value = selectObject.style[styleName];
        }
        else styleInputs[i].value = '';
    }
};

/**
 * Construcotr.
 * @param {String} designerId
 * @param {String} proeprtyEditorId
 * @param {String} toolboxId
 */
function SlideIDE(designerId, proeprtyEditorId, toolboxId) {
    this.designer = new SlideDesigner(this, designerId);
    this.propertyEditor = new PropertyEditor(this, proeprtyEditorId);
    this.propertyEditor.initPropertyGroups();
};

;(function() {
})();