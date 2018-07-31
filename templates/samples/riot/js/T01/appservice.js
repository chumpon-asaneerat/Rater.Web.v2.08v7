/*
class UID {
    static newId() {
        return Math.random().toString(36).substring(2, 15) +
            Math.random().toString(36).substring(2, 15);
    }    
}

class Delegate {
    constructor(uid) {
        this._uid = uid;
        this._fn = null;
    }

    get uid() { return this._uid; }
    get fn() { return this._fn; }

    static create(callback) {
        let result = new Delegate(UID.newId());
        result._fn = callback;
        return result;
    }
}

class EventQueue {
    constructor() {
        this._events = [];
    }

    indexOf(value) {
        if (value && value instanceof Delegate) {
            return this._events.map((elem) => { return elem.uid; }).indexOf(value.uid);
        }
        else return -1;
    }

    add(value) {
        if (value && value instanceof Delegate) {
            let index = this.indexOf(value);
            if (index === -1) {                
                this._events.push(value); // append.
            }
            else this._events[index] = value; // replace.
        }
        else {
            console.log('The value is null or is not instance of Delegate class.');
        }
    }

    remove(value) {
        if (value && value instanceof Delegate) {
            let index = this.indexOf(value);
            if (index >= 0 && index < this._events.length) {
                this._events.splice(index, 1); // delete.
            }
        }
        else {
            console.log('The value is null or is not instance of Delegate class.');
        }
    }

    invoke(sender, eventData) {
        this._events.forEach((evt) => {
            evt.fn(sender, eventData) }
        );
    }
}
*/

class EventQueue {
    constructor() {
        this._events = [];
    }

    /* public methods. */
    indexOf(value) {
        if (value && value instanceof Function) {
            return this._events.indexOf(value);
        }
        else return -1;
    }

    add(value) {
        if (value && value instanceof Function) {
            let index = this.indexOf(value);
            if (index === -1) {
                this._events.push(value); // append.
            }
            else this._events[index] = value; // replace.
        }
        else {
            console.log('The value is null or is not instance of Function.');
        }
    }

    remove(value) {
        if (value && value instanceof Function) {
            let index = this.indexOf(value);
            if (index >= 0 && index < this._events.length) {
                this._events.splice(index, 1); // delete.
            }
        }
        else {
            console.log('The value is null or is not instance of Function.');
        }
    }

    invoke(sender, eventData) {
        this._events.forEach((evt) => {
            evt(sender, eventData) }
        );
    }
}

class DataSource {
    constructor() {
        this._datasource = null;
        this._selectedIndex = -1;
        this._datasourcechanged = new EventQueue();
        this._selectedindexchanged = new EventQueue();
    }

    changeLanguage(langId) {
        if (this._datasource) {
            let index = this._datasource.map((item) => { return item.langId; }).indexOf(langId);
            this.selectedIndex = index;
        }
    }

    /* public properties. */
    get datasource() { return this._datasource; }
    set datasource(value) {
        if (value && (value instanceof Array)) {
            let oVal = this._datasource
            let nVal = value;
            this._datasource = value;
            this._datasourcechanged.invoke(this, { "oldValue": oVal, "newValue": nVal })
            if (this._datasource.length > 0) {
                this.selectedIndex = 0;
            }
            else {
                this.selectedIndex = -1;
            }
        }
        else {
            console.log('datasource is null or is not instance of array.');
        }
    }

    get selectedIndex() {
        return this._selectedIndex;
    }
    set selectedIndex(value) {
        if (!this._datasource || 
            value < 0 || value >= this._datasource.length) {

            let oVal = this._selectedIndex
            let nVal = -1;
            this._selectedIndex = -1;
            this._selectedindexchanged.invoke(this, { "oldValue": oVal, "newValue": nVal })
        }
        else {
            let oVal = this._selectedIndex
            let nVal = value;
            this._selectedIndex = value;
            this._selectedindexchanged.invoke(this, { "oldValue": oVal, "newValue": nVal })

        }
    }

    get selectedObject() {
        if (!this._datasource ||
            this._selectedIndex < 0 || this._selectedIndex >= this._datasource.length) {
            return null;
        }
        else {
            return this._datasource[this._selectedIndex];
        }
    }

    /* event handlers. */
    get datasourcechanged() { return this._datasourcechanged; }
    get selectedindexchanged() { return this._selectedindexchanged; }
}

class App {
    constructor() {
        this._title = "My Title"
        this._propertychanged = new EventQueue();
        this._languages = new DataSource();
    }

    get title() { return this._title; }
    set title(value) { 
        this._title = value;
        this._propertychanged.invoke(this, { name: 'title' });
    }

    generateTitle() {
        this.title = 'Current Time: ' + Date.now().toString();
    }    

    get languages() { return this._languages; }
    get propertychanged() { return this._propertychanged; }
}

;(function() {
    // set global app variable in window.
    window.app = window.app || new App();

    riot.compile(function() {
        var tags = riot.mount('*');
    });

    //app.languages.datasource = getlanguages();
})();