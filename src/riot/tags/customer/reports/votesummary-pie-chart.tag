<votesummary-pie-chart class="col-4">
    <div ref="output-chart" class="bar-chart"></div>
    <script>
        let self = this;
        this.finder = new Finder();

        let onModelLoaded = (sender, evtData) => {
            //console.log('model load...');
            self.search();
            self.update();
        };
        page.modelLoaded.add(onModelLoaded);

        let onSearchCompleted = (sender, evtData) => {
            //console.log('Vote Summary: ', self.finder.result);
            self.renderChart(self.finder.result);
        };
        this.finder.searchCompleted.add(onSearchCompleted);

        this.on('mount', function () {
            //console.log('mount....');
            self.search();
        });
        /*
        this.on('update', function () {
            //console.log('update....');
        });

        this.on('unmount', function () {
            //console.log('unmount....');
        });
        */

        this.search = () => {
            let criteria = {
                CustomerID: opts.customerId,
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
            
            let chartSetup = {
                backgroundColor: '#FCFFC5', // if include css change .highcharts-background instead.
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie'
            };

            let chartTitle = {
                useHTML: true,
                text: '<div class="lhsTitle">' + orgName + ' (' + branchName + ')' + '</div>',
                align: 'left',
                x: 10
            };

            let chartToolTip = {
                // for pie
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
                        name: 'Choice ' + row.Choice,
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
                title: chartTitle,
                plotOptions: chartPlotOpts,
                tooltip: chartToolTip,
                series: chartSeries
            };
            //console.log('init chart...');
            let $outChart = $(this.refs['output-chart']);
            
            Highcharts.chart($outChart[0], chartInfo);
        };
    </script>
</votesummary-pie-chart>