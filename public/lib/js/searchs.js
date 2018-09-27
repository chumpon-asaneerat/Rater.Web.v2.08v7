//#region RaterModelLoader and related classes

//#region RaterModelLoader

class RaterModelLoader {};

//#endregion

//#region BaseModelLoader

RaterModelLoader.BaseModelLoader = class {
    constructor() {
        this._models = null;
        this._model = null;
        this._ModelChanged = new EventHandler();

        let self = this;
        let oncurrentUserChanged = (sender, evtData) => {
            self.loadmodels();
        };
        secure.currentUserChanged.add(oncurrentUserChanged);

        let onLanguageChanged = (sender, evtData) => {
            self.loadmodels();
        };
        lang.currentChanged.add(onLanguageChanged);
    };
    // private methods.
    raiseModelChangedEvent() {
        if (this._ModelChanged) {
            this._ModelChanged.invoke(this, EventArgs.Empty);
        }
    };
    // virtual methods
    getAPI(param) { return null; };
    // public methods.
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

            let param = { CustomerId: secure.current.CustomerId };
            let fn = self.getAPI(param);
            if (!fn) return;

            $.when(fn).then((r) => {
                if (!r || !r.errors) console.log('No data returns.');
                if (r.errors.hasError) console.log(r.errors);
                if (!r.data || r.data.length <= 0) console.log('No data found.');
                else self._models = r.data;
                self.loadmodel();
            });
        }
        else self.loadmodel();
    };

    loadmodel() {
        let lastModel = this._model;
        if (!lang) console.log('lang obj is null.');
        let langId = (lang) ? lang.langId : null;
        if (!langId) {
            // current language not set.
            this._model = null;
            if (lastModel != this._model) this.raiseModelChangedEvent();
            return;
        }
        if (!this._models) {
            // Models is null.
            this._model = null;
            if (lastModel != this._model) this.raiseModelChangedEvent();
            return;
        }
        // find model that match current language.
        let langmaps = this._models.map((item) => { return item.LangId; });
        let langIndex = langmaps.indexOf(langId);
        if (langIndex === -1) {
            // No model match language.
            this._model = null;
            if (lastModel != this._model) this.raiseModelChangedEvent();
            return;
        }
        let model = this._models[langIndex];
        if (!model) {
            // Model object is null.
            this._model = null;
            if (lastModel != this._model) this.raiseModelChangedEvent();
            return;
        }
        // OK.
        this._model = model;
        if (lastModel != this._model) this.raiseModelChangedEvent();
    };
    // public properties.
    get model() { return this._model; };
    // public events.
    get ModelChanged() { return this._ModelChanged };
};

//#endregion

//#region QSetModelLoader

RaterModelLoader.QSetModelLoader = class extends RaterModelLoader.BaseModelLoader {
    constructor() { super(); };
    // override methods.
    getAPI(param) { return api.report.getCustomerQSets(param); };
};

//#endregion

//#region OrgModelLoader

RaterModelLoader.OrgModelLoader = class extends RaterModelLoader.BaseModelLoader {
    constructor() { super(); };
    // override methods.
    getAPI(param) { return api.report.getCustomerOrgs(param); };
};

//#endregion

//#region MemberModelLoader

RaterModelLoader.MemberModelLoader = class extends RaterModelLoader.BaseModelLoader {
    constructor() { super(); };
    // override methods.
    getAPI(param) { return api.report.getCustomerMembers(param); };
};

//#endregion

//#endregion

//#region Rater Criteria and related classes (rewrite required).

//#region RaterCriteria

class RaterCriteria { };

//#endregion

//#region RaterCriteria

RaterCriteria.BaseCriteria = class {
    constructor(p_parent) {
        this._parent = p_parent;
        this._changed = new EventHandler();
    };
    // private methods.
    raiseChangedEvent() {
        if (this._changed) {
            this._changed.invoke(this, EventArgs.Empty);
        }
    };
    // virtual methods.
    clear() { };
    // public properties.
    get parent() { return this._parent; };
    get report() { return (this._parent) ? this._parent.report : null; };
    // public events.
    get changed() { return this._changed; }
};

//#endregion

//#region MultiValueCriteria

RaterCriteria.MultiValueCriteria = class extends RaterCriteria.BaseCriteria {
    constructor(parent) {
        super(parent);
        // variables for source and map from master model.
        this._items = null;
        this._maps = null;
        this._selectedItems = []; // variable selected items.
        this._idMember = '';
    };
    // virtual, override methods.
    loadItems() {
        this._items = null;
        this._maps = null;

        let pName = String(this._idMember);
        this._items = this.getItems();
        if (this._items) {
            this._maps = this._items.map((item) => { return String(item[pName]) });
        }

        // update changed to selected items.
        if (this._selectedItems && this._selectedItems.length > 0) {
            let self = this;
            let selmaps = this._selectedItems.map((item) => { return String(item[pName]); });
            this._selectedItems.splice(0); // remove all.
            selmaps.forEach((id) => {
                let sindex = self._maps.indexOf(id);
                if (sindex !== -1) {
                    self._selectedItems.push(self._items[sindex]);
                }
            });
        }
    };
    getItems() { return null; };
    indexOf(id) {
        if (!this._selectedItems) return -1;
        let pName = String(this._idMember);
        let selmaps = this._selectedItems.map((item) => { return String(item[pName]); });
        let index = selmaps.indexOf(String(id));
        return index;
    };
    add(id) {
        if (!this._selectedItems) this._selectedItems = []; // create new if required.
        if (this.indexOf(id) !== -1) return; // already exist.
        let index = this._maps.indexOf(String(id));
        if (index === -1) return; // Not found
        let item = this._items[index];
        //console.log('add item: ', item);
        this._selectedItems.push(item);
        this.raiseChangedEvent();
    };
    remove(index) {
        if (!this._selectedItems || index < 0 || index >= this._selectedItems.length)
            return;
        this._selectedItems.splice(index, 1);
        this.raiseChangedEvent();
    };
    clear() {
        if (!this._selectedItems || this._selectedItems.length <= 0)
            return;
        this._selectedItems.splice(0);
        this.raiseChangedEvent();
    };
    // public properties.
    get idPropertyName() { return this._idMember; };
    set idPropertyName(value) {
        if (this._idMember != value) {
            this._idMember = value;
        }
    };
    get selectedItems() { return this._selectedItems; };
}

//#endregion

//#region QSetCriteria

RaterCriteria.QSetCriteria = class extends RaterCriteria.BaseCriteria {
    constructor(parent) {
        super(parent);
        this._qsetId = ''; // selected qsetid

        let self = this;
        let modelchanged = (sender, evt) => {
            //console.log('qset model changed.');
            self.raiseChangedEvent();
        };
        this.report.qset.ModelChanged.add(modelchanged);
    };
    get QSetId() { return this._qsetId; };
    set QSetId(value) {
        if (this._qsetId !== value) {
            this._qsetId = value;
            this.parent.clear(); // reset all child criteria.
            // raise event when qsetid changed.
            this.raiseChangedEvent();
        }
    };
    get QSet() {
        //console.log(this._service);
        if (!this.report.qset.model) return null;
        if (!this._qsetId || this._qsetId === '') return null;
        let model = this.report.qset.model;
        let qsetMap = model.qsets.map((item) => { return item.QSetId; });
        let index = qsetMap.indexOf(this._qsetId);
        if (index === -1) return null; // not found.
        return model.qsets[index];
    };
};

//#endregion

//#region QuestionCriteria

RaterCriteria.QuestionCriteria = class extends RaterCriteria.MultiValueCriteria {
    constructor(parent) {
        super(parent);
        // set id property
        this.idPropertyName = 'QSeq';

        let self = this;
        let qsetchanged = (sender, evt) => {
            //console.log('qsetid changed.');
            self.loadItems();
            self.raiseChangedEvent();
        };
        this.parent.qset.changed.add(qsetchanged);
    };
    getItems() {
        if (this.parent.qset && this.parent.qset.QSet) {
            let qset = (this.parent.qset) ? this.parent.qset.QSet : null;
            if (qset && qset.slides)
                return qset.slides;
        }
        return null;
    };
};

//#endregion

//#region DateCriteria

RaterCriteria.DateCriteria = class extends RaterCriteria.BaseCriteria {
    constructor(parent) {
        super(parent);
        this._beginDate = null;
        this._endDate = null;
    };
    __checkMinMax() {
        if (!this._beginDate && !this._endDate) {
            // no date.
        }
        else if (this._beginDate && !this._endDate) {
            // has only begin date.
        }
        else if (!this._beginDate && this._endDate) {
            // has only end date.
        }
        else {
            // has both date.
            if (this._beginDate > this._endDate) {
                // swap.
                let tmp = this._endDate;
                this._endDate = this._beginDate;
                this._beginDate = tmp;
            }
        }
    };
    clear() {
        this._beginDate = null;
        this._endDate = null;
        this.raiseChangedEvent();
    };
    get beginDate() { return this._beginDate; };
    set beginDate(value) {
        if (this._beginDate != value) {
            this._beginDate = value;
            this.__checkMinMax();
            this.raiseChangedEvent();
        }
    };
    get endDate() { return this._endDate; };
    set endDate(value) {
        if (this._endDate != value) {
            this._endDate = value;
            this.__checkMinMax();
            this.raiseChangedEvent();
        }
    };
};

//#endregion

//#region BranchCriteria

RaterCriteria.BranchCriteria = class extends RaterCriteria.MultiValueCriteria {
    constructor(parent) {
        super(parent);
        // set id property
        this.idPropertyName = 'BranchId';

        let self = this;
        let modelchanged = (sender, evt) => {
            //console.log('org model changed.');
            self.loadItems();
            self.raiseChangedEvent();
        };
        this.report.org.ModelChanged.add(modelchanged);
    };
    getItems() {
        if (this.report.org.model && this.report.org.model.branchs)
            return this.report.org.model.branchs;
        return null;
    };
};

//#endregion

//#region OrgCriteria

RaterCriteria.OrgCriteria = class extends RaterCriteria.MultiValueCriteria {
    constructor(parent) {
        super(parent);
        // set id property
        this.idPropertyName = 'OrgId';

        let self = this;
        let modelchanged = (sender, evt) => {
            //console.log('Org Model changed.');
            self.loadItems();
            self.raiseChangedEvent();
        };
        this.report.org.ModelChanged.add(modelchanged);

        let branchchanged = (sender, evt) => {
            self.loadItems();
            self.raiseChangedEvent();
        };
        this.parent.branch.changed.add(branchchanged);
    };
    getItems() {
        if (this.report.org.model && this.report.org.model.branchs) {
            let branchs = this.report.org.model.branchs;
            let bc = this.parent.branch;
            let bFilter = (bc.selectedItems && bc.selectedItems.length > 0) ? true : false;
            let orgs = null;

            if (branchs) {
                let self = this;
                orgs = [];
                // Grey tag supports.
                branchs.forEach((brh) => {
                    // check has filter option for branch.
                    let invalidClass = '';
                    if (bFilter) {
                        // the current branch is not in filter so need to gray it.
                        if (bc.indexOf(brh.BranchId) === -1) invalidClass = 'invalid'
                    }
                    brh.orgs.forEach((org) => {
                        // append branch name to org name.
                        let bNane = ' (' + brh.BranchName + ')';
                        if (!org.OrgName.endsWith(bNane)) {
                            org.OrgName = org.OrgName + bNane;
                        }
                        org.Invalid = invalidClass;
                    });
                    // merge into single array.
                    orgs.push(...brh.orgs);
                });

                let filters = orgs.filter((item) => {
                    return (item.Invalid === ''); // hide gray element.
                    //return true; // show with gray element.
                });
                return filters;
            }
        }
        return null;
    };
};

//#endregion

//#region MemberCriteria

RaterCriteria.MemberCriteria = class extends RaterCriteria.MultiValueCriteria {
    constructor(parent) {
        super(parent);
        // set id property
        this.idPropertyName = 'MemberId';

        let self = this;
        let modelchanged = (sender, evt) => {
            //console.log('org model changed.');
            self.loadItems();
            self.raiseChangedEvent();
        };
        this.report.member.ModelChanged.add(modelchanged);
    };
    getItems() {
        if (this.report.member.model && this.report.member.model.members)
            return this.report.member.model.members;
        return null;
    };
};

//#endregion

//#endregion

//#region ReportCriteria

class ReportCriteria {
    constructor(svr) {
        // internal variables.
        this._service = svr; // report service.
        this._qset = new RaterCriteria.QSetCriteria(this);
        this._question = new RaterCriteria.QuestionCriteria(this);
        this._date = new RaterCriteria.DateCriteria(this);
        this._branch = new RaterCriteria.BranchCriteria(this);
        this._org = new RaterCriteria.OrgCriteria(this);
        this._member = new RaterCriteria.MemberCriteria(this);
    };
    clear() {
        this._member.clear();
        this._org.clear();
        this._branch.clear();
        this._date.clear();
        this._question.clear();
    };
    // get report service.
    get report() { return this._service; };
    // get model
    get qset() { return this._qset; }
    get question() { return this._question; }
    get date() { return this._date; }
    get branch() { return this._branch; }
    get org() { return this._org; }
    get member() { return this._member; }
};

//#endregion

//#region SearchManager

class SearchManager {
    constructor(srv) {
        this._service = srv; // report service.
        this._current = new ReportCriteria(this._service);
    };
    newSearch() { this._current = new ReportCriteria(this._service); };
    get current() { return this._current; };
};

//#endregion

//#region ReportService

class ReportService {
    constructor() {
        this._qsetloader = new RaterModelLoader.QSetModelLoader();
        this._orgloader = new RaterModelLoader.OrgModelLoader();
        this._memberloader = new RaterModelLoader.MemberModelLoader();
        this._searchManager = new SearchManager(this);
    };
    // org model loader.
    get org() { return this._orgloader; };
    // qset model loader.
    get qset() { return this._qsetloader; };
    // member model loader.
    get member() { return this._memberloader; };
    // search manager.
    get search() { return this._searchManager; };
};

//#endregion

//#region AutoFill and related classes

//#region AutoFillDataSource

class AutoFillDataSource {
    constructor() {
    };
};

//#endregion

//#region AutoFill

class AutoFill {
    constructor(elem) {
        this._dom = new NDOM(elem);
        this._gui = {
            root: new AutoFill.Container(this),
            menu: {
                showcommand: new AutoFill.CommandMenu(this),
                selectall: new AutoFill.SelectAllMenu(this)
            },
            input: {
                filter: new AutoFill.InputSpan(this),
                suggest: new AutoFill.SuggestSpan(this)
            },
            drop: {
                panel: new AutoFill.DropPanel(this)
            }
        }
        this._ds = null;
    };
    // public methods.
    showCommand() {
        console.log('show command.');
        /*
        if (!this.__checkRedirect()) {
            this.__loadCommands();
            this.dropdown();
        }
        */
    };
    selectAll() {
        console.log('select all.');
        /*
        let self = this;
        if (this._command !== '' && this._command !== 'qset' && this._command !== 'date') {
            this.selectAll();
        }
        */
    };
    focus() {
        if (!this._gui) return;
        if (!this._gui.input) return;
        if (!this._gui.input.filter) return;
        this._gui.input.filter.focus();
    };
    get isdroped() {
        if (!this._gui) return;
        if (!this._gui.drop) return;
        if (!this._gui.drop.panel) return;
        return this._gui.drop.panel.isdroped();
    }
    dropdown() {
        if (!this._gui) return;
        if (!this._gui.drop) return;
        if (!this._gui.drop.panel) return;
        //self.__checkRedirect();
        this._gui.drop.panel.dropdown();
        this.refresh();
    };
    close() {
        if (!this._gui) return;
        if (!this._gui.drop) return;
        if (!this._gui.drop.panel) return;
        this._gui.drop.panel.close();
    };
    refresh() { };
    // dom and HTMLElement access.
    get dom() { return this._dom; }
    get elem() { return (this._dom) ? this._dom.elem : null; }
    // get gui.
    get gui() { return this._gui; }
    // datasource
    get datasource() { return this._ds; }
    set datasource(value) {
        this._ds = value;
    }
}

//#endregion

//#region AutoFill.Element (base class)

AutoFill.Element = class {
    constructor(autofill) {
        this._autofill = autofill;
        this._dom = this.create();
    };
    // virtual methods.
    create() { return null; };
    // get the autofill instance.
    get autofill() { return this._autofill; }
    // get root dom.
    get root() { return (this._autofill) ? this._autofill.dom : null; }
    // get gui.
    get gui() { return (this._autofill) ? this._autofill.gui : null; }
    get dom() { return this._dom; }
};

//#endregion

//#region AutoFill.Container

AutoFill.Container = class extends AutoFill.Element {
    constructor(autofill) {
        super(autofill);
    };
    // override methods.
    create() {
        if (!this.autofill || !this.autofill.dom) return null;
        let dom = this.autofill.dom;
        dom.class.add('auto-fill');
        dom.event.add('click', this.click.bind(this));
        return dom;
    };
    // event handlers.
    click(evt) {
        if (!this.autofill) return;
        evt.preventDefault();
        evt.stopPropagation();
        this.autofill.focus();

        return false;
    };
};

//#endregion

//#region AutoFill.CommandMenu

AutoFill.CommandMenu = class extends AutoFill.Element {
    constructor(autofill) {
        super(autofill);
    };
    // override methods.
    create() {
        if (!this.autofill || !this.autofill.dom) return null;
        let root = this.autofill.dom;
  
        let dom = NDOM.create('a');
        let span = NDOM.create('span');
        span.class.add('fas');
        span.class.add('fa-arrow-up');
        span.attr('href', 'javascript:;');
        span.style('display', 'inline-block');
        span.style('margin', '0 auto');
        span.style('margin-right', '5px');
        span.style('padding', '0');
        span.style('cursor', 'pointer');
        dom.addChild(span);
        // setup listeners.
        dom.event.add('click', this.click.bind(this));

        root.addChild(dom);

        return dom;
    };
    // event handlers.
    click(evt) {
        if (!this.autofill) return;
        evt.preventDefault();
        evt.stopPropagation();
        this.autofill.showCommand();
        return false;
    };
};

//#endregion

//#region AutoFill.InputSpan

AutoFill.InputSpan = class extends AutoFill.Element {    
    constructor(autofill) {
        super(autofill);
    };
    // override methods.
    create() {
        if (!this.autofill || !this.autofill.dom) return null;
        let root = this.autofill.dom;

        let dom = NDOM.create('span');
        dom.class.add('input-text');
        dom.attr('contenteditable', 'true');
        dom.text = '';
        // setup listeners.
        dom.event.add('focus', this.gotfocus.bind(this));
        dom.event.add('blur', this.lostfocus.bind(this));
        dom.event.add('input', this.input.bind(this));
        dom.event.add('keydown', this.keydown.bind(this));

        root.addChild(dom);

        return dom;
    };
    // private methods.
    setEndOfContenteditable(contentEditableElem) {
        if (!contentEditableElem) return;
        var range, sel;
        if (document.createRange) {
            range = document.createRange();
            range.selectNodeContents(contentEditableElem);
            range.collapse(false);
            sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(range);
        } else if (document.selection) {
            range = document.body.createTextRange();
            range.moveToElementText(contentEditableElem);
            range.collapse(false);
            range.select();
        }
    };
    // event handlers.
    gotfocus(evt) { 
        if (!this.autofill) return;
        evt.preventDefault();
        evt.stopPropagation();
        this.autofill.dropdown();
        return false;
    }
    lostfocus(evt) {
        if (!this.autofill) return;
        evt.preventDefault();
        evt.stopPropagation();
        this.autofill.close();
        return false;
    }
    input(evt) { }
    keydown(evt) { }
    // public methods
    focus() {
        if (!this.dom || !this.dom.elem) return;
        this.setEndOfContenteditable(this.dom.elem);
        let self = this;
        setTimeout(function () {
            self.dom.focus();
        }, 0);        
    };
};

//#endregion

//#region AutoFill.SuggestSpan

AutoFill.SuggestSpan = class extends AutoFill.Element {
    constructor(autofill) {
        super(autofill);
    };
    // override methods.
    create() {
        if (!this.autofill || !this.autofill.dom) return null;
        let root = this.autofill.dom;
        let dom = NDOM.create('span');
        dom.class.add('suggest-text');
        dom.text = '';

        root.addChild(dom);
    };
};

//#endregion

//#region AutoFill.SelectMenu

AutoFill.SelectAllMenu = class extends AutoFill.Element {
    constructor(autofill) {
        super(autofill);
    };
    // override methods.
    create() {
        if (!this.autofill || !this.autofill.dom) return null;
        let root = this.autofill.dom;
        let dom = NDOM.create('a');
        let span = NDOM.create('span');
        span.class.add('far');
        span.class.add('fa-check-square');
        span.attr('href', 'javascript:;');
        span.style('display', 'inline-block');
        span.style('float', 'right');
        span.style('margin', '0 auto');
        span.style('margin-left', '3px');
        span.style('padding', '0');
        span.style('padding-top', '3px');
        span.style('cursor', 'pointer');
        dom.addChild(span);
        // setup listeners.
        dom.event.add('click', this.click.bind(this));

        root.addChild(dom);
    };
    // event handlers.
    click(evt) {
        if (!this.autofill) return;
        evt.preventDefault();
        evt.stopPropagation();
        this.autofill.selectAll();
        return false;
    };
};

//#endregion

//#region AutoFill.DropPanel

AutoFill.DropPanel = class extends AutoFill.Element {
    constructor(autofill) {
        super(autofill);
    };
    // override methods.
    create() {
        if (!this.autofill || !this.autofill.dom) return null;
        let root = this.autofill.dom;

        let dom = NDOM.create('div');
        dom.class.add('drop-panel');
        dom.class.add('hide');
        // add sample child
        let h1 = NDOM.create('h1');
        h1.text = 'EXAMPLE TEXT';
        dom.addChild(h1);

        root.addChild(dom);

        return dom;
    };
    // public methods.
    get isdroped() {
        if (!this.dom) return false;
        let isHide = this.dom.class.has('hide');
        return !isHide;
    };
    dropdown() {
        if (!this.dom) return;
        let dom = this.dom;
        dom.class.remove('hide');

        if (!this.autofill || !this.autofill.dom) return null;
        let root = this.autofill.dom;
        // recalc position.
        let top = root.offsetTop + root.offsetHeight + 1;
        let left = root.offsetLeft;
        let right = root.offsetLeft; // same as left.
        // update position.
        dom.style('left', left + 'px');
        dom.style('right', right + 'px');
        dom.style('top', top + 'px');
    };
    close() {
        if (!this.dom) return;
        this.dom.class.add('hide');
    };
};

//#endregion

//#endregion

//#region set global ReportService

; (function () {
    //console.log('Init language service...');
    window.report = window.report || new ReportService();
})();

//#endregion

