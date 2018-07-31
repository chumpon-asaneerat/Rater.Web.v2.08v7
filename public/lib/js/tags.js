riot.tag2('dashboard-content', '<yield></yield>', '', 'class="dashboard-content"', function(opts) {
});

riot.tag2('page-content-relative', '<h3>Content gone below.</h3> <yield></yield> <h3>Content end here.</h3>', 'page-content-relative,[data-is="page-content-relative"]{ margin: 1px auto; padding: 1px; }', '', function(opts) {
});
riot.tag2('page-content-absolute', '<div id="page-content-abs" class="container-fluid"> <yield></yield> </div>', 'page-content-absolute,[data-is="page-content-absolute"]{ margin: 1px auto; padding: 1px; position: absolute; top: 3em; bottom: 2em; left: 1px; right: 4px; overflow-x: hidden; overflow-y: auto; }', '', function(opts) {


        let self = this;
        this.uid = nlib.utils.newUId();

});
riot.tag2('page-footer', '<span class="float-left m-0 p-0"> <virtual if="{(page.model && page.model.footer && page.model.footer.label)}"> <label class="m-0 p-1">&nbsp;{page.model.footer.label.status}&nbsp;:</label> <div class="v-divider">&nbsp;</div> </virtual> </span> <span class="float-right m-0 p-0 ml-auto"> <div class="v-divider"></div> <label class="m-0 p-1"> &nbsp; <span id="user-info" class="fas fa-user-circle"></span> <virtual if="{secure.current}"> &nbsp; {secure.currentUserName} &nbsp; </virtual> </label> <div class="v-divider"></div> <virtual if="{(page.model && page.model.footer && page.model.footer.label)}"> <label class="m-0 p-1">&copy;&nbsp;{page.model.footer.label.copyright}&nbsp;&nbsp;&nbsp;</label> </virtual> </span>', 'page-footer,[data-is="page-footer"],page-footer .navbar,[data-is="page-footer"] .navbar,page-footer .nav,[data-is="page-footer"] .nav,page-footer span,[data-is="page-footer"] span{ margin: 0 auto; padding: 0; } page-footer label,[data-is="page-footer"] label{ color: whitesmoke; font-size: 0.95em; font-weight: bold; } page-footer .v-divider,[data-is="page-footer"] .v-divider{ display: inline; margin-left: 2px; margin-right: 2px; border-left: 1px solid whitesmoke; }', 'class="navbar fixed-bottom m-0 p-0 navbar-light bg-primary"', function(opts) {

        let self = this;

        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);

        let onCurrentUserChanged = (sender, evtData) => { self.update(); };
        secure.currentUserChanged.add(onCurrentUserChanged);
});
riot.tag2('page-nav-bar', '<div class="navbar navbar-expand-sm fixed-top navbar-dark bg-primary m-0 p-1"> <virtual if="{(page.model && page.model.banner)}"> <a href="{page.model.banner.url}" class="navbar-band m-1 p-0 align-middle"> <div class="d-inline-block"> <virtual if="{(page.model.banner.type === \'image\')}"> <div class="d-inline-block m-0 p-0"> <img riot-src="{page.model.banner.src}" class="d-inline-block m-0 p-0 logo"> </div> </virtual> <virtual if="{(page.model.banner.type===\'font\')}"> <div class="d-inline-block m-0 p-0"> <span class="fas fa-{page.model.banner.src} navbar-text w-auto m-0 p-0"> <virtual if="{(page.model.banner.text !==\'\')}" class="d-inline-block m-0 p-0"> <span class="rater-text w-auto m-0 p-0"> &nbsp;&nbsp;{page.model.banner.text}&nbsp;&nbsp; </span> </virtual> </span> </div> </virtual> </div> </a> </virtual> <div class="d-flex flex-row order-2 order-sm-3 order-md-3 order-lg-3"> <ul class="navbar-nav flex-row ml-auto"> <virtual if="{(page.model.nav.signout)}"> <li class="nav-item"> <a href="{page.model.nav.signout.url}" class="nav-link py-2 align-middle" onclick="{onSignOut}"> <div class="d-inline-block"> <virtual if="{(page.model.nav.signout.type===\'font\')}"> <div class="v-divider"></div> <span>&nbsp;</span> <div class="d-inline-block m-0 p-0"> <span class="fas fa-{page.model.nav.signout.src} navbar-text w-auto m-0 p-0"> <virtual if="{(page.model.nav.signout.text !==\'\')}"> <span class="d-inline-block rater-text w-auto m-0 p-0"> &nbsp;{page.model.nav.signout.text}&nbsp; </span> </virtual> </span> </div> <div class="v-divider"></div> <span>&nbsp;</span> </virtual> </div> </a> </li> </virtual> <li class="nav-item dropdown"> <a class="nav-link dropdown-toggle px-2 align-middle" data-toggle="dropdown" href="javascript:void(0);" id="nav-languages"> <span class="flag-icon flag-icon-{lang.current.flagId.toLowerCase()}"></span> &nbsp;&nbsp;{lang.current.DescriptionNative}&nbsp;&nbsp; <span class="caret"></span> </a> <div class="dropdown-menu dropdown-menu-right" aria-labelledby="nav-languages"> <virtual each="{eachlang in lang.languages}"> <a class="dropdown-item {(lang.current.flagId === eachlang.flagId) ? \'active\': \'\'}" href="javascript:void(0);" langid="{eachlang.langId}" onclick="{onChangeLanguage}"> <span class="flag-icon flag-icon-{eachlang.flagId.toLowerCase()}"></span> &nbsp;&nbsp;{eachlang.DescriptionNative}&nbsp;&nbsp; </a> </virtual> </div> </li> </ul> <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar"> <span class="navbar-toggler-icon"></span> </button> </div> <div class="collapse navbar-collapse m-0 p-0 order-3 order-sm-2 order-md-2 order-lg-2" id="collapsibleNavbar"> <ul class="navbar-nav"> <virtual if="{(page.model && page.model.nav && page.model.nav.links && page.model.nav.links.length > 0)}"> <virtual each="{link in page.model.nav.links}"> <li class="nav-item {(link.active === \'active\' || link.active === \'true\') ? \'active\' : \'\'}"> <a class="nav-link align-middle" href="{link.url}"> <span>&nbsp;</span> <div class="v-divider"></div> <span>&nbsp;</span> <virtual if="{(link.type===\'image\')}"> <div class="d-inline-block m-0 p-0"> <img riot-src="{link.src}" class="d-inline-block m-0 p-0 menu-img"> <virtual if="{(link.text !== \'\')}" class="d-inline-block m-0 p-0"> <span class="rater-text w-auto m-0 p-0"> &nbsp;{link.text}&nbsp; </span> </virtual> </div> </virtual> <virtual if="{(link.type===\'font\')}"> <div class="d-inline-block m-0 p-0"> <span class="fas fa-{src} navbar-text w-auto m-0 p-0"> <virtual if="{(link.text !== \'\')}" class="d-inline-block m-0 p-0"> <span class="rater-text w-auto m-0 p-0"> &nbsp;{link.text}&nbsp; </span> </virtual> </span> </div> </virtual> <virtual if="{(link.type===\'none\' || type===\'\')}"> <div class="d-inline-block m-0 p-0"> <virtual if="{(link.text !== \'\')}"> <div class="d-inline-block m-0 p-0"> <span class="rater-text w-auto m-0 p-0"> &nbsp;{link.text}&nbsp; </span> </div> </virtual> </div> </virtual> </a> </li> </virtual> </virtual> </ul> </div> </div>', 'page-nav-bar,[data-is="page-nav-bar"]{ padding-top: 2px; padding-bottom: 0px; font-size: 1em; } page-nav-bar .logo,[data-is="page-nav-bar"] .logo{ height: 28px; } page-nav-bar .menu-img,[data-is="page-nav-bar"] .menu-img{ height: 1em; } page-nav-bar .rater-text,[data-is="page-nav-bar"] .rater-text{ font-family: "Lucida Sans Unicode", sans-serif; } page-nav-bar .v-divider,[data-is="page-nav-bar"] .v-divider{ display: inline; margin-left: 2px; margin-right: 2px; border-left: 1px solid whitesmoke; } page-nav-bar a:hover .v-divider,[data-is="page-nav-bar"] a:hover .v-divider{ border-color: white; } page-nav-bar a:hover .fas,[data-is="page-nav-bar"] a:hover .fas{ color: white; } page-nav-bar a:hover .rater-text,[data-is="page-nav-bar"] a:hover .rater-text{ color: white; }', 'class="container-fluid"', function(opts) {

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
riot.tag2('sidebars', '<virtual if="{(page.model.sidebar && page.model.sidebar.items && page.model.sidebar.items.length > 0)}"> <ul> <virtual each="{item in page.model.sidebar.items}"> <li class="{(item.active === \'active\' || item.active === \'true\') ? \'active\' : \'\'}"> <a href="{item.url}"> <virtual if="{item.type === \'font\'}"> <span class="fas fa-{item.src}"></span> <label>{item.text}</label> </virtual> <virtual if="{item.type === \'image\'}"> <img riot-src="{item.src}"> <label>{item.text}</label> </virtual> </a> </li> </virtual> </ul> </virtual>', '', 'class="sidebar"', function(opts) {

        let self = this;

        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);
});

riot.tag2('admin-home-dashboard', '<div data-is="sidebars" data-simplebar></div> <div data-is="dashboard-content" data-simplebar> <yield></yield> </div>', '', '', function(opts) {
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