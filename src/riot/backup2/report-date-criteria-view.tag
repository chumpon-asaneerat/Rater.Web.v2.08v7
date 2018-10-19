<report-date-criteria-view>
    <virtual if={(criteria !== null && criteria.date !== null && (criteria.date.beginDate !== null || criteria.date.endDate !== null))}>
        <div class="tag-box">
            <div class="row">
                <div class="tag-r-col mr-0 pr-0">
                    <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a>
                    <span class="tag-caption">{caption}</span>
                </div>
                <div class="tag-c-col ml-0 pl-0">
                    <virtual if={criteria.date.beginDate !== null && criteria.date.endDate === null}>
                        <span class="tag-item">{criteria.date.beginDate}<span class="tag-close" onclick="{removeBeginDate}"></span></span>
                    </virtual>
                    <virtual if={criteria.date.beginDate === null && criteria.date.endDate !== null}>
                        <span class="tag-item">{criteria.date.endDate}<span class="tag-close" onclick="{removeEndDate}"></span></span>
                    </virtual>
                    <virtual if={criteria.date.beginDate !== null && criteria.date.endDate !== null}>
                        <span class="tag-item">{criteria.date.beginDate}<span class="tag-close" onclick="{removeBeginDate}"></span></span>
                        <span>-</span>
                        <span class="tag-item">{criteria.date.endDate}<span class="tag-close" onclick="{removeEndDate}"></span></span>
                    </virtual>
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

        let datechanged = (sender, evt) => {
            //console.log('qset changed.');
            self.update();
        };

        this.on('mount', () => {
            //console.log('mount: add handers.');
            self.criteria.date.changed.add(datechanged);
        });

        this.on('unmount', () => {
            //console.log('unmount: remove handers.');
            self.criteria.date.changed.remove(datechanged);
        });

        this.clearTagItems = (e) => {
            self.criteria.date.clear();
        };

        this.removeBeginDate = (e) => {
            self.criteria.date.beginDate = null;
        };

        this.removeEndDate = (e) => {
            self.criteria.date.endDate = null;
        };
    </script>
</report-date-criteria-view>