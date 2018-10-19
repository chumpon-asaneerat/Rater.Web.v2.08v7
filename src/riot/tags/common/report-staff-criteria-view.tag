<report-staff-criteria-view>
    <div ref="tag-staff"></div>
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
            self.criteria.member.changed.add(changed);
        };

        let unbindEvents = () => {
            self.criteria.member.changed.remove(changed);
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
            if (!self.criteria.member) return [];
            return self.criteria.member.selectedItems;
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.member) return;
            self.criteria.member.clear();
        };
        let removeItem = (sender, evtData) => {
            let target = sender;
            let id = target.MemberId;
            let removeIndex = self.criteria.member.indexOf(id);
            self.criteria.member.remove(removeIndex);
        };

        // riot handlers.
        this.on('mount', () => {
            bindEvents();

            elem = this.refs["tag-staff"];
            tagbox = new NGui.TagBox(elem);
            // binding
            tagbox.caption = 'Staffs';
            tagbox.valueMember = 'FullName';
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
</report-staff-criteria-view>