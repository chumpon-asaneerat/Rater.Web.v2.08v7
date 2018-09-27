/**
 * NList class. The array helper class.
 */
/*
class NList {
    constructor() {
        this._datasource = null;
        this._displayMember = '';
        this._mapCS = null;
        this._mapCI = null;
        this._items = null;
        this._input = '';
        this._caseSensitive = false;
    };

    __filter(elem) {
        if (!this._input || this._input.length <= 0) {
            //console.log('input is null or empty.');
            return elem;
        }
        else {

            let sIdx = (this._caseSensitive) ? 
                elem.indexOf(this._input) : 
                elem.toLowerCase().indexOf(this._input.toLowerCase());
            if (sIdx !== -1) {
                return elem;
            }
        }
    };

    __builditems() {
        this._mapCS = null;
        this._mapCI = null;
        this._items = null;
        if (!this._datasource) {
            //console.log('datasource not assigned.');
            return;
        }
        if (!(this._datasource instanceof Array)) {
            //console.log('datasource is not array.');
            return;
        }
        if (!this._displayMember) {
            //console.log('display member not assigned.');
            return;
        }
        let ds = this._datasource;
        let member = String(this._displayMember);

        this._mapCS = ds.map(elem => {
            let obj = elem[member];
            return obj;
        });
        this._mapCI = ds.map(elem => {
            let obj = elem[member];
            return obj.toLowerCase();
        });

        this.__applyFilter();
    };

    __applyFilter() {
        //console.log('apply filter.');
        this._items = null;
        if (!this._mapCS) {
            //console.log('map is null.');
            return;
        }
        let self = this;
        let map = this._mapCS;
        this._items = map.filter(elem => self.__filter(elem));
    };

    // find index in source array.
    indexOf(value) {
        if (this._caseSensitive) {
            if (!this._mapCS) return -1;
            return this._mapCS.indexOf(value);
        }
        else {
            if (!this._mapCI) return -1;
            return this._mapCI.indexOf(value.toLowerCase());
        }
        
    };

    // find item in source array.
    findItem(value) {
        if (!this._datasource) return null;
        let val, idx;
        if (this._caseSensitive) {
            if (!this._mapCS) return null;
            val = value;
            idx = this._mapCS.indexOf(val);
        }
        else {
            if (!this._mapCI) return null;
            val = value.toLowerCase();
            idx = this._mapCI.indexOf(val);
        }
        if (idx === -1) return null;
        return this.datasource[idx];
    };

    get datasource() { return this._datasource; }
    set datasource(value) {
        if (!this._datasource && value) {
            // assigned value to null datasource.
            this._datasource = value;
            this.__builditems();
        }
        else if (this._datasource && !value) {
            // assigned null to exist datasource.
            this._datasource = value;
            this.__builditems();
        }
        else if (this._datasource && value) {
            // both has value.
            this._datasource = value;
            if (this._displayMember && this._displayMember !== '') {
                this.__builditems();
            }
        }
        else {
            // both is null.
            this._datasource = value;
            // clear related arrays.
            this._mapCI = null;
            this._mapCS = null;            
            this._items = null;
        }
    };

    get displayMember() { return this._displayMember; };
    set displayMember(value) {
        if (this._displayMember !== value) {
            this._displayMember = value;
            this.__builditems();
        }
    };

    get caseSensitive() { return this._caseSensitive; };
    set caseSensitive(value) {
        if (this._caseSensitive != value) {
            this._caseSensitive = value;
            this.__builditems();
        }
    };

    get input() { return this._input; };
    set input(value) {
        if (this._input !== value) {
            this._input = value;
            this.__applyFilter();
        }
    };

    get items() { return this._items; };

    get selectedText() {
        if (!this._items || this._items.length <= 0) return null;
        //if (!this._input || this._input.length <= 0) return null;
        return this._items[0];
    };
};
*/

/**
 * NDOM class. The html dom helper class.
 */
/*
 class NDOM {
    //#region fluent method

    fluent() {
        // console.clear();
        // let props = Object.getPrototypeOf(this);
        // //console.log(props);
        // let propNames = Object.getOwnPropertyNames(props);
        // //console.log(propNames);
        // propNames.forEach((pName) => {
        //     let desc = Object.getOwnPropertyDescriptor(NDOM.prototype, pName);
            
        //     if (pName !== 'constructor' && desc && desc.set) {
        //         // this should show all set property of NDOM
        //         //console.log(pName + ' -> ' + desc);
        //     }
        //     else if (pName !== 'constructor' && desc && !desc.get && !desc.set) {
        //         // this should show all another method.
        //         //console.log(pName + ' -> ' + desc);
        //     }
        // });

        return new FluentDOM(this);
    };

    //#endregion 

    //#region color

    get color() {
        if (!this._elem) return null;
        var style = window.getComputedStyle(this._elem, null);
        return style.color;
    };
    set color(value) {
        if (!this._elem) return;
        this._elem.style.color = value;
    };

    //#endregion

    //#region background (background, backgroundColor, backgroundImage, positionX, positionY)

    get background() {
        if (!this._elem) return null;
        var style = window.getComputedStyle(this._elem, null);
        return style.background;
    };
    set background(value) {
        if (!this._elem) return;
        this._elem.style.background = value;
    };

    get backgroundColor() {
        if (!this._elem) return null;
        var style = window.getComputedStyle(this._elem, null);
        return style.backgroundColor;
    };
    set backgroundColor(value) {
        if (!this._elem) return;
        this._elem.style.backgroundColor = value;
    };

    get backgroundImage() {
        if (!this._elem) return null;
        var style = window.getComputedStyle(this._elem, null);
        return style.backgroundImage;
    };
    set backgroundImage(value) {
        if (!this._elem) return;
        this._elem.style.backgroundImage = value;
    };

    get backgroundPositionX() {
        if (!this._elem) return null;
        var style = window.getComputedStyle(this._elem, null);
        return style.backgroundPositionX;
    };
    set backgroundPositionX(value) {
        if (!this._elem) return;
        this._elem.style.backgroundPositionX = value;
    };

    get backgroundPositionY() {
        if (!this._elem) return null;
        var style = window.getComputedStyle(this._elem, null);
        return style.backgroundPositionY;
    };
    set backgroundPositionY(value) {
        if (!this._elem) return;
        this._elem.style.backgroundPositionY = value;
    };

    //#endregion
};

class FluentDOM {
    //#region constructor

    constructor(dom) {
        this._dom = dom;
    };

    //#endregion

    //#region Class manupulation functions

    addClass(...classNames) {
        if (this._dom && this._dom.element) {
            this._dom.element.classList.add(...classNames);
        }
        return this;
    };

    removeClass(...classNames) {
        if (this._dom && this._dom.element) {
            this._dom.element.classList.remove(...classNames);
        }
        return this;
    };

    toggleClass(className, force) {
        if (this._dom) {
            this._dom.toggleClass(className, force);
        }
        return this;
    };

    replaceClass(oldClassName, newClassName) {
        if (this._dom) {
            this._dom.replaceClass(oldClassName, newClassName);
        }
        return this;
    };

    //#endregion

    //#region Style (general) function.

    style(name, value) {
        if (this._dom && this._dom.element) {
            this._dom.element.style[name] = value;
        }
        return this;
    };

    //#endregion

    //#region margin related functions.

    margin(value) {
        if (this._dom) {
            this._dom.margin = value;
        }
        return this;
    };

    marginLeft(value) {
        if (this._dom) {
            this._dom.marginLeft = value;
        }
        return this;
    };

    marginTop(value) {
        if (this._dom) {
            this._dom.marginTop = value;
        }
        return this;
    };

    marginRight(value) {
        if (this._dom) {
            this._dom.marginRight = value;
        }
        return this;
    };

    marginBottom(value) {
        if (this._dom) {
            this._dom.marginBottom = value;
        }
        return this;
    };

    //#endregion

    //#region padding related functions.

    padding(value) {
        if (this._dom) {
            this._dom.padding = value;
        }
        return this;
    };

    paddingLeft(value) {
        if (this._dom) {
            this._dom.paddingLeft = value;
        }
        return this;
    };

    paddingTop(value) {
        if (this._dom) {
            this._dom.paddingTop = value;
        }
        return this;
    };

    paddingRight(value) {
        if (this._dom) {
            this._dom.paddingRight = value;
        }
        return this;
    };

    paddingBottom(value) {
        if (this._dom) {
            this._dom.paddingBottom = value;
        }
        return this;
    };

    //#endregion

    //#region color related functions.

    color(value) {
        if (this._dom) {
            this._dom.color = value;
        }
        return this;
    };

    //#endregion

    //#region background related functions.

    background(value) {
        if (this._dom) {
            this._dom.background = value;
        }
        return this;
    };

    backgroundColor(value) {
        if (this._dom) {
            this._dom.backgroundColor = value;
        }
        return this;
    };

    backgroundImage(value) {
        if (this._dom) {
            this._dom.backgroundImage = value;
        }
        return this;
    };

    backgroundPositionX(value) {
        if (this._dom) {
            this._dom.backgroundPositionX = value;
        }
        return this;
    };

    backgroundPositionY(value) {
        if (this._dom) {
            this._dom.backgroundPositionY = value;
        }
        return this;
    };

    //#endregion

    //#region public properties

    get element() { return (this._dom) ? this._dom.element : null; };
    get dom() { return this._dom; };

    //#endregion
};
*/