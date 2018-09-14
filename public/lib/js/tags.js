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
riot.tag2('report-branch-criteria-view', '<virtual if="{(criteria !== null && criteria.branch !== null && criteria.branch.selectedItems != null && criteria.branch.selectedItems.length > 0)}"> <div class="tag-box"> <div class="row"> <div class="col-2 mr-0 pr-0"> <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a> <span class="tag-caption">{caption}</span> </div> <div class="col-10 ml-0 pl-0"> <virtual each="{item in criteria.branch.selectedItems}"> <span class="tag-item">{item.BranchName}<span class="tag-close" onclick="{removeTagItem}"></span></span> </virtual> </div> </div> </div> </virtual>', 'report-branch-criteria-view,[data-is="report-branch-criteria-view"]{ margin: 0 auto; padding: 0; }', '', function(opts) {
        let self = this;
        this.caption = this.opts.caption;
        this.criteria = report.search.current;

        let branchchanged = (sender, evt) => {

            self.update();
        };

        this.on('mount', () => {

            self.criteria.branch.changed.add(branchchanged);
        });

        this.on('unmount', () => {

            self.criteria.branch.changed.remove(branchchanged);
        });

        this.clearTagItems = (e) => {
            self.criteria.branch.clear();
        };

        this.removeTagItem = (e) => {
            let target = e.item;
            let branchid = target.item.BranchId;
            let removeIndex = self.criteria.branch.indexOf(branchid);
            self.criteria.branch.remove(removeIndex);
        };
});
riot.tag2('report-date-criteria-view', '<virtual if="{(items !==null && items.length> 0)}"> <div class="tag-box"> <div class="row"> <div class="col-2 mr-0 pr-0"> <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a> <span class="tag-caption">{caption}</span> </div> <div class="col-10 ml-0 pl-0"> <virtual each="{tag in items}"> <span class="tag-item">{tag.text}<span class="tag-close" onclick="{removeTagItem}"></span></span> </virtual> </div> </div> </div> </virtual>', 'report-date-criteria-view,[data-is="report-date-criteria-view"]{ margin: 0 auto; padding: 0; }', '', function(opts) {
        let self = this;
        this.caption = this.opts.caption;
        this.items = [
            { id: '1', text: '2018-08-01' },
            { id: '2', text: '2018-08-01' }
        ];

        this.clearTagItems = (e) => {
            if (self.items && self.items.length > 0) {
                self.items.splice(0);

                self.update();
            }
        };

        this.removeTagItem = (e) => {
            let target = e.item;
            if (self.items && self.items.length > 0) {
                let maps = self.items.map(item => { return item.id; });
                let index = maps.indexOf(target.tag.id);
                self.items.splice(index, 1);

                self.update();
            }
        };
});
riot.tag2('report-org-criteria-view', '<virtual if="{(criteria !== null && criteria.org !== null && criteria.org.selectedItems != null && criteria.org.selectedItems.length > 0)}"> <div class="tag-box"> <div class="row"> <div class="col-2 mr-0 pr-0"> <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a> <span class="tag-caption">{caption}</span> </div> <div class="col-10 ml-0 pl-0"> <virtual each="{item in criteria.org.selectedItems}"> <span class="tag-item {item.Invalid}">{item.OrgName}<span class="tag-close" onclick="{removeTagItem}"></span></span> </virtual> </div> </div> </div> </virtual>', 'report-org-criteria-view,[data-is="report-org-criteria-view"]{ margin: 0 auto; padding: 0; }', '', function(opts) {
        let self = this;
        this.caption = this.opts.caption;
        this.criteria = report.search.current;

        let orgchanged = (sender, evt) => {

            self.update();
        };

        this.on('mount', () => {

            self.criteria.org.changed.add(orgchanged);
        });

        this.on('unmount', () => {

            self.criteria.org.changed.remove(orgchanged);
        });

        this.clearTagItems = (e) => {
            self.criteria.org.clear();
        };

        this.removeTagItem = (e) => {
            let target = e.item;
            let orgid = target.item.OrgId;
            let removeIndex = self.criteria.org.indexOf(orgid);
            self.criteria.org.remove(removeIndex);
        };
});
riot.tag2('report-qset-criteria-view', '<virtual if="{(criteria !== null && criteria.qset !== null && criteria.qset.QSet !== null)}"> <div class="tag-box"> <div class="row"> <div class="col-2 mr-0 pr-0"> <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a> <span class="tag-caption">{caption}</span> </div> <div class="col-10 ml-0 pl-0"> <span class="tag-item">{criteria.qset.QSet.QSetDescription}<span class="tag-close" onclick="{removeTagItem}"></span></span> </div> </div> </div> </virtual>', 'report-qset-criteria-view,[data-is="report-qset-criteria-view"]{ margin: 0 auto; padding: 0; }', '', function(opts) {
        let self = this;

        this.caption = this.opts.caption;
        this.criteria = report.search.current;

        let qsetchanged = (sender, evt) => {

            self.update();
        };

        this.on('mount', () => {

            self.criteria.qset.changed.add(qsetchanged);
        });

        this.on('unmount', () => {

            self.criteria.qset.changed.remove(qsetchanged);
        });

        this.clearTagItems = (e) => {
            self.criteria.QSetId = null;
        };

        this.removeTagItem = (e) => {
            self.criteria.QSetId = null;
        };
});
riot.tag2('report-question-criteria-view', '<virtual if="{(criteria !== null && criteria.question !== null && criteria.question.selectedItems != null && criteria.question.selectedItems.length > 0)}"> <div class="tag-box"> <div class="row"> <div class="col-2 mr-0 pr-0"> <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a> <span class="tag-caption">{caption}</span> </div> <div class="col-10 ml-0 pl-0"> <virtual each="{item in criteria.question.selectedItems}"> <span class="tag-item">{item.QSlideText}<span class="tag-close" onclick="{removeTagItem}"></span></span> </virtual> </div> </div> </div> </virtual>', 'report-question-criteria-view,[data-is="report-question-criteria-view"]{ margin: 0 auto; padding: 0; }', '', function(opts) {
        let self = this;
        this.caption = this.opts.caption;
        this.criteria = report.search.current;

        let quesionchanged = (sender, evt) => {

            self.update();
        };

        this.on('mount', () => {

            self.criteria.question.changed.add(quesionchanged);
        });

        this.on('unmount', () => {

            self.criteria.question.changed.remove(quesionchanged);
        });

        this.clearTagItems = (e) => {
            self.criteria.question.clear();
        };

        this.removeTagItem = (e) => {
            let target = e.item;
            let qseq = target.item.QSeq;
            let removeIndex = self.criteria.question.indexOf(qseq);
            self.criteria.question.remove(removeIndex);
        };
});
riot.tag2('report-search-box', '<div> <div> <input ref="tag-input" type="text" onfocus="{onFocus}" oninput="{onInput}" onblur="{onBlur}"> <div ref="tag-dropdown" class="autocomplete-items"> <span class="autocomplete-item">Softbase</span> <span class="autocomplete-item">Marketing</span> <span class="autocomplete-item">Account</span> <span class="autocomplete-item">Manufacture</span> <span class="autocomplete-item">Supports</span> </div> </div> <div data-is="report-qset-criteria-view" caption="QSets"></div> <div data-is="report-date-criteria-view" caption="Date"></div> <div data-is="report-question-criteria-view" caption="Questions"></div> <div data-is="report-branch-criteria-view" caption="Branchs"></div> <div data-is="report-org-criteria-view" caption="Orgs"></div> <div data-is="report-staff-criteria-view" caption="Staffs"></div> </div>', 'report-search-box,[data-is="report-search-box"]{ margin: 0 auto; padding: 15px; font-size: 14px; } report-search-box input[type=\'text\'],[data-is="report-search-box"] input[type=\'text\']{ display: inline-block; margin: 0 auto; width: 100%; } report-search-box .autocomplete-items,[data-is="report-search-box"] .autocomplete-items{ display: none; position: absolute; margin: 1px auto; padding: 5px; color: silver; background-color: white; border: 1px solid dimgray; border-radius: 5px; top: 43px; left: 15px; right: 15px; z-index: 100; } report-search-box .autocomplete-items.show,[data-is="report-search-box"] .autocomplete-items.show{ display: inline-block; } report-search-box .autocomplete-items .autocomplete-item,[data-is="report-search-box"] .autocomplete-items .autocomplete-item{ position:relative; padding: 2px; display: block; cursor: pointer; } report-search-box .autocomplete-items .autocomplete-item:hover,[data-is="report-search-box"] .autocomplete-items .autocomplete-item:hover{ color: white; background-color: cornflowerblue; }', '', function(opts) {
        let self = this;

        let tagdropdown = null;

        this.on('mount', () => {
            tagdropdown = this.refs["tag-dropdown"];

        });

        this.on('unmount', () => {
            tagdropdown = null;
        });

        this.onFocus = (e) => {

            if (!tagdropdown) {
                console.log('dropdown element not found.');
                return;
            }
            let $tagdd = $(tagdropdown);
            $tagdd.addClass('show');

        };
        this.onInput = (e) => {

        };
        this.onBlur = (e) => {

            if (!tagdropdown) {
                console.log('dropdown element not found.');
                return;
            }
            let $tagdd = $(tagdropdown);
            $tagdd.removeClass('show');

        };
});
riot.tag2('report-staff-criteria-view', '<virtual if="{(criteria !== null && criteria.member !== null && criteria.member.selectedItems != null && criteria.member.selectedItems.length > 0)}"> <div class="tag-box"> <div class="row"> <div class="col-2 mr-0 pr-0"> <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a> <span class="tag-caption">{caption}</span> </div> <div class="col-10 ml-0 pl-0"> <virtual each="{item in criteria.member.selectedItems}"> <span class="tag-item">{item.FullName}<span class="tag-close" onclick="{removeTagItem}"></span></span> </virtual> </div> </div> </div> </virtual>', 'report-staff-criteria-view,[data-is="report-staff-criteria-view"]{ margin: 0 auto; padding: 0; }', '', function(opts) {
        let self = this;
        this.caption = this.opts.caption;
        this.criteria = report.search.current;

        let memberchanged = (sender, evt) => {

            self.update();
        };

        this.on('mount', () => {

            self.criteria.member.changed.add(memberchanged);
        });

        this.on('unmount', () => {

            self.criteria.member.changed.remove(memberchanged);
        });

        this.clearTagItems = (e) => {
            self.criteria.member.clear();
        };

        this.removeTagItem = (e) => {
            let target = e.item;
            let memberid = target.item.MemberId;
            let removeIndex = self.criteria.member.indexOf(memberid);
            self.criteria.member.remove(removeIndex);
        };
});
riot.tag2('search-content', '<yield></yield>', '', 'class="search-content"', function(opts) {
});
riot.tag2('sidebars', '<virtual if="{(page.model.sidebar && page.model.sidebar.items && page.model.sidebar.items.length > 0)}"> <ul> <virtual each="{item in page.model.sidebar.items}"> <li class="{(item.active === \'active\' || item.active === \'true\') ? \'active\' : \'\'}"> <a href="{item.url}"> <virtual if="{item.type === \'font\'}"> <span class="fas fa-{item.src}"></span> <label>{item.text}</label> </virtual> <virtual if="{item.type === \'image\'}"> <img riot-src="{item.src}"> <label>{item.text}</label> </virtual> </a> </li> </virtual> </ul> </virtual>', '', 'class="sidebar"', function(opts) {

        let self = this;

        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);
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