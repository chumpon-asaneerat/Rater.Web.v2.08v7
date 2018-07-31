<page-nav-bar class="container-fluid">
    <div class="navbar navbar-expand-sm fixed-top navbar-dark bg-primary m-0 p-1">
        <!-- Banner -->
        <virtual if={(page.model && page.model.banner)}>
            <a href="{page.model.banner.url}" class="navbar-band m-1 p-0 align-middle">
                <div class="d-inline-block">
                    <!-- IMAGE AND TEXT -->
                    <virtual if={(page.model.banner.type === 'image')}>
                        <div class="d-inline-block m-0 p-0">
                            <img src="{page.model.banner.src}" class="d-inline-block m-0 p-0 logo">
                        </div>
                    </virtual>
                    <!-- FONT-ICON AND TEXT -->
                    <virtual if={(page.model.banner.type==='font')}>
                        <div class="d-inline-block m-0 p-0">
                            <span class="fas fa-{page.model.banner.src} navbar-text w-auto m-0 p-0">
                                <virtual if={(page.model.banner.text !=='')} class="d-inline-block m-0 p-0">
                                    <span class="rater-text w-auto m-0 p-0">
                                        &nbsp;&nbsp;{page.model.banner.text}&nbsp;&nbsp;
                                    </span>
                                </virtual>
                            </span>
                        </div>
                    </virtual>
                </div>
            </a>
        </virtual>
        <!-- Right Nav Item for languages -->
        <div class="d-flex flex-row order-2 order-sm-3 order-md-3 order-lg-3">
            <ul class="navbar-nav flex-row ml-auto">
                <!-- SIGN OUT BUTTON  -->
                <virtual if={(page.model.nav.signout)}>
                    <li class="nav-item">
                        <a href="{page.model.nav.signout.url}" class="nav-link py-2 align-middle" onclick="{onSignOut}">
                            <div class="d-inline-block">
                                <!-- FONT-ICON AND TEXT -->
                                <virtual if={(page.model.nav.signout.type==='font')}>
                                    <div class="v-divider"></div>
                                    <span>&nbsp;</span>
                                    <div class="d-inline-block m-0 p-0">
                                        <span class="fas fa-{page.model.nav.signout.src} navbar-text w-auto m-0 p-0">
                                            <virtual if={(page.model.nav.signout.text !=='')}>
                                                <span class="d-inline-block rater-text w-auto m-0 p-0">
                                                    &nbsp;{page.model.nav.signout.text}&nbsp;
                                                </span>
                                            </virtual>
                                        </span>
                                    </div>
                                    <div class="v-divider"></div>
                                    <span>&nbsp;</span>
                                </virtual>
                            </div>
                        </a>
                    </li>
                </virtual>
                <!-- CURRENT LANGUAGE WITH DROPDOWN ARROW -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle px-2 align-middle" data-toggle="dropdown" href="javascript:void(0);" id="nav-languages">
                        <span class="flag-icon flag-icon-{lang.current.flagId.toLowerCase()}"></span>
                        &nbsp;&nbsp;{lang.current.DescriptionNative}&nbsp;&nbsp;
                        <span class="caret"></span>
                    </a>
                    <!-- ALL LANGUAGES DROP MENU LIST -->
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="nav-languages">
                        <virtual each={eachlang in lang.languages}>
                            <a class="dropdown-item {(lang.current.flagId === eachlang.flagId) ? 'active': ''}" href="javascript:void(0);"
                               langId="{eachlang.langId}" onclick="{onChangeLanguage}">
                               <span class="flag-icon flag-icon-{eachlang.flagId.toLowerCase()}"></span>
                               &nbsp;&nbsp;{eachlang.DescriptionNative}&nbsp;&nbsp;
                            </a>
                        </virtual>
                    </div>
                </li>
            </ul>
            <!-- Toggle Collapse Button -->
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>
        </div>
        <!-- Collapse Items -->
        <div class="collapse navbar-collapse m-0 p-0 order-3 order-sm-2 order-md-2 order-lg-2" id="collapsibleNavbar">
            <ul class="navbar-nav">
                <!-- EACH MAIN MENU ITEM LINKS -->
                <virtual if={(page.model && page.model.nav && page.model.nav.links && page.model.nav.links.length > 0)}>
                    <virtual each={link in page.model.nav.links}>
                        <li class="nav-item {(link.active === 'active' || link.active === 'true') ? 'active' : ''}">
                            <a class="nav-link align-middle" href="{link.url}">
                                <span>&nbsp;</span>
                                <div class="v-divider"></div>
                                <span>&nbsp;</span>
                                <!-- IMAGE AND TEXT -->
                                <virtual if={(link.type==='image')}>
                                    <div class="d-inline-block m-0 p-0">
                                        <img src="{link.src}" class="d-inline-block m-0 p-0 menu-img">
                                        <virtual if={(link.text !== '')} class="d-inline-block m-0 p-0">
                                            <span class="rater-text w-auto m-0 p-0">
                                                &nbsp;{link.text}&nbsp;
                                            </span>
                                        </virtual>
                                    </div>
                                </virtual>
                                <!-- FONT-ICON AND TEXT -->
                                <virtual if={(link.type==='font')}>
                                    <div class="d-inline-block m-0 p-0">
                                        <span class="fas fa-{src} navbar-text w-auto m-0 p-0">
                                            <virtual if={(link.text !== '')} class="d-inline-block m-0 p-0">
                                                <span class="rater-text w-auto m-0 p-0">
                                                    &nbsp;{link.text}&nbsp;
                                                </span>
                                            </virtual>
                                        </span>
                                    </div>
                                </virtual>
                                <!-- TEXT ONLY -->
                                <virtual if={(link.type==='none' || type==='')}>
                                    <div class="d-inline-block m-0 p-0">
                                        <virtual if={(link.text !== '')}>
                                            <div class="d-inline-block m-0 p-0">
                                                <span class="rater-text w-auto m-0 p-0">
                                                    &nbsp;{link.text}&nbsp;
                                                </span>
                                            </div>
                                        </virtual>
                                    </div>
                                </virtual>
                            </a>
                        </li>
                    </virtual>
                </virtual>
            </ul>
        </div>
    </div>
    <style>
        :scope {
            padding-top: 2px;
            padding-bottom: 0px;
            font-size: 1em;
        }
        .logo { height: 28px; }
        .menu-img { height: 1em; }
        .rater-text { font-family: "Lucida Sans Unicode", sans-serif; }
        .v-divider {
            display: inline;
            margin-left: 2px;
            margin-right: 2px;
            border-left: 1px solid whitesmoke;
        }
        a:hover .v-divider { border-color: white; }
        a:hover .fas { color: white; }
        a:hover .rater-text { color: white; }
    </style>

    <script>
        //-- local variables.
        let self = this;
        
        //-- setup service handlers.
        let onModelLoaded = (sender, evtData) => { self.update(); };
        page.modelLoaded.add(onModelLoaded);

        //-- click events
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
    </script>
</page-nav-bar>