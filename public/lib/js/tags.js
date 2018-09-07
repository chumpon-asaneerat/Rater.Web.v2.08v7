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
riot.tag2('rawvote-search-box', '<div> <textarea ref="jsonSearch" riot-value="{value}"></textarea> <button onclick="{onSearch}">Search</button> </div>', 'rawvote-search-box,[data-is="rawvote-search-box"]{ margin: 0 auto; padding: 15px; font-size: 12pt; } rawvote-search-box textarea,[data-is="rawvote-search-box"] textarea{ width: 85%; height: 100px; } rawvote-search-box button,[data-is="rawvote-search-box"] button{ margin: 10px, 0 auto; padding: 2px 15px; vertical-align: top; } rawvote-search-box .tags-input,[data-is="rawvote-search-box"] .tags-input{ margin: 0 auto; padding: 1px; border: 1px solid #333; display: inline-block; font-size: 0.5em; } rawvote-search-box .tags-input .tag,[data-is="rawvote-search-box"] .tags-input .tag{ margin: 3px auto; padding: 5px; display: inline-block; color:white; background-color: cornflowerblue; cursor: pointer; } rawvote-search-box .tags-input .tag:hover,[data-is="rawvote-search-box"] .tags-input .tag:hover{ color:yellow; background-color: dimgray; transition: all 0.1s linear; } rawvote-search-box .tags-input .tag .close::after,[data-is="rawvote-search-box"] .tags-input .tag .close::after{ content: \'x\'; font-weight: bold; display: inline-block; transform: scale(0.5) translateY(-5px); margin-left: 3px; color: white; } rawvote-search-box .tags-input .tag .close:hover::after,[data-is="rawvote-search-box"] .tags-input .tag .close:hover::after{ color:red; transition: all 0.1s linear; } rawvote-search-box .tags-input .search-input,[data-is="rawvote-search-box"] .tags-input .search-input{ border: 0; outline: 0; padding: 1px; } rawvote-search-box .tags-input .clear-input::after,[data-is="rawvote-search-box"] .tags-input .clear-input::after{ margin: 5px auto; margin-top: 0px; margin-right: 10px; content: \'x\'; font-weight: bold; display: inline-block; color: black; cursor: pointer; } rawvote-search-box .tags-input .clear-input:hover::after,[data-is="rawvote-search-box"] .tags-input .clear-input:hover::after{ color:red; transition: all 0.1s linear; } rawvote-search-box .autocomplete-items,[data-is="rawvote-search-box"] .autocomplete-items{ position: absolute; border: 1px solid #d4d4d4; border-bottom: none; border-top: none; z-index: 99; top: 100%; left: 0; right: 0; } rawvote-search-box .autocomplete-items div,[data-is="rawvote-search-box"] .autocomplete-items div{ padding: 10px; cursor: pointer; background-color: #fff; border-bottom: 1px solid #d4d4d4; } rawvote-search-box .autocomplete-items div:hover,[data-is="rawvote-search-box"] .autocomplete-items div:hover{ background-color: #e9e9e9; } rawvote-search-box .autocomplete-active,[data-is="rawvote-search-box"] .autocomplete-active{ background-color: DodgerBlue !important; color: #ffffff; }', '', function(opts) {
        let self = this;

        this.value = JSON.stringify(JSON.parse(`{
            "LangId": "TH",
            "CustomerID": "EDL-C2018080001",
            "QSetId": "QS00001",
            "QSeq": "1",
            "OrgId": ["O0001", "O0003", "O0005"],
            "BeginDate": "2018-08-01",
            "EndDate": "2018-08-01"
        }`), null, 4);

        let onModelLoaded = (sender, evtData) => {

            self.update();
        };
        page.modelLoaded.add(onModelLoaded);

        this.onSearch = (e) => {
            e.preventDefault();
            var $jsonInput = $(this.refs['jsonSearch']);
            var criteria = JSON.parse($jsonInput.val());

        };
});
riot.tag2('votesummary-bar-chart', '<div class="m-1 p-1 m-auto r-border"> <div ref="output-chart" class="pie-chart"></div> </div>', 'votesummary-bar-chart .r-border,[data-is="votesummary-bar-chart"] .r-border{ border: 1px solid cornflowerblue; border-radius: 5px; }', '', function(opts) {
        let self = this;
        this.finder = new Finder();
        this.QSlideText = '';

        let onModelLoaded = (sender, evtData) => {

            self.search();
        };
        page.modelLoaded.add(onModelLoaded);

        let onSearchCompleted = (sender, evtData) => {

            self.renderChart(self.finder.result);
        };
        this.finder.searchCompleted.add(onSearchCompleted);

        this.on('mount', function () {
            self.search();
        });

        this.search = () => {
            let criteria = {
                QSetId: opts.qsetId,
                QSeq: opts.qseq,
                OrgId: opts.orgId,
                BeginDate: opts.beginDate,
                EndDate: opts.endDate
            };

            self.finder.search(criteria);
        };

        this.renderChart = (result) => {
            let row0 = null;
            if (!result || result.length <= 0) {
                console.log('No result found.');
            }
            else {
                row0 = result[0]
            }
            let orgName = (row0) ? row0.OrgNameNative : 'Not found';
            let branchName = (row0) ? row0.BranchNameNative : '-';

            self.QSlideText = (row0) ? row0.QSlideTextNative : 'Not found';

            let chartSetup = {
                backgroundColor: '#FCFFC5',
                type: 'column',
                height: 210
            };

            let chartCredits = {
                enabled: false
            };

            let chartTitle = {
                useHTML: true,
                text: '<div class="lhsTitle">Vote summary ' + orgName + ' (' + branchName + ')' + '</div>',
                align: 'left',
                x: 10
            };

            let chartSubTitle = { };

            let chartXAxis = {
                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                crosshair: true
            };

            let chartYAxis = {
                min: 0,
                max: 4,
                title: {
                    text: 'Average'
                }
            };

            let chartToolTip = {

                shared: true
            };

            let items = [];
            if (result) {
                result.forEach(row => {
                    let item = {
                        name: row.QItemTextNative,
                        y: row.Pct
                    };
                    items.push(item);
                });
            }

            let chartSeries = [{
                name: 'EDL',
                data: [2.34, 3.42, 2.61, 3.19, 2.98, 2.56, 2.87, 2.43, 3.34, 3.33, 2.75, 3.41]
            }, {
                name: 'Marketting',
                data: [3.34, 2.42, 3.61, 1.19, 3.98, 3.56, 3.87, 3.45, 3.34, 1.33, 3.75, 1.41]
            }, {
                name: 'Supports',
                data: [2.34, 3.42, 2.61, 2.19, 2.98, 2.56, 2.87, 2.41, 1.34, 3.33, 2.75, 2.41]
            }, {
                name: 'Engineering',
                data: [3.11, 2.11, 3.11, 2.11, 3.11, 2.11, 3.11, 3.11, 2.11, 3.11, 2.11, 3.11]
            }];

            let chartInfo = {
                chart: chartSetup,
                credits: chartCredits,
                title: chartTitle,
                subtitle: chartSubTitle,
                xAxis: chartXAxis,
                yAxis: chartYAxis,
                tooltip: chartToolTip,
                series: chartSeries
            };

            let $outChart = $(this.refs['output-chart']);

            Highcharts.chart($outChart[0], chartInfo);

            self.update();
        };
});
riot.tag2('votesummary-pie-chart', '<div class="m-1 p-1 m-auto r-border"> <div ref="output-chart" class="pie-chart"></div> </div> <div class="v-space">', 'votesummary-pie-chart .r-border,[data-is="votesummary-pie-chart"] .r-border{ border: 1px solid cornflowerblue; border-radius: 5px; } votesummary-pie-chart .v-space,[data-is="votesummary-pie-chart"] .v-space{ min-height: 5px; height: 5px; }', 'class="col-xl-4 col-lg-4 col-md-6 col-sm-12 col-xs-12"', function(opts) {
        let self = this;
        this.finder = new Finder();
        this.QSlideText = '';

        let onModelLoaded = (sender, evtData) => {

            self.search();
        };
        page.modelLoaded.add(onModelLoaded);

        let onSearchCompleted = (sender, evtData) => {

            self.renderChart(self.finder.result);
        };
        this.finder.searchCompleted.add(onSearchCompleted);

        this.on('mount', function () {

            self.search();
        });

        this.search = () => {
            let criteria = {
                QSetId: opts.qsetId,
                QSeq: opts.qseq,
                OrgId: opts.orgId,
                BeginDate: opts.beginDate,
                EndDate: opts.endDate
            };

            self.finder.search(criteria);
        };

        this.renderChart = (result) => {
            let row0 = null;
            if (!result || result.length <= 0) {
                console.log('No result found.');
            }
            else {
                row0 = result[0]
            }
            let orgName = (row0) ? row0.OrgNameNative : 'Not found';
            let branchName = (row0) ? row0.BranchNameNative : '-';

            self.QSlideText = (row0) ? row0.QSlideTextNative : 'Not found';

            let chartSetup = {
                backgroundColor: '#FCFFC5',
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie',
                height: 210
            };

            let chartCredits = {
                enabled: false
            };

            let chartTitle = {
                useHTML: true,
                text: '<div class="lhsTitle">' + orgName + ' (' + branchName + ')' + '</div>',
                align: 'left',
                x: 10
            };

            let chartSubTitle = {

            };

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
                result.forEach(row => {
                    let item = {
                        name: row.QItemTextNative,
                        y: row.Pct
                    };
                    items.push(item);
                });
            }

            let chartSeries = [{
                name: orgName,
                data: items
            }];

            let chartInfo = {
                chart: chartSetup,
                credits: chartCredits,
                title: chartTitle,
                subtitle: chartSubTitle,
                plotOptions: chartPlotOpts,
                tooltip: chartToolTip,
                series: chartSeries
            };

            let $outChart = $(this.refs['output-chart']);

            Highcharts.chart($outChart[0], chartInfo);

            self.update();
        };
});
riot.tag2('votesummary-result-content', '<div ref="chart-container" class="row"> <yield></yield> </div>', '', 'class="container-fluid"', function(opts) {
        let self = this;
        this.tags = [];

        let onModelLoaded = (sender, evtData) => {

        };
        page.modelLoaded.add(onModelLoaded);

        let onSearch = (sender, evtData) => {

            let orgs = [];
            let criteria = evtData;
            if (criteria.OrgId && criteria.OrgId instanceof Array && criteria.OrgId.length > 0) {

                orgs = criteria.OrgId;
            }
            else if (criteria.OrgId && criteria.OrgId.trim().length > 0) {

                orgs = criteria.OrgId.split(",");
            }
            else {

                orgs.push('');
            }

            let $container = $(this.refs['chart-container']);

            let qsetmaps = (report.qModel) ?
                report.qModel.map((item) => { return item.QSetId; }) : null;
            let index = (qsetmaps) ? qsetmaps.indexOf(criteria.QSetId) : -1;
            if (index === -1) {
                console.log('cannot find QSetId.');
                return;
            }

            let qSet = report.qModel[index];
            if (qSet) {

                qSet.slides.forEach(slide => {
                    let elPanelDiv = document.createElement('div');
                    elPanelDiv.setAttribute(`data-is`, `votesummary-result-panel`);
                    elPanelDiv.setAttribute(`qset-id`, qSet.QSetId);
                    elPanelDiv.setAttribute(`qseq`, slide.QSeq);
                    $container.append(elPanelDiv);

                    riot.mount(elPanelDiv, `votesummary-result-panel`);

                    orgs.forEach(item => {
                        criteria.OrgId = item.trim();

                        let elChart = document.createElement('div');
                        elChart.setAttribute(`data-is`, `votesummary-pie-chart`);

                        elChart.setAttribute(`qset-id`, qSet.QSetId);
                        elChart.setAttribute(`qseq`, slide.QSeq);
                        elChart.setAttribute(`org-Id`, criteria.OrgId);
                        elChart.setAttribute(`begin-date`, criteria.BeginDate);
                        elChart.setAttribute(`end-date`, criteria.EndDate);

                        $container.append(elChart);

                        riot.mount(elChart, 'votesummary-pie-chart');
                    });

                    $container.append(document.createElement('br'));
                });
            }
        };
        report.onSearch.add(onSearch);

});
riot.tag2('votesummary-result-panel', '<div class="row"> <virtual if="{slide !== null}"> <div class="col-12"> <label class="QText"><b>{slide.No}. {slide.QSlideTextNative}</b></label> </div> <virtual if="{slide.items !== null}"> <virtual each="{item in slide.items}"> <div class="col-5 offset-1 m-auto p-0"> <label class="CText">{item.No}. {item.QItemTextNative}</label> </div> </virtual> </virtual> </virtual> </div>', 'votesummary-result-panel .QText,[data-is="votesummary-result-panel"] .QText{ display: block; padding-left: 5px; padding-right: 5px; font-size: 1rem; border: 1px solid cornflowerblue; border-radius: 5px; color: whitesmoke; background-color: cornflowerblue; } votesummary-result-panel .CText,[data-is="votesummary-result-panel"] .CText{ margin: 0; padding: 0; font-size: 1rem; }', 'class="container-fluid mt-1"', function(opts) {
        let self = this;
        this.QSetId = opts.qsetId;
        this.QSeq = opts.qseq;
        this.slide = null;

        let onQModelChanged = (sender, evtData) => {
            self.refreshQModel();
        };
        window.report.onQModelChanged.add(onQModelChanged);

        this.on('mount', function () {
            self.refreshQModel();
        });

        this.refreshQModel = () => {

            self.slide = report.getSlide(this.QSetId, this.QSeq);

            self.update();
        };
});
riot.tag2('votesummary-search-box', '<div> <label>Search</label> <textarea ref="jsonSearch" riot-value="{value}"></textarea> <button onclick="{onSearch}">Search</button> </div>', 'votesummary-search-box,[data-is="votesummary-search-box"]{ margin: 0 auto; padding: 15px; font-size: 12pt; } votesummary-search-box label,[data-is="votesummary-search-box"] label{ display: block; font-size: 14pt; color: green; } votesummary-search-box textarea,[data-is="votesummary-search-box"] textarea{ width: 85%; height: 100px; } votesummary-search-box button,[data-is="votesummary-search-box"] button{ margin: 10px, 0 auto; padding: 2px 15px; vertical-align: top; }', '', function(opts) {
        let self = this;

        this.value = JSON.stringify(JSON.parse(`{
            "QSetId": "QS00001",
            "OrgId": ["O0001", "O0003", "O0005", "O0007", "O0009"],
            "BeginDate": "2018-08-01",
            "EndDate": "2018-08-01"
        }`), null, 4);

        let onModelLoaded = (sender, evtData) => {

            self.update();
        };
        page.modelLoaded.add(onModelLoaded);

        this.onSearch = (e) => {
            e.preventDefault();
            var $jsonInput = $(this.refs['jsonSearch']);
            var criteria = JSON.parse($jsonInput.val());

            report.search(criteria);
        };
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