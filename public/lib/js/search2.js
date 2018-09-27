


//#region AutoFill

class AutoFill {
    constructor(elem) {
        this._dom = {
            root: null,
            menu: null,
            input: null,
            suggest: null,
            select: null,
            droppanel: null
        };

        this._command = '';

        this._commands = [
            { cmd: 'qset', cmdText: '1. Question Set' },
            { cmd: 'qslide', cmdText: '2. Questions' },
            { cmd: 'date', cmdText: '3. Date' },
            { cmd: 'branch', cmdText: '4. Branchs' },
            { cmd: 'org', cmdText: '5. Organizations' },
            { cmd: 'staff', cmdText: '6. Staffs' }
        ];

        this._dates = [
            { dateText: '2018-08-01' },
            { dateText: '2018-08-02' },
            { dateText: '2018-08-03' },
            { dateText: '2018-08-04' }
        ]

        this._ds = new NList();

        this.__init(elem);

        this.__loadCommands();

        let self = this;
        let selectionchanged = (sender, evt) => {
            if (!self.__checkRedirect()) {
                self.resync();
            }
        };
        report.search.current.qset.changed.add(selectionchanged)
        report.search.current.question.changed.add(selectionchanged)
        report.search.current.branch.changed.add(selectionchanged)
        report.search.current.org.changed.add(selectionchanged);
        report.search.current.member.changed.add(selectionchanged)
    };

    // private methods.
    __checkRedirect() {
        // auto check is QSet selected if not automatically let user choose.
        let qset = report.search.current.qset;
        //console.log('Check redirect.');
        if (!qset || !qset.QSet) {
            //console.log('redirect to QSet selection.');
            this.__loadQSets();
            return true;
        }
        return false;
    };

    __loadCommands() {
        this._command = '';
        let getitems = () => { return this._commands; };
        // reset
        this.inputText = '';
        this.suggestText = '';
        this._ds.displayMember = '';
        this._ds.idPropertyName = '';
        this._ds.input = '';

        this._ds.datasource = getitems();
        this._ds.displayMember = 'cmdText';
        this._ds.caseSensitive = false;

        this.refresh();
    };

    __loadQSets() {
        this._command = 'qset';
        let getitems = () => {
            let results = null;
            if (report.qset.model) {
                results = report.qset.model.qsets;
            }
            return results;
        };
        // reset
        this.inputText = '';
        this.suggestText = '';
        this._ds.displayMember = '';
        this._ds.idPropertyName = '';
        this._ds.input = '';

        this._ds.datasource = getitems();
        this._ds.displayMember = 'QSetDescription';
        this._ds.idPropertyName = 'QSetId';
        this._ds.caseSensitive = false;

        this.refresh();
    };

    __loadQSlides() {
        this._command = 'qslide';
        let getitems = () => {
            let results = null;
            let ques = report.search.current.question;
            let selectedQues = (ques) ? ques.selectedItems : null;
            if (!selectedQues || selectedQues.length <= 0) {
                let qset = report.search.current.qset;
                if (qset && qset.QSet) {
                    results = qset.QSet.slides;
                }
            }
            else {
                results = [];
                let qmaps = selectedQues.map(sel => { return sel.QSeq; });
                let qset = report.search.current.qset;
                if (qset && qset.QSet) {
                    qset.QSet.slides.forEach((slide) => {
                        let iques = qmaps.indexOf(slide.QSeq);
                        if (iques === -1) {
                            results.push(slide);
                        }
                    });
                }
            }
            return results;
        };
        // reset
        this.inputText = '';
        this.suggestText = '';
        this._ds.displayMember = '';
        this._ds.idPropertyName = '';
        this._ds.input = '';

        this._ds.datasource = getitems();

        if (this._ds.datasource && this._ds.datasource.length > 0) {
            this._ds.displayMember = 'QSlideText';
            this._ds.idPropertyName = 'QSeq';
            this._ds.caseSensitive = false;

            this.refresh();
        }
        else {
            this.__loadCommands();
        }
    };

    __loadDates() {
        this._command = 'date';
        let getitems = () => {
            return this._dates;
        };
        // reset
        this.inputText = '';
        this.suggestText = '';
        this._ds.displayMember = '';
        this._ds.idPropertyName = '';
        this._ds.input = '';

        this._ds.datasource = getitems();
        this._ds.displayMember = 'dateText';
        this._ds.caseSensitive = false;

        this.refresh();
    };

    __loadBranchs() {
        this._command = 'branch';
        let getitems = () => {
            let results = null;
            let branch = report.search.current.branch;
            let selectedBranchs = (branch) ? branch.selectedItems : null;
            if (!selectedBranchs || selectedBranchs.length <= 0) {
                results = report.org.model.branchs;
            }
            else {
                results = [];
                let bmaps = selectedBranchs.map(sel => { return sel.BranchId; });
                report.org.model.branchs.forEach((brh) => {
                    let ibrh = bmaps.indexOf(brh.BranchId);
                    if (ibrh === -1) {
                        results.push(brh);
                    }
                });
            }
            return results;
        };
        // reset
        this.inputText = '';
        this.suggestText = '';
        this._ds.displayMember = '';
        this._ds.idPropertyName = '';
        this._ds.input = '';

        this._ds.datasource = getitems();

        if (this._ds.datasource && this._ds.datasource.length > 0) {
            this._ds.displayMember = 'BranchName';
            this._ds.idPropertyName = 'BranchId';
            this._ds.caseSensitive = false;

            this.refresh();
        }
        else {
            this.__loadCommands();
        }
    };

    __loadOrgs() {
        this._command = 'org';
        let getitems = () => {
            let results = null;
            let branch = report.search.current.branch;
            let selectedBranchs = (branch) ? branch.selectedItems : null;

            let org = report.search.current.org;
            let selectedOrgs = (org) ? org.selectedItems : null;
            let bmaps, omaps;
            let ibrn, iorg;

            if (!selectedBranchs || selectedBranchs.length <= 0) {
                results = [];
                if (!selectedOrgs || selectedOrgs.length <= 0) {
                    //console.log('no selected branchs and no selected orgs');
                    report.org.model.branchs.forEach((brh) => {
                        results.push(...brh.orgs);
                    });
                }
                else {
                    //console.log('no selected branchs but has selected orgs');
                    omaps = selectedOrgs.map(sel => { return sel.OrgId; })
                    //console.log(omaps);
                    report.org.model.branchs.forEach((brh) => {
                        brh.orgs.forEach((org) => {
                            iorg = omaps.indexOf(org.OrgId);
                            if (iorg === -1) {
                                // org is not already selected.
                                results.push(org);
                            }
                        });
                    });
                }
            }
            else {
                results = [];
                bmaps = selectedBranchs.map(sel => { return sel.BranchId; });
                if (!selectedOrgs || selectedOrgs.length <= 0) {
                    //console.log('has selected branch but no selected orgs');
                    report.org.model.branchs.forEach((brh) => {
                        ibrn = bmaps.indexOf(brh.BranchId);
                        if (ibrn !== -1) {
                            results.push(...brh.orgs);
                        }
                    });
                }
                else {
                    //console.log('has selected branch and selected orgs');
                    omaps = selectedOrgs.map(sel => { return sel.OrgId; })
                    selectedBranchs.forEach((brh) => {
                        brh.orgs.forEach((org) => {
                            iorg = omaps.indexOf(org.OrgId);
                            if (iorg === -1) {
                                // org is not already selected.
                                results.push(org);
                            }
                        });
                    });
                }
            }
            return results;
        };
        // reset
        this.inputText = '';
        this.suggestText = '';
        this._ds.displayMember = '';
        this._ds.idPropertyName = '';
        this._ds.input = '';

        this._ds.datasource = getitems();

        if (this._ds.datasource && this._ds.datasource.length > 0) {
            this._ds.displayMember = 'OrgName';
            this._ds.idPropertyName = 'OrgId';
            this._ds.caseSensitive = false;

            this.refresh();
        }
        else {
            this.__loadCommands();
        }
    };

    __loadStaffs() {
        this._command = 'staff';
        let getitems = () => {
            let results = null;
            let member = report.search.current.member;
            let selectedMembers = (member) ? member.selectedItems : null;
            if (!selectedMembers || selectedMembers.length <= 0) {
                results = report.member.model.members;
            }
            else {
                results = [];
                let mmaps = selectedMembers.map(sel => { return sel.MemberId; });
                report.member.model.members.forEach((mem) => {
                    let imem = mmaps.indexOf(mem.MemberId);
                    if (imem === -1) {
                        results.push(mem);
                    }
                });
            }
            return results;
        };
        // reset
        this.inputText = '';
        this.suggestText = '';
        this._ds.displayMember = '';
        this._ds.idPropertyName = '';
        this._ds.input = '';

        this._ds.datasource = getitems();

        if (this._ds.datasource && this._ds.datasource.length > 0) {
            this._ds.displayMember = 'FullName';
            this._ds.idPropertyName = 'MemberId';
            this._ds.caseSensitive = false;

            this.refresh();
        }
        else {
            this.__loadCommands();
        }
    };

    /*
    // dom creation methods.
    __init(elem) {
        if (!elem || !this.dom) return;
        this.dom.root = new NDOM(elem);
        this.__createRootElement();
        this.__createMenuElement();
        this.__createInputElement();
        this.__createSuggestElement();
        this.__createSelectAllElement();
        this.__createDropPanelElement();
    };
    */
    /*
    __createRootElement() {
        if (!this.dom || !this.dom.root) return;

        let root = this.dom.root;
        root.addClass('auto-fill');
        // setup listeners.
        let self = this;
        root.addEvent('click', self.__on_root_click.bind(self));
    };
    */
    /*
    __createMenuElement() {
        if (!this.dom || !this.dom.root) return;
        this.dom.menu = new NDOM(NDOM.createElement('a'));
        let menu = this.dom.menu;

        let span = new NDOM(NDOM.createElement('span'));
        span.addClass('fas');
        span.addClass('fa-arrow-up');
        span.attr('href', 'javascript:;');
        span.style('display', 'inline-block');
        span.style('margin', '0 auto');
        span.style('margin-right', '3px');
        span.style('padding', '0');
        span.style('cursor', 'pointer');

        menu.addChild(span);

        // setup listeners.
        let self = this;
        menu.addEvent('click', self.__on_menu_click.bind(self));

        this.dom.root.addChild(menu);
    };
    */
    /*
    __createInputElement() {
        if (!this.dom || !this.dom.root) return;
        this.dom.input = new NDOM(NDOM.createElement('span'));

        let input = this.dom.input;
        input.addClass('input-text');
        input.attr('contenteditable', 'true');
        input.element.textContent = '';
        // setup listeners.
        let self = this;
        input.addEvent('focus', self.__on_input_gotfocus.bind(self));
        input.addEvent('blur', self.__on_input_lostfocus.bind(self));
        input.addEvent('input', self.__on_input_input.bind(self));
        input.addEvent('keydown', self.__on_input_keydown.bind(self));

        this.dom.root.addChild(input);
    };
    */
    /*
    __createSuggestElement() {
        if (!this.dom || !this.dom.root) return;
        this.dom.suggest = new NDOM(NDOM.createElement('span'));

        let suggest = this.dom.suggest;
        suggest.addClass('suggest-text');
        suggest.element.textContent = '';

        this.dom.root.addChild(suggest);
    };
    */
    /*
    __createSelectAllElement() {
        if (!this.dom || !this.dom.root) return;
        this.dom.select = new NDOM(NDOM.createElement('a'));
        let select = this.dom.select;

        let span = new NDOM(NDOM.createElement('span'));
        span.addClass('far');
        span.addClass('fa-check-square');
        span.attr('href', 'javascript:;');
        span.style('display', 'inline-block');
        span.style('float', 'right');
        span.style('margin', '0 auto');
        span.style('margin-left', '3px');
        span.style('padding', '0');
        span.style('padding-top', '2px');
        span.style('cursor', 'pointer');
        select.addChild(span);
        // setup listeners.
        let self = this;
        select.addEvent('click', self.__on_selectAll_click.bind(self));

        this.dom.root.addChild(select);
    };
    */
    /*
    __createDropPanelElement() {
        if (!this.dom || !this.dom.root) return;
        this.dom.droppanel = new NDOM(NDOM.createElement('div'));

        let droppanel = this.dom.droppanel;
        droppanel.addClass('drop-panel');
        droppanel.addClass('hide');

        this.dom.root.addChild(droppanel);
    };
    */
    /*
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
    */
   /*
    get isdroped() {
        if (!this.dom || !this.dom.droppanel) return false;
        if (!this.dom.droppanel.element) return false;
        let isHide = this.dom.droppanel.hasClass('hide');
        //console.log('Is Hide:', isHide);
        return !isHide;
    };
    */
    /*
    dropdown() {
        if (!this.dom || !this.dom.droppanel) return;
        if (!this.dom.droppanel.element) return;
        this.dom.droppanel.removeClass('hide');
        if (!this.dom.root || !this.dom.root.element) return;
        let rootEl = this.dom.root.element;
        // recalc position.
        let top = rootEl.offsetTop + rootEl.offsetHeight + 1;
        let left = rootEl.offsetLeft;
        let right = rootEl.offsetLeft; // same as left.
        let droppn = this.dom.droppanel;
        droppn.style('left', left + 'px');
        droppn.style('right', right + 'px');
        droppn.style('top', top + 'px');
    };
    */
    /*
    close() {
        if (!this.dom || !this.dom.droppanel) return;
        if (!this.dom.droppanel.element) return;
        this.dom.droppanel.addClass('hide');
    };
    */

    refresh() {
        if (!this.dom || !this.dom.droppanel) return;
        if (!this.items) return;
        let self = this;
        //let droppanel = this.dom.droppanel.element;
        let droppanel = this.dom.droppanel;
        let sinput = this.inputText;
        let pName = this.displayMember;
        droppanel.clearChildren();
        this.items.forEach(item => {
            let iMatch = item.indexOf(sinput);
            if (iMatch !== -1) {
                let obj = self._ds.findItem(item);
                let itemdiv = new NDOM(NDOM.createElement('div'));
                itemdiv.attr('href', 'javascript:;');
                itemdiv.attr('item-value', String(obj[pName])); // set item-id
                itemdiv.addClass('auto-fill-item');
                // set event listener
                itemdiv.addEvent('mousedown', self.__on_item_mdown.bind({
                    self: self,
                    target: itemdiv.element
                }));
                itemdiv.addEvent('mouseup', self.__on_item_mup.bind({
                    self: self,
                    target: itemdiv.element
                }));

                droppanel.addChild(itemdiv);

                let pretext = item.substr(0, iMatch);
                let posttext = item.substr(iMatch + sinput.length, item.length);
                let preSpan = new NDOM(NDOM.createElement('span'));
                preSpan.element.textContent = pretext;
                itemdiv.addChild(preSpan);

                let inputBold = new NDOM(NDOM.createElement('b'));
                inputBold.element.textContent = sinput;
                itemdiv.addChild(inputBold);

                let postSpan = new NDOM(NDOM.createElement('span'));
                postSpan.element.textContent = posttext;
                itemdiv.addChild(postSpan);
            }
        });

        let existitems = droppanel.element.getElementsByClassName('auto-fill-item');
        //console.log(existitems);
        if (existitems && existitems.length > 0) {
            //existitems[0].classList.add('selected');
            if (!this.isdroped) {
                //console.log('Not drop');        
            }
            else {
                //console.log('already drop');
                this.dropdown();
            }
        }
        else {
            this.close();
        }
    };

    selectAll() {
        if (this._command !== '' && this._command !== 'qset' && this._command !== 'date') {
            if (this._ds && this._ds.datasource && this._ds.datasource.length > 0) {
                let self = this;
                let pName = String(this._ds.idPropertyName);
                let selmaps = this._ds.datasource.map((elem) => { return elem[pName]; });
                //console.log(selmaps);
                if (selmaps && selmaps.length > 0) {
                    selmaps.forEach((id) => {
                        switch (self._command) {
                            case 'qslide':
                                //console.log('add question id:', id);
                                report.search.current.question.add(id);
                                break;
                            case 'branch':
                                //console.log('add branch id:', id);
                                report.search.current.branch.add(id);
                                break;
                            case 'org':
                                //console.log('add org id:', id);
                                report.search.current.org.add(id);
                                break;
                            case 'staff':
                                //console.log('add member id:', id);
                                report.search.current.member.add(id);
                                break;
                        }
                    });
                }
            }
        }
    };

    // event handlers.
    /*
    __on_root_click(evt) {
        let self = this;
        // find range to setup cursor at last character's position.
        self.setEndOfContenteditable(self.dom.input.element);
        self.focus();
    };
    */
    /*
    focus() {
        // move focus to input element.
        let self = this;
        setTimeout(function () {
            self.dom.input.element.focus();
        }, 0);
    };
    */
    /*
    __on_menu_click(evt) {
        evt.preventDefault();
        evt.stopPropagation();
        let self = this;
        if (!self.__checkRedirect()) {
            self.__loadCommands();
            self.dropdown();
        }

        return false;
    };
    */
    /*
    __on_selectAll_click(evt) {
        evt.preventDefault();
        evt.stopPropagation();

        let self = this;
        if (self._command !== '' && self._command !== 'qset' && self._command !== 'date') {
            self.selectAll();
        }

        return false;
    };
    */
    /*
    __on_input_gotfocus(evt) {
        let self = this;
        self.__checkRedirect();
        self.dropdown();
        self.refresh();
    };
    */
    /*
    __on_input_lostfocus(evt) {
        let self = this;
        self.close();
    };
    */
    __on_input_input(evt) {
        let self = this;
        if (!self.isdroped) self.dropdown();


        let ipt = self.inputText;
        self._ds.input = ipt; // apply input to data source to filter items.
        let text = self.selectedText;
        let bFound = false;

        //freakin NO-BREAK SPACE needs extra care
        if (this.caseSensitive) {
            bFound = (text && text.indexOf(ipt) === 0);
        }
        else {
            bFound = (text && text.toLowerCase().indexOf(ipt.toLowerCase()) === 0);
        }
        if (bFound) {
            let suggestText = text.substr(ipt.length, text.length);
            self.suggestText = suggestText;
        }
        else {
            self.suggestText = '';
        }

        self.refresh(); // refresh drop items.
    };

    __on_input_keydown(evt) {
        let self = this;

        switch (evt.key) {
            case 'Enter':
                evt.preventDefault();
                evt.stopPropagation();
                self.selectItem(self.selectedText);
                break;
            case 'Escape':
            case '?':
            case '@':
                evt.preventDefault();
                evt.stopPropagation();
                if (!self.__checkRedirect()) {
                    self.__loadCommands();
                }
                break;
            case 'ArrowUp':
                evt.preventDefault();
                evt.stopPropagation();

                break;
            case 'ArrowDown':
                evt.preventDefault();
                evt.stopPropagation();

                break;
            default:
                //console.log(evt);
                break;
        };
    };

    __on_item_mdown(evt) {
        evt.preventDefault(); // stop raise lost focus when click on item.
    };

    __on_item_mup(evt) {
        let self = this.self;
        let target = this.target;
        let val = (target) ? String(target.getAttribute('item-value')) : null;
        if (val && self) {
            evt.preventDefault();
            evt.stopPropagation();
            //console.log(self, val);
            self.selectItem(val);
        }
    };
    // dom related public properties.
    get dom() { return this._dom; };
    get inputText() {
        if (!this.dom || !this.dom.input) return null;
        return this.dom.input.element.textContent;
    };
    set inputText(value) {
        if (!this.dom || !this.dom.input) return;
        this.dom.input.element.textContent = value;
    };
    get suggestText() {
        if (!this.dom || !this.dom.suggest) return null;
        return this.dom.suggest.element.textContent;
    };
    set suggestText(value) {
        if (!this.dom || !this.dom.suggest) return;
        this.dom.suggest.element.textContent = value;
    };
    // datasource related public properties.
    get datasource() {
        return (this._ds) ? this._ds.datasource : null;
    };
    set datasource(value) {
        if (!this._ds) return;
        this._ds.datasource = value;
    };
    get displayMember() {
        return (this._ds) ? this._ds.displayMember : null;
    };
    set displayMember(value) {
        if (!this._ds) return;
        this._ds.displayMember = value;
    };
    get idPropertyName() {
        return (this._ds) ? this._ds.idPropertyName : null;
    };
    set idPropertyName(value) {
        if (!this._ds) return;
        this._ds.idPropertyName = value;
    };
    get caseSensitive() {
        return (this._ds) ? this._ds.caseSensitive : null;
    };
    set caseSensitive(value) {
        if (!this._ds) return;
        this._ds.caseSensitive = value;
    };
    get items() {
        return (this._ds) ? this._ds.items : null;
    };
    get selectedText() {
        return (this._ds) ? this._ds.selectedText : '';
    };
    indexOf(value) {
        if (!this._ds) return -1;
        return this._ds.indexOf(value);
    };
    findItem(value) {
        if (!this._ds) return null;
        return this._ds.findItem(value);
    };

    resync() {
        if (this._command === '') {
            this.__loadCommands();
        }
        else if (this._command === 'qset') {
            this.__loadQSets();
        }
        else if (this._command === 'qslide') {
            this.__loadQSlides();
        }
        else if (this._command === 'date') {
            this.__loadDates();
        }
        else if (this._command === 'branch') {
            this.__loadBranchs();
        }
        else if (this._command === 'org') {
            this.__loadOrgs();
        }
        else if (this._command === 'staff') {
            this.__loadStaffs();
        }
    };
    selectItem(value) {
        if (!this._ds) return null;
        let item = this._ds.findItem(value);
        //console.log(item);
        if (this._command === '') {
            if (item.cmd === 'qset') {
                this.__loadQSets();
                this.focus();
            }
            else if (item.cmd === 'qslide') {
                this.__loadQSlides();
                this.focus();
            }
            else if (item.cmd === 'date') {
                this.__loadDates();
                this.focus();
            }
            else if (item.cmd === 'branch') {
                this.__loadBranchs();
                this.focus();
            }
            else if (item.cmd === 'org') {
                this.__loadOrgs();
                this.focus();
            }
            else if (item.cmd === 'staff') {
                this.__loadStaffs();
                this.focus();
            }
        }
        else {
            switch (this._command) {
                case 'qset':
                    report.search.current.qset.QSetId = item.QSetId;
                    this.__loadCommands();
                    this.focus();
                    break;
                case 'qslide':
                    report.search.current.question.add(item.QSeq);
                    this.__loadQSlides();
                    this.focus();
                    break;
                case 'date':
                    report.search.current.date.beginDate = item.dateText;
                    report.search.current.date.endDate = item.dateText;
                    this.__loadCommands();
                    this.focus();
                    break;
                case 'branch':
                    report.search.current.branch.add(item.BranchId);
                    this.__loadBranchs();
                    this.focus();
                    break;
                case 'org':
                    report.search.current.org.add(item.OrgId);
                    this.__loadOrgs();
                    this.focus();
                    break;
                case 'staff':
                    report.search.current.member.add(item.MemberId);
                    this.__loadStaffs();
                    this.focus();
                    break;
            }
        }
    };
};

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

//#region ReportService

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

//#endregion
