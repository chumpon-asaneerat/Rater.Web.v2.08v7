<report-qset-criteria-view>
    <virtual if={(criteria !== null && criteria.qset !== null && criteria.qset.QSet !== null)}>
        <div class="tag-box">
            <div class="row">
                <div class="col-2 mr-0 pr-0">
                    <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a>
                    <span class="tag-caption">{caption}</span>
                </div>
                <div class="col-10 ml-0 pl-0">
                    <span class="tag-item">{criteria.qset.QSet.QSetDescription}<span class="tag-close" onclick="{removeTagItem}"></span></span>
                </div>
            </div>
        </div>
    </virtual>
    <style>
        :scope {
            margin: 0 auto;
            padding: 0;
        }
    </style>
    <script>
        let self = this;

        this.caption = this.opts.caption;
        this.criteria = report.search.current;

        let qsetchanged = (sender, evt) => {
            //console.log('qset changed.');
            self.update();
        };

        this.on('mount', () => {
            //console.log('mount: add handers.');
            self.criteria.qset.changed.add(qsetchanged);
        });

        this.on('unmount', () => {
            //console.log('unmount: remove handers.');
            self.criteria.qset.changed.remove(qsetchanged);
        });

        this.clearTagItems = (e) => {
            self.criteria.qset.QSetId = null;            
        };

        this.removeTagItem = (e) => {
            self.criteria.qset.QSetId = null;
        };
    </script>
</report-qset-criteria-view>