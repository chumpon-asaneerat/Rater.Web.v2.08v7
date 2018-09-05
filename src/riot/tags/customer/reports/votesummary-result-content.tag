<votesummary-result-content class="container-fluid">
    <div ref="chart-container" class="row">
        <yield />
    </div>
    <script>
        let self = this;
        this.tags = [];

        let onModelLoaded = (sender, evtData) => {
            //console.log('model load...');
            /*
            self.tags.forEach(tag => {
                riot.unmount(elChart);
            });
            */

            self.update();
        };
        page.modelLoaded.add(onModelLoaded);

        let onSearch = (sender, evtData) => {
            //console.log('detected search request.');
            //console.log('criteria:', evtData);
            let orgs = [];
            let criteria = evtData;
            if (criteria.OrgId && criteria.OrgId instanceof Array && criteria.OrgId.length > 0) {
                //console.log('detected array.');
                orgs = criteria.OrgId;
            }
            else if (criteria.OrgId && criteria.OrgId.trim().length > 0) {
                //console.log('detected string.');
                orgs = criteria.OrgId.split(",");
            }
            else {
                //console.log('detected null object or empty string.');
                orgs.push('');
            }

            let $container = $(this.refs['chart-container']);

            orgs.forEach(item => {
                criteria.OrgId = item.trim();

                let elChart = document.createElement('div');
                elChart.setAttribute(`data-is`, `votesummary-pie-chart`)
                //elChart.setAttribute(`customer-id`, criteria.CustomerID);
                elChart.setAttribute(`qset-id`, criteria.QSetId);
                elChart.setAttribute(`qseq`, criteria.QSeq);
                elChart.setAttribute(`org-Id`, criteria.OrgId);
                elChart.setAttribute(`begin-date`, criteria.BeginDate);
                elChart.setAttribute(`end-date`, criteria.EndDate);

                $container.append(elChart);

                //self.tags.push(elChart);

                riot.mount(elChart, 'votesummary-pie-chart');
            });
        };
        report.onSearch.add(onSearch);

    </script>
</votesummary-result-content>