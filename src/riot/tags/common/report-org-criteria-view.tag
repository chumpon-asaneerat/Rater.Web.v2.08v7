<report-org-criteria-view>
    <virtual if={(criteria !== null && criteria.org !== null && criteria.org.selectedItems != null && criteria.org.selectedItems.length > 0)}>
        <div class="tag-box">
            <div class="row">
                <div class="col-2 mr-0 pr-0">
                    <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a>
                    <span class="tag-caption">{caption}</span>
                </div>
                <div class="col-10 ml-0 pl-0">
                    <virtual each={item in criteria.org.selectedItems}>
                        <span class="tag-item {item.Invalid}">{item.OrgName}<span class="tag-close" onclick="{removeTagItem}"></span></span>
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

        let orgchanged = (sender, evt) => {
            //console.log('org changed.');
            self.update();
        };

        this.on('mount', () => {
            //console.log('mount: add handers.');
            self.criteria.org.changed.add(orgchanged);
        });

        this.on('unmount', () => {
            //console.log('unmount: remove handers.');
            self.criteria.org.changed.remove(orgchanged);
        });
        
        this.clearTagItems = (e) => {
            self.criteria.org.clear();
        };

        this.removeTagItem = (e) => {
            let target = e.item;
            let orgid = target.item.OrgId;
            let removeIndex = self.criteria.org.indexOf(orgid);
            self.criteria.org.remove(removeIndex);
        };
    </script>
</report-org-criteria-view>