//#region DOMEvents class
/*
class DOMEvents {
    constructor() { 
    };

    addEvent (selector, evtName, callback) {
        $(selector).on(evtName, callback);
    };

    listen() {
        this.addEvent(window, 'resize', (e) => {
            console.log(e);
        });
    };
};

; (function () {
    window.evts = window.evts || new DOMEvents();
    window.evts.listen();
})();
*/
//#endregion

//#region RiotTrack class
/*
class RiotTrack {
    constructor(riotTag) {
        this.__tag = riotTag;

        console.log(this.__tag);
    };

    get tag() {
        return this.__tag;
    };
};
*/
//#endregion

//#region LocalStorage class

class LocalStorage {
    constructor() {
        this._name = ''
        this._data = null
        this._ttl = 0;
    };

    //-- public methods.
    checkExist() {
        if (!this.data) {
            this.data = this.getDefault();
            this.save();
        }
    };

    getDefault() {
        return {}
    };

    save() {
        if (!this._name) return; // no name specificed.
        let ttl = (this._ttl) ? this._ttl : 0;
        nlib.storage.set(this._name, this._data, { TTL: ttl }); // 1 days.
    };

    load() {
        if (!this._name) return; // no name specificed.
        let ttl = (this._ttl) ? this._ttl : 0;
        this._data = nlib.storage.get(this._name);
    };

    //-- public properties.
    get name() { return this._name; };
    set name(value) { this._name = value; };

    get data() { return this._data; };
    set data(value) { this._data = value; };

    get ttl() { return this._ttl; };
    set ttl(value) { this._ttl = value; };
};

//#endregion

//#region UserPerference class

class UserPerference extends LocalStorage {
    constructor() {
        super();
        this.name = 'uperf'
        this.ttl = 0;
        this._prefchanged = null;
        this.load();
        this.checkExist();
    };

    //-- public methods.
    getDefault() {
        return {
            langId: 'EN'
        }
    };

    load() {
        super.load();
    };

    save() {
        super.save();
    };

    //-- public properties.
    get langId() {
        if (!this.data) this.checkExist();
        return this.data.langId;
    };
    set langId(value) {
        if (!this.data) this.checkExist();
        this.data.langId = value;
    };
};

//#endregion

//#region ClientAccess class

class ClientAccess {
    constructor() {
        this._users = [];
        this._current = null;
        this.__userListChanged = new EventHandler();
        this._currentUserChanged = new EventHandler();
    };

    getUsers(login) {
        let self = this;
        if (!login.langId) { 
            login.langId = 'EN'; // Or should be current language.
        }
        let fn = api.secure.getUsers(login);
        $.when(fn).then((r) => {
            if (!r || !r.errors) { 
                //console.log('No data returns.'); 
            }
            if (r.errors.hasError) { 
                //console.log(r.errors); 
            }
            if (!r.data || r.data.length <= 0) { 
                //console.log('No user found.'); 
            }
            self._users = r.data;
            self.__userListChanged.invoke(self, EventArgs.Empty);
        });
    };

    getCurrentUser(langId) {
        let fn = api.secure.getCurrentUser({ langId: langId });
        $.when(fn).then((r) => {
            if (r && !r.errors.hasError && r.data && r.data.length > 0) {
                this._current = r.data[0];
            }
            else {
                this._current = null;
            }
            this._currentUserChanged.invoke(this, EventArgs.Empty);
        });
    };

    clear() {
        this._users = [];
    }

    signIn(user) {
        this.clear();
        let fn = api.secure.signIn(user);
        $.when(fn).then((r) => {
            if (r && !r.errors.hasError) {                
                nlib.nav.gotoUrl(r.url);
            }
        });
    };

    signOut() {
        this.clear();
        let fn = api.secure.signOut();
        $.when(fn).then((r) => {
            if (r && r.url) {
                nlib.nav.gotoUrl(r.url);
            }
            else {
                nlib.nav.gotoUrl('/');
            }
        });
    };

    register(customer) {
        this.clear();
        let fn = api.secure.register(customer);
        $.when(fn).then((r) => {
            if (r && !r.errors.hasError) {
                // goto home.
                nlib.nav.gotoUrl('/');
            }
            else {
                // something error.
            }
        });
    };

    get users() {
        return this._users;
    };

    get current() {
        return this._current;
    };

    get currentUserName() {
        if (!this._current || !this._current.FullNameNative) {
            return '';
        }
        else {
            return this._current.FullNameNative;
        }
    };

    get userListChanged() {
        return this.__userListChanged;
    };

    get currentUserChanged() {
        return this._currentUserChanged;
    };
};

; (function () {
    //console.log('Init client access service...');
    window.secure = window.secure || new ClientAccess();
})();

//#endregion

//#region LanguageService class

class LanguageService {
    constructor() {
        this._pref = new UserPerference();
        this._pref.load(); // load once.
        this._current = null;
        this._languages = [];
        this._languageListChanged = new EventHandler();
        this._currentChanged = new EventHandler();
    };

    change(langId) {
        if (!langId || langId.length < 2) return; // invalid.
        let langs = this._languages.map((item) => { return item.langId.toUpperCase() });
        let index = langs.indexOf(langId.toUpperCase());
        if (index === -1) return; // not found.
        let newVal = this._languages[index];
        if (newVal) {
            if (this._current) {
                if (this._current.langId.toUpperCase() !== newVal.langId.toUpperCase()) {
                    // LangId changed.
                    this._current = newVal;
                    // keep to perf.
                    this._pref.langId = this._current.langId.toUpperCase();
                    this._pref.save();
                    // get current user.
                    secure.getCurrentUser(this._current.langId.toUpperCase());
                    // raise event.
                    this._currentChanged.invoke(this, EventArgs.Empty);
                }
            }
            else {
                // no current so set new one.
                this._current = newVal;
                // keep to perf.
                this._pref.langId = this._current.langId.toUpperCase();
                this._pref.save();
                // get current user.
                secure.getCurrentUser(this._current.langId.toUpperCase());
                // raise event.
                this._currentChanged.invoke(this, EventArgs.Empty);
            }
        }
    };

    getLanguages() {
        let self = this;
        let fn = api.lang.getLanguages({ enabled:true });
        $.when(fn).then((r) => {
            if (!r || !r.errors) {
                //console.log('No data returns.'); 
            }
            if (r.errors.hasError) {
                //console.log(r.errors); 
            }
            if (!r.data || r.data.length <= 0) {
                //console.log('No user found.'); 
            }
            self._languages = r.data;
            self._languageListChanged.invoke(self, EventArgs.Empty);
            self.change(self._pref.langId); // set langId from preference.
        });
    };

    get languages() {
        return this._languages;
    };

    get current() {
        return this._current;
    }

    get langId() {
        if (!this._current || !this._current.langId) {
            return null;
        }
        else {
            return this._current.langId.toUpperCase();
        }
    }

    get languageListChanged() {
        return this._languageListChanged;
    };

    get currentChanged() {
        return this._currentChanged;
    };
};

; (function () {
    //console.log('Init language service...');
    window.lang = window.lang || new LanguageService();
    lang.getLanguages();
})();

//#endregion

//#region RaterPage

class RaterPage {
    constructor() {
        this._modelML = { };
        this._modelLoaded = new EventHandler();

        let self = this;
        let onLanguageChanted = (sender, evtData) => {
            let LId = lang.langId;
            let fnX = api.model.getModelNames();
            $.when(fnX).then((r) => {
                if (r.data) {
                    let modelTypes = r.data;
                    let fns = []
                    modelTypes.forEach(type => {
                        let data = { langId: LId, modelType: type };
                        let fn = api.model.getModel(data);
                        fns.push(fn);
                    });

                    $.when.all(fns).then(promiseRs => {
                        let index = 0;
                        promiseRs.forEach(promiseR => {
                            let r = promiseR[0].data;
                            let modelType = modelTypes[index];
                            self.update(LId, modelType, r);
                            ++index;
                        });
                        //console.log('all model loaded.');
                        // raise events.
                        self._modelLoaded.invoke(this, EventArgs.Empty);
                    });
                }
                else {
                    console.log('No models.');
                }
            });
        };

        lang.currentChanged.add(onLanguageChanted);
    };

    update(langId, modelType, obj) {
        //console.log(modelType, obj);
        let LId = langId.toUpperCase();     
        this._modelML[LId] = this._modelML[LId] || { langId: LId };
        this._modelML[LId][modelType] = this._modelML[LId][modelType] || obj;
    };

    get models() {
        return this._modelML;
    };

    get model() {
        if (!lang.current || !lang.langId)
            return null;
        let result = this._modelML[lang.langId];
        //console.log(result);
        return result;
    };

    get modelLoaded() {
        return this._modelLoaded;
    };
};

; (function () {
    //console.log('Init language service...');
    window.page = window.page || new RaterPage();
})();

//#endregion

//#region BS4Modal class

class BS4Modal {
    constructor(id) {
        this._id = id;
        let self = this;
        this._handlers = {
            onHide: (e) => {
                //console.log('detected modal hide event.');
                let $modal = $(self._id);
                $modal.unbind('hide.bs.modal'); // unbind hide handler
            }
        };
    };

    show(options) {
        //console.log('manual show dialog.');        
        let $modal = $(this._id);
        let opts = options || {};
        // bind/rebind hide handler.
        $modal.on('hide.bs.modal', this._handlers.onHide);
        // show dialog
        $modal.modal(opts).modal('show');
    };
    
    hide() { 
        //console.log('manual hide dialog.');
        let $modal = $(this._id);
        // hide dialog.
        $modal.modal('hide');
    };

    get id() {
        return this.id;
    };
};

//#endregion

//#region BS4ToolTip class

class BS4ToolTip {
    constructor() {
    };

    show(selector, msg, placement, timeout) {
        let $ctrl = $(selector);
        if (!$ctrl) return; // No control not found.
        if (!msg || msg.length <= 0) return; // No message.

        let options = {
            trigger: 'manual',
            placement: (placement) ? placement : 'top',
            title: msg
        };

        let attr = $ctrl.attr('rel');
        if (!attr) {
            $ctrl.attr('rel', 'tooltip');
        }

        $ctrl.tooltip(options).tooltip('show');        

        let tout = (timeout) ? timeout : 3000;
        setTimeout(() => {
            //$ctrl.tooltip('hide');
            $ctrl.tooltip('dispose');
        }, tout);
    };
};

//#endregion

//#region BS4Alert class

class BS4Alert extends BS4ToolTip {
    constructor() {
        super();
        this._selector = '[role="alert"]';
    };

    show(msg, placement, timeout) {
        let $ctrl = $(this._selector);

        $ctrl.removeClass("alert-primary");
        $ctrl.addClass("alert-danger");

        let pment = (placement) ? placement : 'bottom';
        let tout = (timeout) ? timeout : 3000;
        super.show($ctrl, msg, pment, tout);

        setTimeout(() => {
            $ctrl.removeClass("alert-danger");
            $ctrl.addClass("alert-primary");
        }, tout);
    };
};

//#endregion

class ClientApp {
    constructor() {

    };
};

; (function () {
    //console.log('Init app core...');
    window.app = window.app || new ClientApp();
 })();
