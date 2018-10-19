<votesummary-result-content class="container-fluid">
    <div ref="chart-container" class="row">
        <yield />
    </div>

    <script>
        let self = this;
        this.tags = [];

        let onSearchCompleted = (sender, evtData) => {
            //console.log('model load...');
            let data = evtData.data;

            let $container = $(this.refs['chart-container']);
            let elPanelDiv = document.createElement('div');
            elPanelDiv.setAttribute(`data-is`, `votesummary-result-panel`);
            //elPanelDiv.setAttribute(`qset-id`, qSet.QSetId);
            //elPanelDiv.setAttribute(`qseq`, slide.QSeq);
            $container.append(elPanelDiv);

            let panel = riot.mount(elPanelDiv, `votesummary-result-panel`, { data: data});
        };
        report.search.searchCompleted.add(onSearchCompleted);        
</votesummary-result-content>