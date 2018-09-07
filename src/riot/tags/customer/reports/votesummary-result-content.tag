<votesummary-result-content class="container-fluid">
    <div ref="chart-container" class="row">
        <yield />
    </div>
    <script>
        let self = this;
        this.tags = [];

        let onModelLoaded = (sender, evtData) => {
            //console.log('model load...');
            //self.update();
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

            let qsetmaps = (report.qModel) ? 
                report.qModel.map((item) => { return item.QSetId; }) : null;
            let index = (qsetmaps) ? qsetmaps.indexOf(criteria.QSetId) : -1;
            if (index === -1) {
                console.log('cannot find QSetId.');
                return;
            }

            let qSet = report.qModel[index];
            if (qSet) {
                //console.log(qSet);
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
                        //elChart.setAttribute(`customer-id`, criteria.CustomerID);
                        elChart.setAttribute(`qset-id`, qSet.QSetId);
                        elChart.setAttribute(`qseq`, slide.QSeq);
                        elChart.setAttribute(`org-Id`, criteria.OrgId);
                        elChart.setAttribute(`begin-date`, criteria.BeginDate);
                        elChart.setAttribute(`end-date`, criteria.EndDate);

                        $container.append(elChart);

                        //self.tags.push(elChart);

                        riot.mount(elChart, 'votesummary-pie-chart');
                    });

                    $container.append(document.createElement('br'));
                });
            }
        };
        report.onSearch.add(onSearch);

    </script>
</votesummary-result-content>