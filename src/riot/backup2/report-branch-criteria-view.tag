<report-branch-criteria-view>
    <virtual if={(criteria !== null && criteria.branch !== null && criteria.branch.selectedItems != null && criteria.branch.selectedItems.length > 0)}>
        <div class="tag-box">
            <div class="row">
                <div class="tag-r-col mr-0 pr-0">
                    <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a>
                    <span class="tag-caption">{caption}</span>
                </div>
                <div class="tag-c-col ml-0 pl-0">
                    <virtual each={item in criteria.branch.selectedItems}>
                        <span class="tag-item">{item.BranchName}<span class="tag-close" onclick="{removeTagItem}"></span></span>
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

        let branchchanged = (sender, evt) => {
            //console.log('branch changed.');
            self.update();
        };

        this.on('mount', () => {
            //console.log('mount: add handers.');
            self.criteria.branch.changed.add(branchchanged);
        });

        this.on('unmount', () => {
            //console.log('unmount: remove handers.');
            self.criteria.branch.changed.remove(branchchanged);
        });
        
        this.clearTagItems = (e) => {
            self.criteria.branch.clear();
        };

        this.removeTagItem = (e) => {
            let target = e.item;
            let branchid = target.item.BranchId;
            let removeIndex = self.criteria.branch.indexOf(branchid);
            self.criteria.branch.remove(removeIndex);
        };
    </script>
</report-branch-criteria-view>