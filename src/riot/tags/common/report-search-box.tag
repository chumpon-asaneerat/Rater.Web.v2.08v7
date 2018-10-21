<report-search-box>
    <div>
        <div data-is="report-qset-criteria-view" caption="QSets"></div>
        <div data-is="report-question-criteria-view" caption="Questions"></div>
        <div data-is="report-date-criteria-view" caption="Date"></div>
        <div data-is="report-branch-criteria-view" caption="Branchs"></div>
        <div data-is="report-org-criteria-view" caption="Orgs"></div>
        <div data-is="report-staff-criteria-view" caption="Staffs"></div>
        <div ref="tag-input"></div>
        <button ref="search-btn" style="display: inline-block; margin: 0 auto; padding: 0; width: 10%;">Search</button>
    </div>
    <style>
        :scope {
            margin: 0 auto;
            font-size: 14px;
            padding-left: 5%;
        }
    </style>
    <script>
        let self = this;
        this.criteria = report.search.current;

        let taginput = null;
        let autofill = null;
        let searchButton = null;

        let cmd = '';
        let subCmd = '';
        let dateVal = { year: '', month: '', day: '' };
        let clearDate = () => { 
            dateVal.year = '';
            dateVal.month = '';
            dateVal.day = '';
        };

        let bindEvents = () => {
            // event listener for criteria selection Changed.
            self.criteria.qset.changed.add(this.selectionChanged)
            self.criteria.question.changed.add(this.selectionChanged)
            self.criteria.branch.changed.add(this.selectionChanged)
            self.criteria.org.changed.add(this.selectionChanged);
            self.criteria.member.changed.add(this.selectionChanged)
        };

        let unbindEvents = () => {
            // event listener for criteria selection Changed.
            self.criteria.qset.changed.remove(this.selectionChanged)
            self.criteria.question.changed.remove(this.selectionChanged)
            self.criteria.branch.changed.remove(this.selectionChanged)
            self.criteria.org.changed.remove(this.selectionChanged);
            self.criteria.member.changed.remove(this.selectionChanged)
        };

        let newCriteria = (sender, evt) => {
            //console.log('detected new criteria created.');
            unbindEvents();
            self.criteria = report.search.current;
            bindEvents();
            cmd = '';
            subCmd = '';
            clearDate();
            self.refreshDataSource();
        };
        report.search.newCriteriaCreated.add(newCriteria);

        let commands = [
            { id: 1, text: '1.Quetion Set' },
            { id: 2, text: '2.Questions' },
            { id: 3, text: '3.Date' },
            { id: 4, text: '4.Branchs' },
            { id: 5, text: '5.Organizations' },
            { id: 6, text: '6.Staffs' },
            { id: 7, text: '7.Apple' },
            { id: 8, text: '8.Ant' },
            { id: 9, text: '9.Cat' },
            { id: 10, text: '10.Ent' },
        ];

        let hasQSet = () => (self.criteria.qset && self.criteria.qset.QSet) ? true : false;

        let getCommands = () => {
            autofill.datasource = commands;
            autofill.valueMember = 'text';
        }

        let getQSets = () => {
            if (!report.qset) return;
            if (!report.qset.model) return;
            if (!report.qset.model.qsets) return;
            let member = 'QSetDescription';
            let src = report.qset.model.qsets;
            let selects = (hasQSet()) ? [ self.criteria.qset.QSet ] : [];
            let items = NArray.exclude(src, selects, member, true);
            autofill.datasource = items;
            autofill.valueMember = member;
        };

        let getQuestions = () => {
            let qset = self.criteria.qset;
            let ques = self.criteria.question;
            let items = [];
            let member = 'QSlideText';

            if (!ques || !ques.selectedItems || ques.selectedItems.length <= 0) {
                if (qset && qset.QSet) {
                    items = qset.QSet.slides;
                }
            }
            else {                
                if (qset && qset.QSet) {
                    let src = qset.QSet.slides;
                    let selects = ques.selectedItems;
                    items = NArray.exclude(src, selects, member, true);
                }
            }
            autofill.datasource = items;
            autofill.valueMember = member;
        };

        let getDates = () => {
            let member = 'text';
            if (subCmd === '') {
                clearDate();
                subCmd = 'year';
                let items = NArray.Date.getYears(5, true);
                autofill.datasource = items;
                autofill.valueMember = member;
            }
            else if (subCmd === 'year' && dateVal.year.length === 4) {
                subCmd = 'month';
                let items = NArray.Date.getMonths(Number(dateVal.year), true);
                autofill.datasource = items;
                autofill.valueMember = member;
            }
            else  if (subCmd === 'month' && dateVal.month.length > 0) {
                subCmd = 'day';
                let items = NArray.Date.getDays(Number(dateVal.year), Number(dateVal.month), true);
                autofill.datasource = items;
                autofill.valueMember = member;
            }
        };

        let getBranchs = () => {
            if (!report.org) return;
            if (!report.org.model) return;
            if (!report.org.model.branchs) return;
            let member = 'BranchName';
            let src = report.org.model.branchs;
            let selects = self.criteria.branch.selectedItems;
            let items = NArray.exclude(src, selects, member, true);
            autofill.datasource = items;
            autofill.valueMember = member;
        };

        let getOrgs = () => {
            let branch = report.search.current.branch;
            let selectedBranchs = (branch) ? branch.selectedItems : null;
            let org = report.search.current.org;
            let selectedOrgs = (org) ? org.selectedItems : null;
            let items = [];
            let member = 'OrgName';

            let bmaps, omaps;
            let ibrn, iorg;

            if (!selectedBranchs || selectedBranchs.length <= 0) {
                if (!selectedOrgs || selectedOrgs.length <= 0) {
                    //console.log('no selected branchs and no selected orgs');
                    report.org.model.branchs.forEach((brh) => {
                        items.push(...brh.orgs);
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
                                items.push(org);
                            }
                        });
                    });
                }
            }
            else {
                bmaps = selectedBranchs.map(sel => { return sel.BranchId; });
                if (!selectedOrgs || selectedOrgs.length <= 0) {
                    //console.log('has selected branch but no selected orgs');
                    report.org.model.branchs.forEach((brh) => {
                        ibrn = bmaps.indexOf(brh.BranchId);
                        if (ibrn !== -1) {
                            items.push(...brh.orgs);
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
                                items.push(org);
                            }
                        });
                    });
                }
            }
                        
            autofill.datasource = items;
            autofill.valueMember = member;
        };

        let getStaffs = () => {
            if (!report.member) return;
            if (!report.member.model) return;
            if (!report.member.model.members) return;
            let member = 'FullName';
            let src = report.member.model.members;
            let selects = self.criteria.member.selectedItems;
            let items = NArray.exclude(src, selects, member, true);
            autofill.datasource = items;
            autofill.valueMember = member;
        };

        this.refreshDataSource = () => {
            if (!hasQSet()) {
                cmd = 'qset'
                getQSets();
            }
            else {
                if (cmd === '') {
                    getCommands();
                }
                else if (cmd === 'qset') {
                    getQSets();
                }
                else if (cmd === 'question') {
                    getQuestions();
                }
                else if (cmd === 'date') {
                    getDates();
                }
                else if (cmd === 'branch') {
                    getBranchs();
                }
                else if (cmd === 'org') {
                    getOrgs();
                }
                else if (cmd === 'staff') {
                    getStaffs();
                }
                else {

                }
            }
            autofill.refresh();            
        };

        this.selectItem = (sender, evtData) => {
            if (cmd === '') {
                let id = evtData.item.id;
                switch (id) {
                    case 1:
                        cmd = 'qset';
                        break;
                    case 2:
                        cmd = 'question';
                        break;
                    case 3:
                        cmd = 'date';
                        break;
                    case 4:
                        cmd = 'branch';
                        break;
                    case 5:
                        cmd = 'org';
                        break;
                    case 6:
                        cmd = 'staff';
                        break;
                    default:
                        break;
                }
                this.refreshDataSource();
            }
            else if (cmd === 'qset') {
                if (self.criteria) {
                    self.criteria.qset.QSetId = evtData.item.QSetId;
                    cmd = ''; // reset command.
                    this.refreshDataSource();
                }
            }
            else if (cmd === 'question') {
                if (self.criteria) {
                    let id = evtData.item.QSeq;
                    self.criteria.question.add(id);
                    this.refreshDataSource();
                }
            }
            else if (cmd === 'date') {
                let item = evtData.item;
                if (subCmd === 'year') {
                    dateVal.year = item.text;
                    autofill.filter = dateVal.year + '-';
                }
                else if (subCmd === 'month') {
                    dateVal.month = item.text.split('-')[1];
                    autofill.filter = dateVal.year + '-' + dateVal.month + '-';
                }
                else  if (subCmd === 'day') {
                    dateVal.day = item.text.split('-')[2];
                    subCmd = ''; // clear sub command.
                    autofill.filter = '';
                    let dobj = self.criteria.date;
                    if (!dobj.beginDate) {
                        dobj.beginDate = dateVal.year + '-' + dateVal.month + '-' + dateVal.day;
                    }
                    else if (!dobj.endDate) {
                        dobj.endDate = dateVal.year + '-' + dateVal.month + '-' + dateVal.day;
                    }
                    else {
                        // otherwise enter as end date
                        dobj.endDate = dateVal.year + '-' + dateVal.month + '-' + dateVal.day;
                    }
                }
                this.refreshDataSource();
            }
            else if (cmd === 'branch') {
                if (self.criteria) {
                    let id = evtData.item.BranchId;
                    self.criteria.branch.add(id);
                    this.refreshDataSource();
                }
            }
            else if (cmd === 'org') {
                if (self.criteria) {
                    let id = evtData.item.OrgId;
                    self.criteria.org.add(id);
                    this.refreshDataSource();
                }
            }
            else if (cmd === 'staff') {
                if (self.criteria) {
                    let id = evtData.item.MemberId;
                    self.criteria.member.add(id);
                    this.refreshDataSource();
                }
            }
            else {                
            }
        };

        this.inputChanged = (sender, evtData) => {
            if (cmd === 'date') {
                let text = evtData.text;
                let dateparts = text.split('-');
                if (dateparts.length === 1) {
                    subCmd = '';
                    dateVal.year = '';
                    dateVal.month = '';
                    dateVal.day = '';
                    this.refreshDataSource();
                }
                else if (dateparts.length === 2) {
                    subCmd = 'year';
                    dateVal.year = dateparts[0];
                    dateVal.month = '';
                    dateVal.day = '';
                    this.refreshDataSource();
                }
                else if (dateparts.length === 3) {
                    subCmd = 'month';
                    dateVal.year = dateparts[0];
                    dateVal.month = dateparts[1];
                    dateVal.day = '';
                    this.refreshDataSource();
                }
            }
        };

        this.modelChanged = (sender, evtData) => {
            this.refreshDataSource();
        };

        this.selectionChanged = (sender, evtData) => {
            this.refreshDataSource();
        };

        this.showCommands = () => {
            cmd = ''; // reset command
            subCmd = ''; // reset sub command.
            clearDate();            
            this.refreshDataSource();
            autofill.focus();
        };

        this.selectAll = () => {
            if (cmd === 'question') {
                cmd = ''; // reset command
                // map with preserve case.
                let maps = NArray.map(self.criteria.question.slides, 'QSeq', false);
                maps.forEach(id => {
                    self.criteria.question.add(id);
                });
                this.refreshDataSource();
            }
            else if (cmd === 'branch') {
                cmd = ''; // reset command
                // map with preserve case.
                let maps = NArray.map(report.org.model.branchs, 'BranchId', false);
                maps.forEach(id => {
                    self.criteria.branch.add(id);
                });
                this.refreshDataSource();
            }
            else if (cmd === 'org') {
                cmd = ''; // reset command
                // map with preserve case.
                let bmaps = NArray.map(self.criteria.branch.getItems(), 'BranchId', false);
                let items = self.criteria.org.getItems();
                
                items.forEach(item => {
                    if (bmaps.indexOf(item.BranchId) === -1)
                        self.criteria.org.add(item.OrgId);
                });
                this.refreshDataSource();
            }
            else if (cmd === 'staff') {
                cmd = ''; // reset command
                // map with preserve case.
                let maps = NArray.map(report.member.model.members, 'MemberId', false);
                maps.forEach(id => {
                    self.criteria.member.add(id);
                });
                this.refreshDataSource();
            }            
        };

        this.runSearch = (evt) => {
            //console.log('searching...');
            report.search.execute();
            this.criteria = report.search.current;
        };

        // riot handlers.
        this.on('mount', () => {
            // event listener for model changed.
            report.qset.ModelChanged.add(this.modelChanged);
            report.org.ModelChanged.add(this.modelChanged);
            report.member.ModelChanged.add(this.modelChanged);

            bindEvents();

            let opts = {
                buttons: [{
                    name: 'main-menu',
                    align: 'left',
                    css: { class: 'fas fa-caret-square-down' },
                    tooltip: 'Main Menu',
                    click: function (evt, autofill, button) {
                        self.showCommands();                        
                    }
                }, {
                    name: 'select-all',
                    align: 'right',
                    css: { class: 'fas fa-bars' },
                    tooltip: 'Select all',
                    click: function (evt, autofill, button) {
                        self.selectAll();
                    }
                }]
            };

            taginput = this.refs["tag-input"];
            autofill = new NGui.AutoFill(taginput, opts);
            autofill.onSelectItem.add(this.selectItem);
            autofill.onInputChanged.add(this.inputChanged);

            searchButton = new NDOM(this.refs["search-btn"]);
            searchButton.event.add('click', this.runSearch);
        });

        this.on('unmount', () => {
            searchButton.event.remove('click', this.runSearch);

            // event listener for model changed.
            report.qset.ModelChanged.remove(this.modelChanged);
            report.org.ModelChanged.remove(this.modelChanged);
            report.member.ModelChanged.remove(this.modelChanged);

            unbindEvents();

            if (autofill) {
                // cleanup.
                autofill.onSelectItem.remove(this.selectItem);
                autofill.onInputChanged.remove(this.inputChanged);
            }
            autofill = null;
            taginput = null;
        });
    </script>
</report-search-box>
