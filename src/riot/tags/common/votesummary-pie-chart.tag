<votesummary-pie-chart>
    <div class="v-space">
    <div class="m-1 p-1 m-auto r-border">
        <div ref="output-chart" class="pie-chart"></div>
    </div>
    <div class="v-space">
    <style>
        :scope {
            min-height: 200px;
            height: 240px;
        }
        .r-border {
            border: 1px solid cornflowerblue;
            border-radius: 5px;
        }
        .v-space {
            min-height: 5px;
            height: 5px;
        }
    </style>
    <script>
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
                backgroundColor: '#FCFFC5', // if include css change .highcharts-background instead.
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie',
                height: 210
            };
            let chartCredits = { enabled: false };
            let chartTitle = {
                useHTML: true,
                text: '<div class="lhsTitle">' + orgName + ' (' + branchName + ')' + '</div>',
                align: 'left',
                x: 10
            };
            let chartSubTitle = { };
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
                org.items.forEach(row => {                    
                    let item = { name: row.QItemText, y: row.Pct };
                    items.push(item);
                });
            }

            let chartSeries = [{ name: orgName, data: items }];

            //console.log('init chart...');
            let chartInfo = {
                chart: chartSetup,
                credits: chartCredits,
                title: chartTitle,
                subtitle: chartSubTitle,
                plotOptions: chartPlotOpts,
                tooltip: chartToolTip,
                series: chartSeries
            };
            //console.log('info:', chartInfo);
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
    </script>
</votesummary-pie-chart>