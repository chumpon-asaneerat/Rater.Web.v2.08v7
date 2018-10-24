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

//#region RaterCriteria.BaseCriteria

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
    refresh() {
        this.raiseChangedEvent();
    };
    // public properties.
    get parent() { return this._parent; };
    get report() { return (this._parent) ? this._parent.report : null; };
    // public events.
    get changed() { return this._changed; }
};

//#endregion

//#region RaterCriteria.MultiValueCriteria

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
    refresh() {
        this.loadItems();
        this.raiseChangedEvent();
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

//#region RaterCriteria.QSetCriteria

RaterCriteria.QSetCriteria = class extends RaterCriteria.BaseCriteria {
    constructor(parent) {
        super(parent);
        this._qsetId = ''; // selected qsetid

        let self = this;
        let modelchanged = () => { self.refresh(); };
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

//#region RaterCriteria.QuestionCriteria

RaterCriteria.QuestionCriteria = class extends RaterCriteria.MultiValueCriteria {
    constructor(parent) {
        super(parent);
        // set id property
        this.idPropertyName = 'QSeq';

        let self = this;
        let qsetchanged = () => { self.refresh(); };
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

//#region RaterCriteria.DateCriteria

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
        //console.log('date clear.');
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

//#region RaterCriteria.BranchCriteria

RaterCriteria.BranchCriteria = class extends RaterCriteria.MultiValueCriteria {
    constructor(parent) {
        super(parent);
        // set id property
        this.idPropertyName = 'BranchId';

        let self = this;
        let modelchanged = () => { self.refresh(); };
        this.report.org.ModelChanged.add(modelchanged);
    };
    getItems() {
        if (this.report.org.model && this.report.org.model.branchs)
            return this.report.org.model.branchs;
        return null;
    };
};

//#endregion

//#region RaterCriteria.OrgCriteria

RaterCriteria.OrgCriteria = class extends RaterCriteria.MultiValueCriteria {
    constructor(parent) {
        super(parent);
        // set id property
        this.idPropertyName = 'OrgId';

        let self = this;
        let modelchanged = () => { self.refresh(); };
        this.report.org.ModelChanged.add(modelchanged);

        let branchchanged = () => { self.refresh(); };
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

//#region RaterCriteria.MemberCriteria

RaterCriteria.MemberCriteria = class extends RaterCriteria.MultiValueCriteria {
    constructor(parent) {
        super(parent);
        // set id property
        this.idPropertyName = 'MemberId';

        let self = this;
        let modelchanged = () => { self.refresh(); };
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
    clear(clearQSet = false) {
        this._member.clear();
        this._org.clear();
        this._branch.clear();
        this._date.clear();
        this._question.clear();
        if (clearQSet) this._qset.clear();
    };
    refresh() {
        this._member.refresh();
        this._org.refresh();
        this._branch.refresh();
        this._date.refresh();
        this._question.refresh();
        this._qset.refresh();
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
        this._searchCompleted = new EventHandler();
        this._newCriteriaCreated = new EventHandler();
    };
    newSearch() { 
        this._current = new ReportCriteria(this._service);
        this._current.refresh();
        this._newCriteriaCreated.invoke(self, EventArgs.Empty);
    };
    get current() { return this._current; };
    callAPI(param) {
        //console.log('call api:', JSON.stringify(param));
        let self = this;
        let result = {};
        let fn = api.report.getSummaryReport(param);
        $.when(fn).then((r) => {
            if (!r || !r.errors) {
                //console.log('No data returns.');
                result = null;
            }
            if (r.errors.hasError) {
                //console.log(r.errors); 
                result = null;
            }
            if (!r.data || r.data.length <= 0) {
                //console.log('No data found.'); 
                result = null;
            }
            //console.log(r.data);
            result = r.data[0];
            //console.log('result:', r.data);

            let rept = new SearchResult(self._service, result);
            rept.refresh();
            self._searchCompleted.invoke(self, { data: rept });
        });
    };
    execute() {
        let self = this;
        let curr = self.current;
        let questions = curr.question.selectedItems;
        let slides = (questions && questions.length > 0) ? questions : curr.qset.QSet.slides;
        let slidesMap = slides.map(slide => slide.QSeq);
        let bdate = (curr.date.beginDate) ? curr.date.beginDate : NArray.Date.today;
        let edate = (curr.date.endDate) ? curr.date.endDate : NArray.Date.today;
        let orgs = curr.org.selectedItems;
        let orgMaps;
        if (orgs && orgs.length > 0) {
            orgMaps = orgs.map(org => org.OrgId)
        }
        else {
            let allorgs = [];
            report.org.model.branchs.forEach(branch => {
                allorgs.push(...branch.orgs);
            });
            let root = allorgs.filter(org => !org.parent)[0];
            orgMaps = [ root.OrgId ];
        }

        let param = {
            //"LangId": lang.langId,
            "CustomerID": secure.current.CustomerId,
            "QSetId": curr.qset.QSetId,
            "QSeq": slidesMap,
            "OrgId": orgMaps,
            "BeginDate": bdate,
            "EndDate": edate
        };
        
        // call the api.
        self.callAPI(param);

        this.newSearch();
    };

    get searchCompleted() { return this._searchCompleted; }
    get newCriteriaCreated() { return this._newCriteriaCreated; }
};

//#endregion

class SearchResult {
    constructor(srv, result) {
        this._service = srv; // report service.
        this._result = result;
        this._no = ++SearchResult.ResultCounter;

        let self = this;
        let modelchanged = (sender, evtData) => {
            self.refresh();
        };

        this.report.qset.ModelChanged.add(modelchanged);
        this.report.org.ModelChanged.add(modelchanged);
        this.report.member.ModelChanged.add(modelchanged);
    };

    refresh() {
        if (!this._result) return;
        let r = this._result;

        let qsets = report.qset.model.qsets;
        let qsetsMap = qsets.map(qset => qset.QSetId);
        let qset = qsets[qsetsMap.indexOf(r.QSetId)];
        // assign description
        r.QSetDescription = qset.QSetDescription;

        // organize maps.
        let branchs = report.org.model.branchs;
        let orgs = [];
        branchs.forEach(branch => { orgs.push(...branch.orgs); });
        let bMaps = branchs.map(branch => branch.BranchId);
        let oMaps = orgs.map(org => org.OrgId);
        // question/choice maps.
        let slides = qset.slides;
        let slidesMap = slides.map(slide => slide.QSeq);

        r.questions.forEach(ques => {
            // question slide.
            let qseq = Number(ques.QSeq);
            let slide = slides[slidesMap.indexOf(qseq)];
            // load choice on slide.
            let choices = slide.items;
            let choicesMap = choices.map(choice => choice.QSSeq);
            // assign description and choices.
            ques.QSlideText = slide.QSlideText;
            ques.choices = choices;

            ques.orgs.forEach(qorg => {
                // org
                qorg.BranchName = branchs[bMaps.indexOf(qorg.BranchId)].BranchName;
                qorg.OrgName = orgs[oMaps.indexOf(qorg.OrgId)].OrgName;
    
                qorg.items.forEach(qitem => {
                    // choice
                    qitem.QItemText = choices[choicesMap.indexOf(qitem.Choice)].QItemText;
                })
            });
        });
    };

    get result() { return this._result; }
    get report() { return this._service; }
    get No() { return this._no; }
}

SearchResult.ResultCounter = 0;

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

//#region set global ReportService

; (function () {
    //console.log('Init language service...');
    window.report = window.report || new ReportService();
})();

//#endregion

