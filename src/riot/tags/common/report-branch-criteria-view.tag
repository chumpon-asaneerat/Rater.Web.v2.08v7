<report-branch-criteria-view>
    <div ref="tag-branch"></div>
    <style>
        :scope {
            margin: 0 auto;
        }
    </style>
    <script>
        let self = this;

        this.caption = this.opts.caption;
        this.criteria = report.search.current;
        let elem, tagbox;

        let bindEvents = () => {
            self.criteria.branch.changed.add(changed);
        };

        let unbindEvents = () => {
            self.criteria.branch.changed.remove(changed);
        };

        let newCriteria = (sender, evt) => {
            //console.log('detected new criteria created.');
            unbindEvents();
            self.criteria = report.search.current;
            bindEvents();
            tagbox.items = getItems();
        };
        report.search.newCriteriaCreated.add(newCriteria);

        let changed = (sender, evt) => {
            //console.log('qset changed.');
            tagbox.items = getItems();
        };

        let getItems = () => {
            if (!self.criteria) return [];
            if (!self.criteria.branch) return [];
            return self.criteria.branch.selectedItems;
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.branch) return;
            self.criteria.branch.clear();
            // remove related orgs.
            //self.criteria.org.clear();
        };
        let removeItem = (sender, evtData) => {
            let target = sender;
            let id = target.BranchId;
            let removeIndex = self.criteria.branch.indexOf(id);
            self.criteria.branch.remove(removeIndex);
            // remove related orgs.
            /*
            let orgs = self.criteria.org.getItems();
            orgs.forEach(org => {                
                if (org.BranchId === id) {
                    let oidx = self.criteria.org.indexOf(org.OrgId);
                    self.criteria.org.remove(oidx);
                }
            });
            */
        };

        // riot handlers.
        this.on('mount', () => {
            bindEvents();

            elem = this.refs["tag-branch"];
            tagbox = new NGui.TagBox(elem);
            // binding
            tagbox.caption = 'Branchs';
            tagbox.valueMember = 'BranchName';
            // setup handlers
            tagbox.clearItems.add(clearItems);
            tagbox.removeItem.add(removeItem);
        });

        this.on('unmount', () => {
            unbindEvents();

            if (tagbox) {
                // cleanup.
                tagbox.clearItems.remove(clearItems);
                tagbox.removeItem.remove(removeItem);
            }
            tagbox = null;
            elem = null;
        });
    </script>
</report-branch-criteria-view>