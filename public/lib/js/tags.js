riot.tag2('dashboard-content', '<yield></yield>', '', 'class="dashboard-content"', function(opts) {
});

riot.tag2('page-content-relative', '<h3>Content gone below.</h3> <yield></yield> <h3>Content end here.</h3>', 'page-content-relative,[data-is="page-content-relative"]{ margin: 1px auto; padding: 1px; }', '', function(opts) {
});
riot.tag2('page-content-absolute', '<div id="page-content-abs" class="container-fluid"> <yield></yield> </div>', 'page-content-absolute,[data-is="page-content-absolute"]{ margin: 1px auto; padding: 1px; position: absolute; top: 3em; bottom: 2em; left: 1px; right: 4px; overflow-x: hidden; overflow-y: auto; }', '', function(opts) {


        let self = this;
        this.uid = nlib.utils.newUId();

});
riot.tag2('page-footer', '<span class="float-left m-0 p-0"> <virtual if="{(page.model && page.model.footer && page.model.footer.label)}"> <label class="m-0 p-1">&nbsp;{page.model.footer.label.status}&nbsp;:</label> <div class="v-divider">&nbsp;</div> </virtual> </span> <span class="float-right m-0 p-0 ml-auto"> <div class="v-divider"></div> <label class="m-0 p-1"> &nbsp; <span id="user-info" class="fas fa-user-circle"></span> <virtual if="{secure.current}"> <span class="user-fullname">&nbsp; {secure.currentUserName} &nbsp;</span> </virtual> </label> <div class="copyright"> <div class="v-divider"></div> <virtual if="{(page.model && page.model.footer && page.model.footer.label)}"> <label class="m-0 p-1">&copy;&nbsp;{page.model.footer.label.copyright}&nbsp;&nbsp;&nbsp;</label> </virtual> </div> </span>', 'page-footer,[data-is="page-footer"],page-footer .navbar,[data-is="page-footer"] .navbar,page-footer .nav,[data-is="page-footer"] .nav,page-footer span,[data-is="page-footer"] span{ margin: 0 auto; padding: 0; } page-footer label,[data-is="page-footer"] label{ color: whitesmoke; font-size: 0.95em; font-weight: bold; } page-footer .v-divider,[data-is="page-footer"] .v-divider{ display: inline; margin-left: 2px; margin-right: 2px; border-left: 1px solid whitesmoke; } page-footer .copyright,[data-is="page-footer"] .copyright{ display: inline-block; margin: 0 auto; padding: 0; } @media screen and (max-width: 800px) { page-footer .user-fullname,[data-is="page-footer"] .user-fullname{ display: none; } } @media screen and (max-width: 600px) { page-footer .user-fullname,[data-is="page-footer"] .user-fullname{ display: none; } page-footer .copyright,[data-is="page-footer"] .copyright{ display: none; } }', 'class="navbar fixed-bottom m-0 p-0 navbar-light bg-primary"', function(opts) {

        let self = this;

        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);

        let onCurrentUserChanged = (sender, evtData) => { self.update(); };
        secure.currentUserChanged.add(onCurrentUserChanged);
});
riot.tag2('page-nav-bar', '<div class="navbar navbar-expand-sm fixed-top navbar-dark bg-primary m-0 p-1"> <virtual if="{(page.model && page.model.banner)}"> <a href="{page.model.banner.url}" class="navbar-band m-1 p-0 align-middle"> <div class="d-inline-block"> <virtual if="{(page.model.banner.type === \'image\')}"> <div class="d-inline-block m-0 p-0"> <img riot-src="{page.model.banner.src}" class="d-inline-block m-0 p-0 logo"> </div> </virtual> <virtual if="{(page.model.banner.type===\'font\')}"> <div class="d-inline-block m-0 p-0"> <span class="fas fa-{page.model.banner.src} navbar-text w-auto m-0 p-0"> <virtual if="{(page.model.banner.text !==\'\')}" class="d-inline-block m-0 p-0"> <span class="rater-text w-auto m-0 p-0 banner-text"> &nbsp;&nbsp;{page.model.banner.text}&nbsp;&nbsp; </span> </virtual> </span> </div> </virtual> </div> </a> </virtual> <div class="d-flex flex-row order-2 order-sm-3 order-md-3 order-lg-3"> <ul class="navbar-nav flex-row ml-auto"> <virtual if="{(page.model.nav.signout)}"> <li class="nav-item"> <a href="{page.model.nav.signout.url}" class="nav-link py-2 align-middle" onclick="{onSignOut}"> <div class="d-inline-block"> <virtual if="{(page.model.nav.signout.type===\'font\')}"> <div class="v-divider"></div> <span>&nbsp;</span> <div class="d-inline-block m-0 p-0"> <span class="fas fa-{page.model.nav.signout.src} navbar-text w-auto m-0 p-0"> <virtual if="{(page.model.nav.signout.text !==\'\')}"> <span class="rater-text w-auto m-0 p-0 signout"> &nbsp;{page.model.nav.signout.text}&nbsp; </span> </virtual> </span> </div> <div class="v-divider"></div> <span>&nbsp;</span> </virtual> </div> </a> </li> </virtual> <li class="nav-item dropdown"> <a class="nav-link dropdown-toggle px-2 align-middle" data-toggle="dropdown" href="javascript:void(0);" id="nav-languages"> <span class="flag-icon flag-icon-{lang.current.flagId.toLowerCase()}"></span> <span class="lang-text">&nbsp;&nbsp;{lang.current.DescriptionNative}&nbsp;&nbsp;</span> <span class="caret"></span> </a> <div class="dropdown-menu dropdown-menu-right" aria-labelledby="nav-languages"> <virtual each="{eachlang in lang.languages}"> <a class="dropdown-item {(lang.current.flagId === eachlang.flagId) ? \'active\': \'\'}" href="javascript:void(0);" langid="{eachlang.langId}" onclick="{onChangeLanguage}"> <span class="flag-icon flag-icon-{eachlang.flagId.toLowerCase()}"></span> <span class="">&nbsp;&nbsp;{eachlang.DescriptionNative}&nbsp;&nbsp;</span> </a> </virtual> </div> </li> </ul> <virtual if="{(page.model && page.model.nav && page.model.nav.links && page.model.nav.links.length> 0)}"> <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar"> <span class="navbar-toggler-icon"></span> </button> </virtual> </div> <div class="collapse navbar-collapse m-0 p-0 order-3 order-sm-2 order-md-2 order-lg-2" id="collapsibleNavbar"> <ul class="navbar-nav"> <virtual if="{(page.model && page.model.nav && page.model.nav.links && page.model.nav.links.length > 0)}"> <virtual each="{link in page.model.nav.links}"> <li class="nav-item {(link.active === \'active\' || link.active === \'true\') ? \'active\' : \'\'}"> <a class="nav-link align-middle" href="{link.url}"> <span>&nbsp;</span> <div class="v-divider"></div> <span>&nbsp;</span> <virtual if="{(link.type===\'image\')}"> <div class="d-inline-block m-0 p-0"> <img riot-src="{link.src}" class="d-inline-block m-0 p-0 menu-img"> <virtual if="{(link.text !== \'\')}" class="d-inline-block m-0 p-0"> <span class="rater-text w-auto m-0 p-0"> &nbsp;{link.text}&nbsp; </span> </virtual> </div> </virtual> <virtual if="{(link.type===\'font\')}"> <div class="d-inline-block m-0 p-0"> <span class="fas fa-{src} navbar-text w-auto m-0 p-0"> <virtual if="{(link.text !== \'\')}" class="d-inline-block m-0 p-0"> <span class="rater-text w-auto m-0 p-0"> &nbsp;{link.text}&nbsp; </span> </virtual> </span> </div> </virtual> <virtual if="{(link.type===\'none\' || type===\'\')}"> <div class="d-inline-block m-0 p-0"> <virtual if="{(link.text !== \'\')}"> <div class="d-inline-block m-0 p-0"> <span class="rater-text w-auto m-0 p-0"> &nbsp;{link.text}&nbsp; </span> </div> </virtual> </div> </virtual> </a> </li> </virtual> </virtual> </ul> </div> </div>', 'page-nav-bar,[data-is="page-nav-bar"]{ padding-top: 2px; padding-bottom: 0px; font-size: 1em; } page-nav-bar .logo,[data-is="page-nav-bar"] .logo{ height: 28px; } page-nav-bar .menu-img,[data-is="page-nav-bar"] .menu-img{ height: 1em; } page-nav-bar .rater-text,[data-is="page-nav-bar"] .rater-text{ font-family: "Lucida Sans Unicode", sans-serif; } page-nav-bar .v-divider,[data-is="page-nav-bar"] .v-divider{ display: inline; margin-left: 2px; margin-right: 2px; border-left: 1px solid whitesmoke; } page-nav-bar a:hover .v-divider,[data-is="page-nav-bar"] a:hover .v-divider{ border-color: white; } page-nav-bar a:hover .fas,[data-is="page-nav-bar"] a:hover .fas{ color: white; } page-nav-bar a:hover .rater-text,[data-is="page-nav-bar"] a:hover .rater-text{ color: white; } page-nav-bar .signout,[data-is="page-nav-bar"] .signout{ display: inline-block; } page-nav-bar .banner-text,[data-is="page-nav-bar"] .banner-text{ display: inline-block; } page-nav-bar .lang-text,[data-is="page-nav-bar"] .lang-text{ display: inline-block; } @media screen and (max-width: 800px) { page-nav-bar .signout,[data-is="page-nav-bar"] .signout{ display: none; } page-nav-bar .lang-text,[data-is="page-nav-bar"] .lang-text{ display: none; } } @media screen and (max-width: 600px) { page-nav-bar .signout,[data-is="page-nav-bar"] .signout{ display: none; } page-nav-bar .lang-text,[data-is="page-nav-bar"] .lang-text{ display: none; } page-nav-bar .banner-text,[data-is="page-nav-bar"] .banner-text{ display: none; } }', 'class="container-fluid"', function(opts) {

        let self = this;

        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);

        this.onChangeLanguage = (e) => {
            e.preventDefault();
            let selLang = e.item.eachlang
            let langId = selLang.langId;
            lang.change(langId);
            e.preventUpdate = true;
        };

        this.onSignOut = (e) => {
            e.preventDefault();
            secure.signOut();
            e.preventUpdate = true;
        };
});
riot.tag2('report-branch-criteria-view', '<div ref="tag-branch"></div>', 'report-branch-criteria-view,[data-is="report-branch-criteria-view"]{ margin: 0 auto; }', '', function(opts) {
        let self = this;

        this.caption = this.opts.caption;
        this.criteria = report.search.current;
        let elem, tagbox;

        let bindEvents = () => {
            self.criteria.branch.changed.add(changed);
        };

        let unbindEvents = () => {
            self.criteria.branch.changed.remove(changed);
        };

        let newCriteria = (sender, evt) => {

            unbindEvents();
            self.criteria = report.search.current;
            bindEvents();
            tagbox.items = getItems();
        };
        report.search.newCriteriaCreated.add(newCriteria);

        let changed = (sender, evt) => {

            tagbox.items = getItems();
        };

        let getItems = () => {
            if (!self.criteria) return [];
            if (!self.criteria.branch) return [];
            return self.criteria.branch.selectedItems;
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.branch) return;
            self.criteria.branch.clear();

        };
        let removeItem = (sender, evtData) => {
            let target = sender;
            let id = target.BranchId;
            let removeIndex = self.criteria.branch.indexOf(id);
            self.criteria.branch.remove(removeIndex);

        };

        this.on('mount', () => {
            bindEvents();

            elem = this.refs["tag-branch"];
            tagbox = new NGui.TagBox(elem);

            tagbox.caption = 'Branchs';
            tagbox.valueMember = 'BranchName';

            tagbox.clearItems.add(clearItems);
            tagbox.removeItem.add(removeItem);
        });

        this.on('unmount', () => {
            unbindEvents();

            if (tagbox) {

                tagbox.clearItems.remove(clearItems);
                tagbox.removeItem.remove(removeItem);
            }
            tagbox = null;
            elem = null;
        });
});
riot.tag2('report-date-criteria-view', '<div ref="tag-date"></div>', 'report-date-criteria-view,[data-is="report-date-criteria-view"]{ margin: 0 auto; }', '', function(opts) {
        let self = this;

        this.caption = this.opts.caption;
        this.criteria = report.search.current;
        let elem, tagbox;

        let bindEvents = () => {
            self.criteria.date.changed.add(changed);
        };

        let unbindEvents = () => {
            self.criteria.date.changed.remove(changed);
        };

        let newCriteria = (sender, evt) => {

            unbindEvents();
            self.criteria = report.search.current;
            bindEvents();
            tagbox.items = getItems();
        };
        report.search.newCriteriaCreated.add(newCriteria);

        let changed = (sender, evt) => {

            tagbox.items = getItems();
        };

        let getItems = () => {
            if (!self.criteria) return [];
            if (!self.criteria.date) return [];
            let results = [];
            let dobj = self.criteria.date;
            if (dobj.beginDate) {
                results.push({ id: 1, text: dobj.beginDate })
                if (dobj.endDate) {
                    results.push({ id: 2, text: dobj.endDate })
                }
            }
            return results;
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.date) return;
            self.criteria.date.clear();
        };
        let removeItem = (sender, evtData) => {
            let target = sender;
            let id = target.id;
            if (id === 1)
                self.criteria.date.clear();
            else {
                self.criteria.date.endDate = null;
            }
        };

        this.on('mount', () => {
            bindEvents();

            elem = this.refs["tag-date"];
            tagbox = new NGui.TagBox(elem);

            tagbox.caption = 'Date';
            tagbox.itemSeparator = '-';
            tagbox.valueMember = 'text';

            tagbox.clearItems.add(clearItems);
            tagbox.removeItem.add(removeItem);
        });

        this.on('unmount', () => {
            unbindEvents();

            if (tagbox) {

                tagbox.clearItems.remove(clearItems);
                tagbox.removeItem.remove(removeItem);
            }
            tagbox = null;
            elem = null;
        });
});
riot.tag2('report-org-criteria-view', '<div ref="tag-org"></div>', 'report-org-criteria-view,[data-is="report-org-criteria-view"]{ margin: 0 auto; }', '', function(opts) {
        let self = this;

        this.caption = this.opts.caption;
        this.criteria = report.search.current;
        let elem, tagbox;

        let bindEvents = () => {
            self.criteria.org.changed.add(changed);
        };

        let unbindEvents = () => {
            self.criteria.org.changed.remove(changed);
        };

        let newCriteria = (sender, evt) => {

            unbindEvents();
            self.criteria = report.search.current;
            bindEvents();
            tagbox.items = getItems();
        };
        report.search.newCriteriaCreated.add(newCriteria);

        let changed = (sender, evt) => {

            tagbox.items = getItems();
        };

        let getItems = () => {
            if (!self.criteria) return [];
            if (!self.criteria.org) return [];
            return self.criteria.org.selectedItems;
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.member) return;
            self.criteria.org.clear();
        };
        let removeItem = (sender, evtData) => {
            let target = sender;
            let id = target.OrgId;
            let removeIndex = self.criteria.org.indexOf(id);
            self.criteria.org.remove(removeIndex);
        };

        this.on('mount', () => {
            bindEvents();

            elem = this.refs["tag-org"];
            tagbox = new NGui.TagBox(elem);

            tagbox.caption = 'Organizations';
            tagbox.valueMember = 'OrgName';

            tagbox.clearItems.add(clearItems);
            tagbox.removeItem.add(removeItem);
        });

        this.on('unmount', () => {
            unbindEvents();

            if (tagbox) {

                tagbox.clearItems.remove(clearItems);
                tagbox.removeItem.remove(removeItem);
            }
            tagbox = null;
            elem = null;
        });
});
riot.tag2('report-qset-criteria-view', '<div ref="tag-qset"></div>', 'report-qset-criteria-view,[data-is="report-qset-criteria-view"]{ margin: 0 auto; }', '', function(opts) {
        let self = this;

        this.caption = this.opts.caption;
        this.criteria = report.search.current;
        let elem, tagbox;

        let bindEvents = () => {
            self.criteria.qset.changed.add(changed);
        };

        let unbindEvents = () => {
            self.criteria.qset.changed.remove(changed);
        };

        let newCriteria = (sender, evt) => {

            unbindEvents();
            self.criteria = report.search.current;
            bindEvents();
            tagbox.items = getItems();
        };
        report.search.newCriteriaCreated.add(newCriteria);

        let changed = (sender, evt) => {

            tagbox.items = getItems();
        };

        let getItems = () => {
            if (!self.criteria) return [];
            if (!self.criteria.qset) return [];
            if (!self.criteria.qset.QSet) return [];
            return [ self.criteria.qset.QSet ];
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.qset) return;
            self.criteria.qset.QSetId = '';
        };
        let removeItem = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.qset) return;
            self.criteria.qset.QSetId = '';
        };

        this.on('mount', () => {
            bindEvents();

            elem = this.refs["tag-qset"];
            tagbox = new NGui.TagBox(elem);

            tagbox.caption = 'QSets';
            tagbox.valueMember = 'QSetDescription';

            tagbox.clearItems.add(clearItems);
            tagbox.removeItem.add(removeItem);
        });

        this.on('unmount', () => {
            unbindEvents();

            if (tagbox) {

                tagbox.clearItems.remove(clearItems);
                tagbox.removeItem.remove(removeItem);
            }
            tagbox = null;
            elem = null;
        });
});
riot.tag2('report-question-criteria-view', '<div ref="tag-ques"></div>', 'report-question-criteria-view,[data-is="report-question-criteria-view"]{ margin: 0 auto; }', '', function(opts) {
        let self = this;

        this.caption = this.opts.caption;
        this.criteria = report.search.current;
        let elem, tagbox;

        let bindEvents = () => {
            self.criteria.question.changed.add(changed);
        };

        let unbindEvents = () => {
            self.criteria.question.changed.remove(changed);
        };

        let newCriteria = (sender, evt) => {

            unbindEvents();
            self.criteria = report.search.current;
            bindEvents();
            tagbox.items = getItems();
        };
        report.search.newCriteriaCreated.add(newCriteria);

        let changed = (sender, evt) => {

            tagbox.items = getItems();
        };

        let getItems = () => {
            if (!self.criteria) return [];
            if (!self.criteria.question) return [];
            return self.criteria.question.selectedItems;
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.question) return;
            self.criteria.question.clear();
        };
        let removeItem = (sender, evtData) => {
            let target = sender;
            let id = target.QSeq;
            let removeIndex = self.criteria.question.indexOf(id);
            self.criteria.question.remove(removeIndex);
        };

        this.on('mount', () => {
            bindEvents();

            elem = this.refs["tag-ques"];
            tagbox = new NGui.TagBox(elem);

            tagbox.caption = 'Questions';
            tagbox.valueMember = 'QSlideText';

            tagbox.clearItems.add(clearItems);
            tagbox.removeItem.add(removeItem);
        });

        this.on('unmount', () => {
            unbindEvents();

            if (tagbox) {

                tagbox.clearItems.remove(clearItems);
                tagbox.removeItem.remove(removeItem);
            }
            tagbox = null;
            elem = null;
        });
});
riot.tag2('report-search-box', '<div> <div data-is="report-qset-criteria-view" caption="QSets"></div> <div data-is="report-question-criteria-view" caption="Questions"></div> <div data-is="report-date-criteria-view" caption="Date"></div> <div data-is="report-branch-criteria-view" caption="Branchs"></div> <div data-is="report-org-criteria-view" caption="Orgs"></div> <div data-is="report-staff-criteria-view" caption="Staffs"></div> <div ref="tag-input"></div> <button ref="search-btn" style="display: inline-block; margin: 0 auto; padding: 0; width: 10%;">Search</button> </div>', 'report-search-box,[data-is="report-search-box"]{ margin: 0 auto; font-size: 14px; padding-left: 5%; }', '', function(opts) {
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

            self.criteria.qset.changed.add(this.selectionChanged)
            self.criteria.question.changed.add(this.selectionChanged)
            self.criteria.branch.changed.add(this.selectionChanged)
            self.criteria.org.changed.add(this.selectionChanged);
            self.criteria.member.changed.add(this.selectionChanged)
        };

        let unbindEvents = () => {

            self.criteria.qset.changed.remove(this.selectionChanged)
            self.criteria.question.changed.remove(this.selectionChanged)
            self.criteria.branch.changed.remove(this.selectionChanged)
            self.criteria.org.changed.remove(this.selectionChanged);
            self.criteria.member.changed.remove(this.selectionChanged)
        };

        let newCriteria = (sender, evt) => {

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
            { id: 6, text: '6.Staffs' }
        ];

        let hasQSet = () => (self.criteria.qset && self.criteria.qset.QSet) ? true : false;

        let getCommands = () => {
            autofill.hint = 'Command';
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

            autofill.hint = 'Question Set';
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

            autofill.hint = 'Question';
            autofill.datasource = items;
            autofill.valueMember = member;
        };

        let getDates = () => {
            let member = 'text';

            let dobj = self.criteria.date;
            autofill.hint = (!dobj.beginDate) ? 'From Date' : 'To Date';

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

            autofill.hint = 'Branch';
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

                    report.org.model.branchs.forEach((brh) => {
                        items.push(...brh.orgs);
                    });
                }
                else {

                    omaps = selectedOrgs.map(sel => { return sel.OrgId; })

                    report.org.model.branchs.forEach((brh) => {
                        brh.orgs.forEach((org) => {
                            iorg = omaps.indexOf(org.OrgId);
                            if (iorg === -1) {

                                items.push(org);
                            }
                        });
                    });
                }
            }
            else {
                bmaps = selectedBranchs.map(sel => { return sel.BranchId; });
                if (!selectedOrgs || selectedOrgs.length <= 0) {

                    report.org.model.branchs.forEach((brh) => {
                        ibrn = bmaps.indexOf(brh.BranchId);
                        if (ibrn !== -1) {
                            items.push(...brh.orgs);
                        }
                    });
                }
                else {

                    omaps = selectedOrgs.map(sel => { return sel.OrgId; })
                    selectedBranchs.forEach((brh) => {
                        brh.orgs.forEach((org) => {
                            iorg = omaps.indexOf(org.OrgId);
                            if (iorg === -1) {

                                items.push(org);
                            }
                        });
                    });
                }
            }

            autofill.hint = 'Organization';
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

            autofill.hint = 'Staff';
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
                    cmd = '';
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
                    subCmd = '';
                    autofill.filter = '';
                    let dobj = self.criteria.date;
                    if (!dobj.beginDate) {
                        dobj.beginDate = dateVal.year + '-' + dateVal.month + '-' + dateVal.day;
                    }
                    else if (!dobj.endDate) {
                        dobj.endDate = dateVal.year + '-' + dateVal.month + '-' + dateVal.day;
                    }
                    else {

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

        this.escPress = (sender, evtData) => {
            self.showCommands();
        };

        this.modelChanged = (sender, evtData) => {
            this.refreshDataSource();
        };

        this.selectionChanged = (sender, evtData) => {
            this.refreshDataSource();
        };

        this.showCommands = () => {
            autofill.filter = '';
            cmd = '';
            subCmd = '';
            clearDate();
            this.refreshDataSource();
            autofill.focus();
        };

        this.selectAll = () => {
            if (cmd === 'question') {
                cmd = '';

                let maps = NArray.map(self.criteria.question.slides, 'QSeq', false);
                maps.forEach(id => {
                    self.criteria.question.add(id);
                });
                this.refreshDataSource();
            }
            else if (cmd === 'branch') {
                cmd = '';

                let maps = NArray.map(report.org.model.branchs, 'BranchId', false);
                maps.forEach(id => {
                    self.criteria.branch.add(id);
                });
                this.refreshDataSource();
            }
            else if (cmd === 'org') {
                cmd = '';

                let bmaps = NArray.map(self.criteria.branch.getItems(), 'BranchId', false);
                let items = self.criteria.org.getItems();

                items.forEach(item => {
                    if (bmaps.indexOf(item.BranchId) === -1)
                        self.criteria.org.add(item.OrgId);
                });
                this.refreshDataSource();
            }
            else if (cmd === 'staff') {
                cmd = '';

                let maps = NArray.map(report.member.model.members, 'MemberId', false);
                maps.forEach(id => {
                    self.criteria.member.add(id);
                });
                this.refreshDataSource();
            }
        };

        this.runSearch = (evt) => {

            report.search.execute();
            this.criteria = report.search.current;
        };

        this.on('mount', () => {

            report.qset.ModelChanged.add(this.modelChanged);
            report.org.ModelChanged.add(this.modelChanged);
            report.member.ModelChanged.add(this.modelChanged);

            bindEvents();

            let opts = {
                buttons: [{
                    name: 'main-menu',
                    align: 'left',
                    css: { class: 'fas fa-arrow-up' },
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
            autofill.onESC.add(this.escPress);

            searchButton = new NDOM(this.refs["search-btn"]);
            searchButton.event.add('click', this.runSearch);
        });

        this.on('unmount', () => {
            searchButton.event.remove('click', this.runSearch);

            report.qset.ModelChanged.remove(this.modelChanged);
            report.org.ModelChanged.remove(this.modelChanged);
            report.member.ModelChanged.remove(this.modelChanged);

            unbindEvents();

            if (autofill) {

                autofill.onSelectItem.remove(this.selectItem);
                autofill.onInputChanged.remove(this.inputChanged);
                autofill.onESC.remove(this.escPress);
            }
            autofill = null;
            taginput = null;
        });
});

riot.tag2('report-staff-criteria-view', '<div ref="tag-staff"></div>', 'report-staff-criteria-view,[data-is="report-staff-criteria-view"]{ margin: 0 auto; }', '', function(opts) {
        let self = this;

        this.caption = this.opts.caption;
        this.criteria = report.search.current;
        let elem, tagbox;

        let bindEvents = () => {
            self.criteria.member.changed.add(changed);
        };

        let unbindEvents = () => {
            self.criteria.member.changed.remove(changed);
        };

        let newCriteria = (sender, evt) => {

            unbindEvents();
            self.criteria = report.search.current;
            bindEvents();
            tagbox.items = getItems();
        };
        report.search.newCriteriaCreated.add(newCriteria);

        let changed = (sender, evt) => {

            tagbox.items = getItems();
        };

        let getItems = () => {
            if (!self.criteria) return [];
            if (!self.criteria.member) return [];
            return self.criteria.member.selectedItems;
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.member) return;
            self.criteria.member.clear();
        };
        let removeItem = (sender, evtData) => {
            let target = sender;
            let id = target.MemberId;
            let removeIndex = self.criteria.member.indexOf(id);
            self.criteria.member.remove(removeIndex);
        };

        this.on('mount', () => {
            bindEvents();

            elem = this.refs["tag-staff"];
            tagbox = new NGui.TagBox(elem);

            tagbox.caption = 'Staffs';
            tagbox.valueMember = 'FullName';

            tagbox.clearItems.add(clearItems);
            tagbox.removeItem.add(removeItem);
        });

        this.on('unmount', () => {
            unbindEvents();

            if (tagbox) {

                tagbox.clearItems.remove(clearItems);
                tagbox.removeItem.remove(removeItem);
            }
            tagbox = null;
            elem = null;
        });
});
riot.tag2('search-content', '<yield></yield>', '', 'class="search-content"', function(opts) {
});
riot.tag2('sidebars', '<virtual if="{(page.model.sidebar && page.model.sidebar.items && page.model.sidebar.items.length > 0)}"> <ul> <virtual each="{item in page.model.sidebar.items}"> <li class="{(item.active === \'active\' || item.active === \'true\') ? \'active\' : \'\'}"> <a href="{item.url}"> <virtual if="{item.type === \'font\'}"> <span class="fas fa-{item.src}"></span> <label>{item.text}</label> </virtual> <virtual if="{item.type === \'image\'}"> <img riot-src="{item.src}"> <label>{item.text}</label> </virtual> </a> </li> </virtual> </ul> </virtual>', '', 'class="sidebar"', function(opts) {

        let self = this;

        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);
});

riot.tag2('votesummary-pie-chart', '<div class="v-space"> <div class="m-1 p-1 m-auto r-border"> <div ref="output-chart" class="pie-chart"></div> </div> <div class="v-space">', 'votesummary-pie-chart,[data-is="votesummary-pie-chart"]{ min-height: 200px; height: 320px; } votesummary-pie-chart .r-border,[data-is="votesummary-pie-chart"] .r-border{ border: 1px solid cornflowerblue; border-radius: 5px; } votesummary-pie-chart .v-space,[data-is="votesummary-pie-chart"] .v-space{ min-height: 5px; height: 5px; }', '', function(opts) {
        let self = this;

        let renderChart = (result) => {
            if (!result) return;
            let $elems = $(self.refs['output-chart']);
            if (!$elems || $elems.length === 0) return;
            let $outChart = $elems[0];
            if (!$outChart) return;

            let org = result;
            let orgName = org.OrgName;
            let branchName = org.BranchName;

            let chartSetup = {
                backgroundColor: '#FCFFC5',
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie',
                height: 300
            };
            let chartCredits = { enabled: false };
            let chartTitle = {
                useHTML: true,

                text: '<div class="lhsTitle">' + orgName + '</div>',
                align: 'left',
                x: 10
            };
            let chartSubTitle = { };
            let chartToolTip = {

                pointFormat: '<b>{point.percentage:.2f}%</b>',
                shared: true
            };

            let chartPlotOpts = {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b><br/>{point.percentage:.2f} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        }
                    }
                }
            };

            let items = [];
            if (result) {
                org.items.forEach(row => {
                    let item = { name: row.QItemText, y: row.Pct };
                    items.push(item);
                });
            }

            let chartSeries = [{ name: orgName, data: items }];

            let chartInfo = {
                chart: chartSetup,
                credits: chartCredits,
                title: chartTitle,
                subtitle: chartSubTitle,
                plotOptions: chartPlotOpts,
                tooltip: chartToolTip,
                series: chartSeries
            };

            Highcharts.chart($outChart, chartInfo);
            self.update();
        };

        let refresh = () => {
            self.org = (opts.data) ? opts.data : null;
            renderChart(self.org);
        };

        let onModelLoaded = (sender, evtData) => {
            refresh();
        };

        this.on('mount', () => {
            refresh();
            page.modelLoaded.add(onModelLoaded);
        });

        this.on('unmount', () => {
            page.modelLoaded.remove(onModelLoaded);
        });
});
riot.tag2('votesummary-result-content', '<div ref="chart-container" class="row"> <yield></yield> </div> <script>', '', 'class="container-fluid"', function(opts) {
        let self = this;
        this.tags = [];

        let onSearchCompleted = (sender, evtData) => {

            let data = evtData.data;

            let $container = $(this.refs['chart-container']);
            let elPanelDiv = document.createElement('div');
            elPanelDiv.setAttribute(`data-is`, `votesummary-result-panel`);

            $container.append(elPanelDiv);

            let panel = riot.mount(elPanelDiv, `votesummary-result-panel`, { data: data});
        };
        report.search.searchCompleted.add(onSearchCompleted);
});
riot.tag2('votesummary-result-panel', '<div class="row"> <virtual if="{qset}"> <div class="col-12 QSetBorder"> <label class="QSetText" onclick="{collapseClick}"> <div class="collapse-button"> <virtual if="{!collapsed}"> <span class="fas fa-sort-down" style="transform: translate(0, -2px);"></span> </virtual> <virtual if="{collapsed}"> <span class="fas fa-caret-right" style="padding-top: 1px; padding-left: 4px;"></span> </virtual> </div> <b>&nbsp;#{No}.&nbsp;</b> <b>{qset.QSetDescription}</b> <b>({qset.BeginDate}</b> - <b>{qset.EndDate})</b> <div class="close-button" onclick="{closeClick}"> <span class="far fa-times-circle"></span> </div> </label> <div ref="resultPanel" class="client-area"> <virtual each="{ques in questions}"> <div class="col-12 QBorder"> <div class="container-fluid"> <div class="row"> <div class="col-12"> <label class="QText"><b>{ques.QSeq}. {ques.QSlideText}</b></label> </div> </div> <div class="row mb-2"> <virtual each="{item in ques.choices}"> <div class="col-5 offset-1 m-0 m-auto p-0"> <label class="CText">{item.QSSeq}. {item.QItemText}</label> </div> </virtual> </div> <div class="container-fluid"> <div class="row"> <virtual each="{org in ques.orgs}"> <div class="col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12"> <div data-is="votesummary-pie-chart" opts data="{org}"> </div> </div> </virtual> </div> </div> </div> <br> </div> </virtual> </div> </div> </virtual> </div>', 'votesummary-result-panel,[data-is="votesummary-result-panel"]{ width: 95%; font-size: 1rem; } votesummary-result-panel .QSetBorder,[data-is="votesummary-result-panel"] .QSetBorder{ display: block; margin: 0 auto; padding: 0; border: 1px solid silver; background-color: whitesmoke; cursor: pointer; } votesummary-result-panel .QSetText,[data-is="votesummary-result-panel"] .QSetText{ display: block; margin: 0 auto; padding-left: 5px; padding-right: 5px; margin-bottom: 2px; border: 1px solid darkorange; color: whitesmoke; background-color: darkorange; cursor: pointer; } votesummary-result-panel .collapse-button,[data-is="votesummary-result-panel"] .collapse-button{ display: inline-block; float: left; margin: 0 auto; padding: 0; margin-right: 5px; cursor: pointer; } votesummary-result-panel .close-button,[data-is="votesummary-result-panel"] .close-button{ display: inline-block; float: right; margin: 0 auto; padding: 0; margin-left: 5px; cursor: pointer; } votesummary-result-panel .client-area,[data-is="votesummary-result-panel"] .client-area{ margin: 0 auto; padding: 0; display: block; cursor: pointer; } votesummary-result-panel .client-area.hide,[data-is="votesummary-result-panel"] .client-area.hide{ display: none; } votesummary-result-panel .QBorder,[data-is="votesummary-result-panel"] .QBorder{ display: block; margin: 0 auto; padding: 2px; border: 0px; } votesummary-result-panel .QText,[data-is="votesummary-result-panel"] .QText{ display: block; margin: 5px auto; margin-bottom: 3px; padding-left: 5px; padding-right: 5px; border: 1px solid cornflowerblue; border-radius: 5px; color: whitesmoke; background-color: cornflowerblue; } votesummary-result-panel .CText,[data-is="votesummary-result-panel"] .CText{ margin: 0 auto; padding: 0; }', 'class="container-fluid mt-1"', function(opts) {
        let self = this;
        let collapsed = false;

        let refresh = () => {
            self.data = opts.data;
            self.No = (self.data) ? self.data.No : 0;
            self.qset = (self.data && self.data.result) ? self.data.result : null;
            self.questions = (self.qset) ? self.qset.questions : null;
            self.update();
        };

        let onModelLoaded = (sender, evtData) => {

            refresh();
        };

        this.on('mount', () => {
            refresh();
            page.modelLoaded.add(onModelLoaded);
        });

        this.on('unmount', () => {
            page.modelLoaded.remove(onModelLoaded);
        });

        this.collapseClick= (e) => {

            $panels = $(self.refs['resultPanel'])
            if ($panels) {
                let $panel = $($panels[0]);
                $panel.toggleClass('hide');
                if ($panel.hasClass('hide'))
                    self.collapsed = true;
                else self.collapsed = false;
            }
        };

        this.closeClick = (e) => {
            let $self = $(self.root);
            $parent = $self.parent();
            $self.remove();
        };
});
riot.tag2('admin-home-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('votesummary-search-page', '<div data-is="sidebars" data-simplebar></div> <div data-is="search-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('admin-page', '<div data-is="page-nav-bar"></div> <div data-is="page-content-absolute" data-simplebar> <yield></yield> </div> <div data-is="page-footer"></div>', '', '', function(opts) {
});
riot.tag2('device-home-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('device-page', '<div data-is="page-nav-bar"></div> <div data-is="page-content-absolute" data-simplebar> <yield></yield> </div> <div data-is="page-footer"></div>', '', '', function(opts) {
});
riot.tag2('exclusive-home-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('exclusive-page', '<div data-is="page-nav-bar"></div> <div data-is="page-content-absolute" data-simplebar> <yield></yield> </div> <div data-is="page-footer"></div>', '', '', function(opts) {
});
riot.tag2('question-home-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('question-page', '<div data-is="page-nav-bar"></div> <div data-is="page-content-absolute" data-simplebar> <yield></yield> </div> <div data-is="page-footer"></div>', '', '', function(opts) {
});
riot.tag2('staff-home-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('staff-page', '<div data-is="page-nav-bar"></div> <div data-is="page-content-absolute" data-simplebar> <yield></yield> </div> <div data-is="page-footer"></div>', '', '', function(opts) {
});
riot.tag2('default-home-dashboard', '<yield></yield>', '', '', function(opts) {
});

riot.tag2('register-entry', '<div class="container-fluid py-3 semi-trans"> <div class="row"> <div class="col-lg-6 col-md-8 col-sm-8 col-xs-8 mx-auto" style="margin-top: 5%;"> <div class="card card-body"> <virtual if="{(page.model && page.model.register && page.model.register.label && page.model.register.hint)}"> <h3 class="text-center mb-4 alert alert-success" role="alert"> {page.model.register.label.title} </h3> <fieldset> <div class="form-group has-error"> <label for="customerName">&nbsp;{page.model.register.label.customerName}</label> <input class="form-control input-lg" placeholder="{page.model.register.hint.customerName}" id="customerName" name="customerName" type="text"> </div> <div class="form-group has-error"> <label for="userName">&nbsp;{page.model.register.label.userName}</label> <input class="form-control input-lg" placeholder="{page.model.register.hint.userName}" id="userName" name="userName" type="email"> </div> <div class="form-group has-success"> <label for="passWord">&nbsp;{page.model.register.label.passWord}</label> <input class="form-control input-lg" placeholder="{page.model.register.hint.passWord}" id="passWord" name="passWord" value="" type="password"> </div> <div class="form-group has-success"> <label for="confirnPassword">&nbsp;{page.model.register.label.confirmPassWord}</label> <input class="form-control input-lg" placeholder="{page.model.register.hint.confirmPassWord}" id="confirnPassword" name="confirnPassword" value="" type="password"> </div> <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="{onRegisterCustomer}"> <i class="fas fa-user-plus"></i> {page.model.register.label.signUp} </button> </fieldset> </virtual> </div> </div> </div> </div>', 'register-entry,[data-is="register-entry"]{ width: 100%; height: 100%; } register-entry .semi-trans,[data-is="register-entry"] .semi-trans{ opacity: 0.96; }', 'class="h-100"', function(opts) {

        let self = this;
        this.tooltip = new BS4ToolTip();
        this.alert = new BS4Alert();

        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);

        this.validateInput = (customer) => {
            if (!customer) {
                this.alert.show(page.model.msg.customerIsNull);
                return false;
            }
            if (!customer.customerName || customer.customerName.trim() === '') {
                this.tooltip.show($('#customerName'), page.model.msg.customerNameRequired);
                return false;
            }
            if (!customer.userName || customer.userName.trim() === '') {
                this.tooltip.show('#userName', page.model.msg.userNameRequired);
                return false;
            }
            if (!nlib.utils.isValidEmail(customer.userName)) {
                this.tooltip.show('#userName', page.model.msg.userNameIsNotEmail);
                return false;
            }
            if (!customer.passWord || customer.passWord.trim() === '') {
                this.tooltip.show('#passWord', page.model.msg.passWordRequired);
                return false;
            }
            if (!customer.confirnPassword || customer.confirnPassword.trim() === '') {
                this.tooltip.show('#confirnPassword', page.model.msg.confirmPasswordRequired);
                return false;
            }
            if (customer.confirnPassword !== customer.passWord) {
                this.tooltip.show('#confirnPassword', page.model.msg.confirmPasswordMismatch);
                return false;
            }
            return true;
        };

        this.getCustomer = () => {
            let customer = {
                "langId": lang.langId,
                "customerName": $('#customerName').val(),
                "userName": $('#userName').val(),
                "passWord": $('#passWord').val(),
                "confirnPassword": $('#confirnPassword').val()
            };
            return customer;
        };

        this.onRegisterCustomer = (e) => {
            e.preventDefault();
            let customer = self.getCustomer();
            if (!self.validateInput(customer)) return;
            secure.register(customer);
        };
});
riot.tag2('signin-entry', '<div class="container-fluid py-3 semi-trans"> <div class="row"> <div class="col-lg-6 col-md-8 col-sm-8 col-xs-8 mx-auto" style="margin-top: 5%;"> <div class="card card-body"> <virtual if="{(page.model && page.model.signin && page.model.signin.label && page.model.signin.hint)}"> <h3 class="text-center mb-4 alert alert-success" role="alert"> {page.model.signin.label.title} </h3> <fieldset> <div class="form-group"> <label for="userName">&nbsp;{page.model.signin.label.userName}</label> <input class="form-control input-lg" placeholder="{page.model.signin.hint.userName}" id="userName" name="userName" type="email"> </div> <div class="form-group"> <label for="passWord">&nbsp;{page.model.signin.label.passWord}</label> <input class="form-control input-lg" placeholder="{page.model.signin.hint.passWord}" id="passWord" name="passWord" value="" type="password"> </div> <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="{onSignInUser}"> <i class="fas fa-key"></i> {page.model.signin.label.signIn} </button> </fieldset> </virtual> </div> </div> </div> </div> <div class="modal fade" id="selectCustomer" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="false"> <div class="modal-dialog" role="document"> <div class="modal-content"> <div class="modal-header alert-success"> <h5 class="modal-title"> <virtual if="{(page.model && page.model.signin && page.model.signin.label)}"> {page.model.signin.label.chooseCompany} </virtual> </h5> <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button> </div> <div class="modal-body m-0 p-0"> <div class="container-fluid m-0 p-0" data-simplebar> <div class="list-group m-1 p-1 pl-1 pr-2"> <virtial each="{user in users}"> <a href="javascript:void(0);" class="list-group-item list-group-item-action m-auto p-0" customerid="{user.customerId}" onclick="{onSelectedCustomer}"> <div class="d-flex m-0 p-1"> <div class="flex-column m-1 p-0"> <div class="profile-image align-middle"></div> </div> <div class="flex-column m-0 p-0"> <div class="m-0 p-0"> <p class="m-0 p-0"> &nbsp;{user.CustomerNameNative} </p> </div> <div class="m-0 p-0"> <p class="m-0 p-0"> &nbsp;{user.FullNameNative} </p> </div> </div> </div> </a> </virtial> </div> </div> </div> <div class="modal-footer"> <button type="button" class="btn btn-secondary" data-dismiss="modal"> Close </button> </div> </div> </div> </div>', 'signin-entry .semi-trans,[data-is="signin-entry"] .semi-trans{ opacity: 0.96; } signin-entry .err-msg,[data-is="signin-entry"] .err-msg{ color: red; } signin-entry .curr-user,[data-is="signin-entry"] .curr-user{ color: navy; } signin-entry .profile-image,[data-is="signin-entry"] .profile-image{ margin: 5px auto; padding: 5px; width: 30px; height: 30px; background-color: rebeccapurple; border: 1px solid cornflowerblue; border-radius: 50%; } signin-entry .modal-dialog,[data-is="signin-entry"] .modal-dialog{ padding-top: 3em; } signin-entry .modal-body,[data-is="signin-entry"] .modal-body{ max-height: 300px; }', 'class="h-100"', function(opts) {

        let self = this;
        this.users = [];
        this.modal = new BS4Modal('#selectCustomer');
        this.tooltip = new BS4ToolTip();
        this.alert = new BS4Alert();

        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);

        let onLanguageChanged = (sender, evt) => { self.modal.hide();};
        lang.currentChanged.add(onLanguageChanged);

        let onUserListChanged = (sender, evt) => { self.updateUsers(); };
        secure.userListChanged.add(onUserListChanged);

        this.validateInput = (user) => {
            if (!user) {
                this.alert.show(page.model.msg.userIsNull);
                return false;
            }
            if (!user.userName || user.userName.trim() === '') {
                this.tooltip.show('#userName', page.model.msg.userNameRequired);
                return false;
            }
            if (!nlib.utils.isValidEmail(user.userName)) {
                this.tooltip.show('#userName', page.model.msg.userNameIsNotEmail);
                return false;
            }
            if (!user.passWord || user.passWord.trim() === '') {
                this.tooltip.show('#passWord', page.model.msg.passWordRequired);
                return false;
            }
            return true;
        };

        this.getUser = (customerId) => {
            let user = {
                "langId": lang.langId,
                "userName": $('#userName').val(),
                "passWord": $('#passWord').val()
            };
            if (customerId) { user.customerId = customerId; }
            return user;
        };

        this.updateUsers = () => {
            if (secure.users.length <= 0) {
                this.alert.show(page.model.msg.userNotFound);
                return;
            }
            if (secure.users.length === 1) {
                let user = self.getUser(secure.users[0].customerId);
                secure.signIn(user);
            }
            else {
                self.users = secure.users;
                secure.clear();
                self.update();
                self.modal.show();
            }
        };

        this.onSignInUser = (e) => {
            e.preventDefault();
            let user = self.getUser();
            if (!self.validateInput(user)) return;
            secure.getUsers(user);
        };

        this.onSelectedCustomer = (e) => {
            e.preventDefault();
            let user = self.getUser(e.item.user.customerId);
            secure.signIn(user);
            self.modal.hide();
        };
});
riot.tag2('default-page', '<div data-is="page-nav-bar"></div> <div data-is="page-content-absolute" data-simplebar> <yield></yield> </div> <div data-is="page-footer"></div>', '', '', function(opts) {
});
riot.tag2('dev-home-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('dev-register-entry', '', '', '', function(opts) {
});
riot.tag2('dev-report-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('dev-signin-entry', '<div class="container-fluid py-3 semi-trans"> <div class="row"> <div class="col-lg-6 col-md-8 col-sm-8 col-xs-8 mx-auto" style="margin-top: 5%;"> <div class="card card-body"> <virtual if="{(page.model && page.model.signin && page.model.signin.label && page.model.signin.hint)}"> <h3 class="text-center mb-4 alert alert-success" role="alert"> {page.model.signin.label.title} </h3> <fieldset> <div class="form-group"> <label for="userName">&nbsp;{page.model.signin.label.userName}</label> <input class="form-control input-lg" placeholder="{page.model.signin.hint.userName}" id="userName" name="userName" type="email"> </div> <div class="form-group"> <label for="passWord">&nbsp;{page.model.signin.label.passWord}</label> <input class="form-control input-lg" placeholder="{page.model.signin.hint.passWord}" id="passWord" name="passWord" value="" type="password"> </div> <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="{onSignInUser}"> <i class="fas fa-key"></i> {page.model.signin.label.signIn} </button> </fieldset> </virtual> </div> </div> </div> </div> <div class="modal fade" id="selectCustomer" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="false"> <div class="modal-dialog" role="document"> <div class="modal-content"> <div class="modal-header alert-success"> <h5 class="modal-title"> <virtual if="{(page.model && page.model.signin && page.model.signin.label)}"> {page.model.signin.label.chooseCompany} </virtual> </h5> <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button> </div> <div class="modal-body m-0 p-0"> <div class="container-fluid m-0 p-0" data-simplebar> <div class="list-group m-1 p-1 pl-1 pr-2"> <virtial each="{user in users}"> <a href="javascript:void(0);" class="list-group-item list-group-item-action m-auto p-0" customerid="{user.customerId}" onclick="{onSelectedCustomer}"> <div class="d-flex m-0 p-1"> <div class="flex-column m-1 p-0"> <div class="profile-image align-middle"></div> </div> <div class="flex-column m-0 p-0"> <div class="m-0 p-0"> <p class="m-0 p-0"> &nbsp;{user.CustomerNameNative} </p> </div> <div class="m-0 p-0"> <p class="m-0 p-0"> &nbsp;{user.FullNameNative} </p> </div> </div> </div> </a> </virtial> </div> </div> </div> <div class="modal-footer"> <button type="button" class="btn btn-secondary" data-dismiss="modal"> Close </button> </div> </div> </div> </div>', 'dev-signin-entry .profile-image,[data-is="dev-signin-entry"] .profile-image{ margin: 5px auto; padding: 5px; width: 30px; height: 30px; background-color: rebeccapurple; border: 1px solid cornflowerblue; border-radius: 50%; } dev-signin-entry .modal-dialog,[data-is="dev-signin-entry"] .modal-dialog{ padding-top: 3em; } dev-signin-entry .modal-body,[data-is="dev-signin-entry"] .modal-body{ max-height: 300px; }', '', function(opts) {

        let self = this;
        this.users = [];
        this.modal = new BS4Modal('#selectCustomer');
        this.tooltip = new BS4ToolTip();
        this.alert = new BS4Alert();

        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);

        let onUserListChanged = (sender, evt) => { self.updateUsers(); };
        secure.userListChanged.add(onUserListChanged);

        this.validateInput = (user) => {
            if (!user) {
                this.alert.show('User is null.');
                return false;
            }
            if (!user.userName || user.userName.trim() === '') {

                this.tooltip.show('#userName', 'Please Enter User Name.');
                return false;
            }
            if (!nlib.utils.isValidEmail(user.userName)) {

                this.tooltip.show('#userName', 'User Name is not valid email address.');
                return false;
            }
            if (!user.passWord || user.passWord.trim() === '') {

                this.tooltip.show('#passWord', 'Please Enter Password.');
                return false;
            }
            return true;
        };

        this.getUser = (customerId) => {
            let user = {
                "langId": lang.langId,
                "userName": $('#userName').val(),
                "passWord": $('#passWord').val()
            };
            if (customerId) { user.customerId = customerId; }
            return user;
        };

        this.updateUsers = () => {
            if (secure.users.length <= 0) {
                this.alert.show('User not found.');
                return;
            }
            if (secure.users.length === 1) {
                let user = self.getUser(secure.users[0].customerId);
                secure.signIn(user);
            }
            else {
                self.users = secure.users;
                secure.clear();
                self.update();
                self.modal.show();
            }
        };

        this.onSignInUser = (e) => {
            e.preventDefault();
            let user = self.getUser();
            if (!self.validateInput(user)) return;
            secure.getUsers(user);
        };

        this.onSelectedCustomer = (e) => {
            e.preventDefault();
            let user = self.getUser(e.item.user.customerId);
            secure.signIn(user);
            self.modal.hide();
        };
});
riot.tag2('dev-page', '<div data-is="page-nav-bar"></div> <div data-is="page-content-absolute" data-simplebar> <yield></yield> </div> <div data-is="page-footer"></div>', '', '', function(opts) {
});
riot.tag2('edl-admin-home-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('edl-admin-page', '<div data-is="page-nav-bar"></div> <div data-is="page-content-absolute" data-simplebar> <yield></yield> </div> <div data-is="page-footer"></div>', '', '', function(opts) {
});
riot.tag2('edl-staff-home-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('edl-staff-page', '<div data-is="page-nav-bar"></div> <div data-is="page-content-absolute" data-simplebar> <yield></yield> </div> <div data-is="page-footer"></div>', '', '', function(opts) {
});
riot.tag2('edl-supervisor-home-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
});
riot.tag2('edl-supervisor-page', '<div data-is="page-nav-bar"></div> <div data-is="page-content-absolute" data-simplebar> <yield></yield> </div> <div data-is="page-footer"></div>', '', '', function(opts) {
});