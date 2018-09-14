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

//#region QSetModelLoader

class QSetModelLoader {
    constructor() {
        let self = this;
        this._models = null;
        this._model = null;

        this._ModelChanged = new EventHandler();

        let oncurrentUserChanged = (sender, evtData) => {
            self.loadmodels();
        };
        secure.currentUserChanged.add(oncurrentUserChanged);

        let onLanguageChanged = (sender, evtData) => {
            self.loadmodels();
        };
        lang.currentChanged.add(onLanguageChanged);
    };

    raiseModelChangedEvent() {
        if (this._ModelChanged) {
            this._ModelChanged.invoke(this, EventArgs.Empty);
        }
    };

    loadmodels(refresh) {
        let self = this;
        if (!secure.current) {
            self._models = null;
            self._model = null;
            return;
        }
        if (!self._models || refresh) {
            // not load or required refresh.
            self._models = null;
            self._model = null;

            let param = {
                CustomerId: secure.current.CustomerId
            };

            let fn = api.report.getCustomerQSets(param);
            $.when(fn).then((r) => {
                if (!r || !r.errors) {
                    console.log('No data returns.');
                }
                if (r.errors.hasError) {
                    console.log(r.errors);
                }
                if (!r.data || r.data.length <= 0) {
                    console.log('No data found.');
                }
                else {
                    //console.log(r.data);
                    self._models = r.data;
                }
                self.loadmodel();
            });
        }
        else {
            self.loadmodel();
        }
    };

    loadmodel() {
        let lastModel = this._model;

        //console.log('load qset model.');
        if (!lang) {
            console.log('lang obj is null.');
        }

        let langId = lang.langId;
        //console.log(langId);
        if (!langId) {
            //console.log('current language not set.');
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }

        if (!this._models) {
            console.log('Qset Models is null.');
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }

        // find model that match current language.
        let langmaps = this._models.map((item) => { return item.LangId; });
        let langIndex = langmaps.indexOf(langId);
        if (langIndex === -1) {
            console.log('No model match language. LangId:', langId);
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }
        let model = this._models[langIndex];
        if (!model) {
            console.log('Qset Model object is null.');
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }
        this._model = model;

        if (lastModel != this._model) {
            this.raiseModelChangedEvent();
        }            
    };

    get model() {
        return this._model;
    };

    get ModelChanged() {
        return this._ModelChanged
    };
};

//#endregion

//#region OrgModelLoader

class OrgModelLoader {
    constructor() {
        let self = this;
        this._models = null;
        this._model = null;

        this._ModelChanged = new EventHandler();

        let oncurrentUserChanged = (sender, evtData) => {
            self.loadmodels();
        };
        secure.currentUserChanged.add(oncurrentUserChanged);

        let onLanguageChanged = (sender, evtData) => {
            self.loadmodels();
        };
        lang.currentChanged.add(onLanguageChanged);
    };

    raiseModelChangedEvent() {
        if (this._ModelChanged) {
            this._ModelChanged.invoke(this, EventArgs.Empty);
        }
    };

    loadmodels(refresh) {
        let self = this;
        if (!secure.current) {
            self._models = null;
            self._model = null;
            return;
        }
        if (!self._models || refresh) {
            // not load or required refresh.
            self._models = null;
            self._model = null;

            let param = {
                CustomerId: secure.current.CustomerId
            };

            let fn = api.report.getCustomerOrgs(param);
            $.when(fn).then((r) => {
                if (!r || !r.errors) {
                    console.log('No data returns.');
                }
                if (r.errors.hasError) {
                    console.log(r.errors);
                }
                if (!r.data || r.data.length <= 0) {
                    console.log('No data found.');
                }
                else {
                    //console.log(r.data);
                    self._models = r.data;
                }
                self.loadmodel();
            });
        }
        else {
            self.loadmodel();
        }
    };

    loadmodel() {
        let lastModel = this._model;

        //console.log('load org model.');
        if (!lang) {
            console.log('lang obj is null.');
        }

        let langId = lang.langId;
        //console.log(langId);
        if (!langId) {
            //console.log('current language not set.');
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }

        if (!this._models) {
            console.log('Org Models is null.');
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }
        // find model that match current language.
        let langmaps = this._models.map((item) => { return item.LangId; });
        let langIndex = langmaps.indexOf(langId);
        if (langIndex === -1) {
            console.log('No model match language. LangId:', langId);
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }
        let model = this._models[langIndex];

        if (!model) {
            console.log('Org Model object is null.');
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }
        this._model = model;

        if (lastModel != this._model) {
            this.raiseModelChangedEvent();
        }            
    };

    get model() {
        return this._model;
    };

    get ModelChanged() {
        return this._ModelChanged
    };
};

//#endregion

//#region MemberModelLoader

class MemberModelLoader {
    constructor() {
        let self = this;
        this._models = null;
        this._model = null;

        this._ModelChanged = new EventHandler();

        let oncurrentUserChanged = (sender, evtData) => {
            self.loadmodels();
        };
        secure.currentUserChanged.add(oncurrentUserChanged);

        let onLanguageChanged = (sender, evtData) => {
            self.loadmodels();
        };
        lang.currentChanged.add(onLanguageChanged);
    };

    raiseModelChangedEvent() {
        if (this._ModelChanged) {
            this._ModelChanged.invoke(this, EventArgs.Empty);
        }
    };

    loadmodels(refresh) {
        let self = this;
        if (!secure.current) {
            self._models = null;
            self._model = null;
            return;
        }
        if (!self._models || refresh) {
            // not load or required refresh.
            self._models = null;
            self._model = null;

            let param = {
                CustomerId: secure.current.CustomerId
            };

            let fn = api.report.getCustomerMembers(param);
            $.when(fn).then((r) => {
                if (!r || !r.errors) {
                    console.log('No data returns.');
                }
                if (r.errors.hasError) {
                    console.log(r.errors);
                }
                if (!r.data || r.data.length <= 0) {
                    console.log('No data found.');
                }
                else {
                    //console.log(r.data);
                    self._models = r.data;
                }
                self.loadmodel();
            });
        }
        else {
            self.loadmodel();
        }
    };

    loadmodel() {
        let lastModel = this._model;

        //console.log('load org model.');
        if (!lang) {
            console.log('lang obj is null.');
        }

        let langId = lang.langId;
        //console.log(langId);
        if (!langId) {
            //console.log('current language not set.');
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }

        if (!this._models) {
            console.log('Member Models is null.');
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }
        // find model that match current language.
        let langmaps = this._models.map((item) => { return item.LangId; });
        let langIndex = langmaps.indexOf(langId);
        if (langIndex === -1) {
            console.log('No model match language. LangId:', langId);
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }
        let model = this._models[langIndex];

        if (!model) {
            console.log('Member Model object is null.');
            this._model = null;

            if (lastModel != this._model) {
                this.raiseModelChangedEvent();
            }            
            return;
        }
        this._model = model;

        if (lastModel != this._model) {
            this.raiseModelChangedEvent();
        }            
    };

    get model() {
        return this._model;
    };

    get ModelChanged() {
        return this._ModelChanged
    };
};

//#endregion

//#region ReportCriteria

class ReportCriteria {
    constructor(svr) {
        // internal variables.
        let self = this;

        this._service = svr; // report service.
        this._qset = new QSetCriteria(this);
        this._question = new QuestionCriteria(this);
        this._date = new DateCriteria(this);
        this._branch = new BranchCriteria(this);
        this._org = new OrgCriteria(this);
        this._member = new MemberCriteria(this);
    };

    // get report service.
    get report() {
        return this._service;
    };

    get qset() { return this._qset; }
    get question() { return this._question; }
    get date() { return this._date; }
    get branch() { return this._branch; }
    get org() { return this._org; }
    get member() { return this._member; }
};

//#endregion

//#region BaseCriteria

class BaseCriteria {
    constructor(p_parent) {
        this._parent = p_parent;
    };

    get parent() {
        return this._parent;
    };

    get report() {
        return (this._parent) ? this._parent.report : null;
    };
}

//#endregion

//#region QSetCriteria

class QSetCriteria extends BaseCriteria {
    constructor(parent) {
        super(parent);

        this._qsetId = ''; // selected qsetid

        let self = this;
        let modelchanged = (sender, evt) => {
            //console.log('qset model changed.');
            self.raiseChangedEvent();
        };
        this.report.qset.ModelChanged.add(modelchanged);

        this._changed = new EventHandler();
    };

    raiseChangedEvent() {
        if (this._changed) {
            this._changed.invoke(this, EventArgs.Empty);
        }
    };

    get QSetId() { return this._qsetId; };
    set QSetId(value) {
        if (this._qsetId !== value) {
            this._qsetId = value;
            // raise event when qsetid changed.
            this.raiseChangedEvent();
        }
    };

    get QSet() {
        //console.log(this._service);
        if (!this.report.qset.model) {
            //console.log('model is null.');
            return null;
        }
        if (!this._qsetId || this._qsetId === '') {
            //console.log('qsetid is null or empty string.');
            return null;
        }
        let model = this.report.qset.model;
        let qsetMap = model.qsets.map((item) => { return item.QSetId; });
        let index = qsetMap.indexOf(this._qsetId);
        if (index === -1) {
            //console.log('Not found QSetId:', this._qsetId);
        }
        return model.qsets[index];
    };

    get changed() { return this._changed; }
};

//#endregion

//#region QuestionCriteria

class QuestionCriteria extends BaseCriteria {
    constructor(parent) {
        super(parent);

        // variables for source and map from master model.
        this._items = null;
        this._maps = null;

        this._selectedItems = []; // variable selected items.

        let self = this;

        let qsetchanged = (sender, evt) => {
            //console.log('qsetid changed.');
            self.__loadslides();
            self.raiseChangedEvent();
        };
        this.parent.qset.changed.add(qsetchanged);

        this._changed = new EventHandler();
    };

    __loadslides() {
        //console.log('build question`s slide and maps.');
        this._items = null;
        this._maps = null;

        if (!this.parent.qset || !this.parent.qset.QSet) {
            //console.log('The QSet is not selected.');
            return;
        };
        // set reference for slide and map.
        let qset = (this.parent.qset) ? this.parent.qset.QSet : null;
        if (qset && qset.slides) {
            this._items = qset.slides;
            this._maps = this._items.map((item) => { return String(item.QSeq) });
        }        
        // update changed to selected items.
        if (this._selectedItems && this._selectedItems.length > 0) {
            let self = this;
            let selmaps = this._selectedItems.map((item) => { return String(item.QSeq); });
            this._selectedItems.splice(0); // remove all.
            selmaps.forEach((qseq) => {
                let sindex = self._maps.indexOf(qseq);
                if (sindex !== -1) {
                    self._selectedItems.push(self._items[sindex]);
                }
            });
        }
    };

    clear() {
        if (!this._selectedItems || this._selectedItems.length <= 0) {
            return;
        }        
        this._selectedItems.splice(0);
    };
    
    add(qseq) {
        if (!this._selectedItems) {
            this._selectedItems = [];
        }
        //console.log(this._maps);
        if (this.indexOf(qseq) !== -1) {
            //console.log('already exist.');
            return;
        }

        let index = this._maps.indexOf(String(qseq));
        if (index === -1) {
            //console.log('Not found QSeq: ', qseq);
            return;
        }
        let item = this._items[index];
        //console.log('add item: ', item);
        this._selectedItems.push(item);
        this.raiseChangedEvent();
    };

    remove(index) {
        if (!this._selectedItems || index < 0 || index >= this._selectedItems.length) {
            return;
        }
        this._selectedItems.splice(index, 1);
        this.raiseChangedEvent();
    };

    indexOf(qseq) {
        if (!this._selectedItems) return -1;
        let selmaps = this._selectedItems.map((item) => { return String(item.QSeq); });
        let index = selmaps.indexOf(String(qseq));
        return index;
    };

    raiseChangedEvent() {
        if (this._changed) {
            this._changed.invoke(this, EventArgs.Empty);
        }
    };

    get selectedItems() {
        return this._selectedItems;
    };

    get changed() { return this._changed; }
};

//#endregion

//#region DateCriteria

class DateCriteria extends BaseCriteria {
    constructor(parent) {
        super(parent);

        this._changed = new EventHandler();
    };

    raiseChangedEvent() {
        if (this._changed) {
            this._changed.invoke(this, EventArgs.Empty);
        }
    };

    get changed() { return this._changed; }
};

//#endregion

//#region BranchCriteria

class BranchCriteria extends BaseCriteria {
    constructor(parent) {
        super(parent);

        // variables for source and map from master model.
        this._items = null;
        this._maps = null;

        this._selectedItems = []; // variable selected items.

        let self = this;

        let modelchanged = (sender, evt) => {
            //console.log('org model changed.');
            self.__loadbranchs();
            self.raiseChangedEvent();
        };
        this.report.org.ModelChanged.add(modelchanged);

        this._changed = new EventHandler();
    };

    __loadbranchs() {
        //console.log('build branch list and maps.');
        this._items = null;
        this._maps = null;

        if (!this.report.org.model || !this.report.org.model.branchs) {
            //console.log('The Org Model not loaded.');
            return;
        };
        // set reference for slide and map.
        let branchs = this.report.org.model.branchs;
        if (branchs) {
            this._items = branchs;
            this._maps = this._items.map((item) => { return String(item.BranchId) });
        }
        else {
            console.log('branch list not found.');
        }
        // update changed to selected items.
        if (this._selectedItems && this._selectedItems.length > 0) {
            let self = this;
            let selmaps = this._selectedItems.map((item) => { return String(item.BranchId); });
            this._selectedItems.splice(0); // remove all.
            selmaps.forEach((branchid) => {
                let sindex = self._maps.indexOf(branchid);
                if (sindex !== -1) {
                    self._selectedItems.push(self._items[sindex]);
                }
            });
        }
    };

    raiseChangedEvent() {
        if (this._changed) {
            this._changed.invoke(this, EventArgs.Empty);
        }
    };

    clear() {
        if (!this._selectedItems || this._selectedItems.length <= 0) {
            return;
        }
        this._selectedItems.splice(0);
    };

    add(branchid) {
        if (!this._selectedItems) {
            this._selectedItems = [];
        }
        //console.log(this._maps);
        if (this.indexOf(branchid) !== -1) {
            //console.log('already exist.');
            return;
        }

        let index = this._maps.indexOf(String(branchid));
        if (index === -1) {
            //console.log('Not found BranchId: ', branchid);
            return;
        }
        let item = this._items[index];
        //console.log('add item: ', item);
        this._selectedItems.push(item);
        this.raiseChangedEvent();
    };

    remove(index) {
        if (!this._selectedItems || index < 0 || index >= this._selectedItems.length) {
            return;
        }
        this._selectedItems.splice(index, 1);
        this.raiseChangedEvent();
    };

    indexOf(branchid) {
        if (!this._selectedItems) return -1;
        let selmaps = this._selectedItems.map((item) => { return String(item.BranchId); });
        let index = selmaps.indexOf(String(branchid));
        return index;
    };

    get selectedItems() {
        return this._selectedItems;
    };

    get changed() { return this._changed; }
};

//#endregion

//#region OrgCriteria

class OrgCriteria extends BaseCriteria {
    constructor(parent) {
        super(parent);

        // variables for source and map from master model.
        this._items = null;
        this._maps = null;

        this._selectedItems = []; // variable selected items.

        let self = this;

        let modelchanged = (sender, evt) => {
            //console.log('Org Model changed.');
            self.__loadorgs();
            self.raiseChangedEvent();
        };
        this.report.org.ModelChanged.add(modelchanged);

        let branchchanged = (sender, evt) => { 
            self.__loadorgs();
            self.raiseChangedEvent();
        };
        this.parent.branch.changed.add(branchchanged);

        this._changed = new EventHandler();
    };

    __loadorgs() {
        //console.log('build org list and maps.');
        this._items = null;
        this._maps = null;

        if (!this.report.org.model || !this.report.org.model.branchs) {
            //console.log('The Org Model not loaded.');
            return;
        };

        // set reference for slide and map.
        let branchs = this.report.org.model.branchs;
        let bc = this.parent.branch;
        let bFilter = (bc.selectedItems && bc.selectedItems.length > 0) ? true : false;

        if (branchs) {
            let self = this;

            this._items = [];            
            branchs.forEach((eachBranch) => {
                // check has filter option for branch.
                let invalidClass = '';
                if (bFilter) {
                    if (bc.indexOf(eachBranch.BranchId) === -1) {
                        // the current branch is not in filter so need to gray it.
                        invalidClass = 'invalid'
                        //console.log('branch is in filter:', eachBranch.BranchId);
                    }
                    else {
                        //console.log('no branch in filter:', eachBranch.BranchId);
                    }
                }
                eachBranch.orgs.forEach((eachOrg) => {
                    // append branch name to org name.
                    let bNane = ' (' + eachBranch.BranchName + ')';
                    if (!eachOrg.OrgName.endsWith(bNane)) {
                        eachOrg.OrgName = eachOrg.OrgName + bNane;
                    }
                    eachOrg.Invalid = invalidClass;
                });
                // merge into single array.
                self._items.push(...eachBranch.orgs);
            });
            this._maps = this._items.map((item) => { return String(item.OrgId) });
        }
        else {
            console.log('org list not found.');
        }
        // update changed to selected items.
        if (this._selectedItems && this._selectedItems.length > 0) {
            let self = this;        
            let selmaps = this._selectedItems.map((item) => { return String(item.OrgId); });
            this._selectedItems.splice(0); // remove all.
            selmaps.forEach((orgid) => {
                let sindex = self._maps.indexOf(orgid);
                if (sindex !== -1) {
                    let item = self._items[sindex];
                    self._selectedItems.push(item);
                }
            });
        }
    };

    clear() {
        if (!this._selectedItems || this._selectedItems.length <= 0) {
            return;
        }
        this._selectedItems.splice(0);
    };

    add(orgid) {
        if (!this._selectedItems) {
            this._selectedItems = [];
        }
        //console.log(this._maps);
        if (this.indexOf(orgid) !== -1) {
            //console.log('already exist.');
            return;
        }

        let index = this._maps.indexOf(String(orgid));
        if (index === -1) {
            //console.log('Not found OrgId: ', orgid);
            return;
        }
        let item = this._items[index];
        //console.log('add item: ', item);
        this._selectedItems.push(item);
        this.raiseChangedEvent();
    };

    remove(index) {
        if (!this._selectedItems || index < 0 || index >= this._selectedItems.length) {
            return;
        }
        this._selectedItems.splice(index, 1);
        this.raiseChangedEvent();
    };

    indexOf(orgid) {
        if (!this._selectedItems) return -1;
        let selmaps = this._selectedItems.map((item) => { return String(item.OrgId); });
        let index = selmaps.indexOf(String(orgid));
        return index;
    };

    raiseChangedEvent() {
        if (this._changed) {
            this._changed.invoke(this, EventArgs.Empty);
        }
    };

    get selectedItems() {
        return this._selectedItems;
    };

    get changed() { return this._changed; }
};

//#endregion

//#region MemberCriteria

class MemberCriteria extends BaseCriteria {
    constructor(parent) {
        super(parent);

        // variables for source and map from master model.
        this._items = null;
        this._maps = null;

        this._selectedItems = []; // variable selected items.

        let self = this;

        let modelchanged = (sender, evt) => {
            //console.log('org model changed.');
            self.__loadmembers();
            self.raiseChangedEvent();
        };
        this.report.member.ModelChanged.add(modelchanged);

        this._changed = new EventHandler();
    };

    __loadmembers() {
        //console.log('build branch list and maps.');
        this._items = null;
        this._maps = null;

        if (!this.report.member.model || !this.report.member.model.members) {
            //console.log('The Org Model not loaded.');
            return;
        };
        // set reference for slide and map.
        let members = this.report.member.model.members;
        if (members) {
            this._items = members;
            this._maps = this._items.map((item) => { return String(item.MemberId) });
        }
        else {
            console.log('member list not found.');
        }
        // update changed to selected items.
        if (this._selectedItems && this._selectedItems.length > 0) {
            let self = this;
            let selmaps = this._selectedItems.map((item) => { return String(item.MemberId); });
            this._selectedItems.splice(0); // remove all.
            selmaps.forEach((memberid) => {
                let sindex = self._maps.indexOf(memberid);
                if (sindex !== -1) {
                    self._selectedItems.push(self._items[sindex]);
                }
            });
        }
    };

    raiseChangedEvent() {
        if (this._changed) {
            this._changed.invoke(this, EventArgs.Empty);
        }
    };

    clear() {
        if (!this._selectedItems || this._selectedItems.length <= 0) {
            return;
        }
        this._selectedItems.splice(0);
    };

    add(memberid) {
        if (!this._selectedItems) {
            this._selectedItems = [];
        }
        //console.log(this._maps);
        if (this.indexOf(memberid) !== -1) {
            //console.log('already exist.');
            return;
        }

        let index = this._maps.indexOf(String(memberid));
        if (index === -1) {
            //console.log('Not found MemberId: ', memberid);
            return;
        }
        let item = this._items[index];
        //console.log('add item: ', item);
        this._selectedItems.push(item);
        this.raiseChangedEvent();
    };

    remove(index) {
        if (!this._selectedItems || index < 0 || index >= this._selectedItems.length) {
            return;
        }
        this._selectedItems.splice(index, 1);
        this.raiseChangedEvent();
    };

    indexOf(memberid) {
        if (!this._selectedItems) return -1;
        let selmaps = this._selectedItems.map((item) => { return String(item.MemberId); });
        let index = selmaps.indexOf(String(memberid));
        return index;
    };

    get selectedItems() {
        return this._selectedItems;
    };

    get changed() { return this._changed; }
};

//#endregion

//#region SearchManager

class SearchManager {
    constructor(srv) {
        this._service = srv; // report service.
        this._current = new ReportCriteria(this._service);
    };

    newSearch() {
        this._current = new ReportCriteria(this._service);
    };

    get current() { return this._current; };
};

//#endregion

//#region ReportService

class ReportService {
    constructor() {
        this._qsetloader = new QSetModelLoader();
        this._orgloader = new OrgModelLoader();
        this._memberloader = new MemberModelLoader();
        this._searchManager = new SearchManager(this);
    };
    // org model loader.
    get org() {
        return this._orgloader;
    };
    // qset model loader.
    get qset() {
        return this._qsetloader;
    };
    // member model loader.
    get member() {
        return this._memberloader;
    };
    // search manager.
    get search() {
        return this._searchManager;
    };
};

/*
class ReportService2 {
    constructor() {
        //this._criteria = null;
        this._onSearch = new EventHandler();
        this._onQModelChanged = new EventHandler();

        this._qmodel = null;

        let self = this;
        let oncurrentUserChanged = (sender, evtData) => {
            self.loadQModel();
        };
        secure.currentUserChanged.add(oncurrentUserChanged);

        let onLanguageChanged = (sender, evtData) => {
            self.loadQModel();
        };
        lang.currentChanged.add(onLanguageChanged);
    };

    loadQModel() {
        let self = this;
        if (!secure.current)
            return;
        let param = {
            "langId": lang.langId,
            "customerID": secure.current.CustomerId
        };
        //console.log(param);
        let fn = api.report.getCustomerQSets(param);
        $.when(fn).then((r) => {
            if (!r || !r.errors) {
                //console.log('No data returns.');
                this._qmodel = null;
            }
            if (r.errors.hasError) {
                //console.log(r.errors);
                self._qmodel = null;
            }
            if (!r.data || r.data.length <= 0) {
                //console.log('No data found.');
                self._qmodel = null;
            }
            else {
                //console.log(r.data);
                self._qmodel = r.data;
            }
            self._onQModelChanged.invoke(self, EventArgs.Empty);
        });
    };

    getSlides(qSetId) {
        if (!this._qmodel) {
            return [];
        }
        else {
            let qsetmaps = (this._qmodel) ?
                this._qmodel.map((item) => { return item.QSetId; }) : null;
            let index = (qsetmaps) ? qsetmaps.indexOf(qSetId) : -1;
            if (index === -1) {
                console.log('cannot find QSetId.');
                return;
            }

            let qSet = this._qmodel[index];
            return (qSet) ? qSet.slides : [];
        }
    };

    getSlide(qSetId, qSeq) {
        if (!this._qmodel) {
            return null;
        }
        else {
            let slides = this.getSlides(qSetId);
            let slideMaps = slides.map((slide) => { return String(slide.QSeq); });
            let index = slideMaps.indexOf(String(qSeq));
            if (index === -1) {
                return null;
            }
            else {
                return slides[index];
            }
        }
    };

    search(criteria) {
        let self = this;
        //self._criteria = criteria;
        //self._onSearch.invoke(self, EventArgs.Empty);
        self._onSearch.invoke(self, criteria);
    };

    get qModel() {
        return this._qmodel;
    };

    get onSearch() {
        return this._onSearch;
    };

    get onQModelChanged() {
        return this._onQModelChanged;
    };
}
*/

; (function () {
    //console.log('Init language service...');
    window.report = window.report || new ReportService();
})();

//#endregion

//#region Finder

class Finder {
    constructor() {
        this._result = null;
        this._searchCompleted = new EventHandler();
    };

    search(criteria) {
        let self = this;
        let param = {
            "LangId": lang.langId,
            "CustomerID": secure.current.CustomerId,
            "QSetId": criteria.QSetId,
            "QSeq": criteria.QSeq,
            "OrgId": criteria.OrgId,
            "BeginDate": criteria.BeginDate,
            "EndDate": criteria.EndDate
        };
        let fn = api.report.getVoteSummary(param);
        $.when(fn).then((r) => {
            if (!r || !r.errors) {
                //console.log('No data returns.');
                self._result = null;
            }
            if (r.errors.hasError) {
                //console.log(r.errors); 
                self._result = null;
            }
            if (!r.data || r.data.length <= 0) {
                //console.log('No data found.'); 
                self._result = null;
            }
            //console.log(r.data);
            self._result = r.data;
            self._searchCompleted.invoke(self, EventArgs.Empty);
        });
    };

    get result() {
        return this._result;
    };

    get searchCompleted() {
        return this._searchCompleted;
    };
};

//#endregion

//#region RaterPage

class RaterPage {
    constructor() {
        this._modelML = { };
        this._modelLoaded = new EventHandler();

        let self = this;
        let onLanguageChanged = (sender, evtData) => {
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

        lang.currentChanged.add(onLanguageChanged);
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
