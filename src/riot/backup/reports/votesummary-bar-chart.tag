<votesummary-bar-chart>
    <div class="m-1 p-1 m-auto r-border">
        <div ref="output-chart" class="pie-chart"></div>
    </div>
    <style>
        .r-border {
            border: 1px solid cornflowerblue;
            border-radius: 5px;
        }
    </style>
    <script>
        let self = this;
        this.finder = new Finder();
        this.QSlideText = '';

        let onModelLoaded = (sender, evtData) => {
            //console.log('model load...');
            self.search();
        };
        page.modelLoaded.add(onModelLoaded);

        let onSearchCompleted = (sender, evtData) => {
            //console.log('Vote Summary: ', self.finder.result);
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
            //console.log('options:', criteria);
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
            //let qslidetext = (row0) ? row0.QSlideTextNative : 'Not found';
            self.QSlideText = (row0) ? row0.QSlideTextNative : 'Not found';

            let chartSetup = {
                backgroundColor: '#FCFFC5', // if include css change .highcharts-background instead.
                type: 'column',
                height: 210
            };

            let chartCredits = {
                enabled: false
            };
            // compare...between data...
            let chartTitle = {
                useHTML: true,
                text: '<div class="lhsTitle">Vote summary ' + orgName + ' (' + branchName + ')' + '</div>',
                align: 'left',
                x: 10
            };

            let chartSubTitle = { };
            // the orgs to compare.
            let chartXAxis = {
                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                crosshair: true
            };
            // min-max choice.
            let chartYAxis = {
                min: 0,
                max: 4,
                title: {
                    text: 'Average'
                }
            };

            let chartToolTip = {
                /*
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.2f}</b></td></tr>',
                footerFormat: '</table>',
                useHTML: true,
                */
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
            //console.log('init chart...');
            let $outChart = $(this.refs['output-chart']);

            Highcharts.chart($outChart[0], chartInfo);

            self.update();
        };
    </script>
</votesummary-bar-chart>