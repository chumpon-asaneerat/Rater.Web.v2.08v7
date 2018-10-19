<report-qset-criteria-view>
    <div ref="tag-qset"></div>
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

        let changed = (sender, evt) => {
            //console.log('qset changed.');
            tagbox.items = getItems();
        };

        let getItems = () => {
            if (!self.criteria) return [];
            if (!self.criteria.qset) return [];
            if (!self.criteria.qset.QSet) return [];
            return [ self.criteria.qset.QSet ];
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.qset) return;
            self.criteria.qset.QSetId = '';
        };
        let removeItem = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.qset) return;
            self.criteria.qset.QSetId = '';
        };

        // riot handlers.
        this.on('mount', () => {
            self.criteria.qset.changed.add(changed);

            elem = this.refs["tag-qset"];
            tagbox = new NGui.TagBox(elem);
            // binding
            tagbox.caption = 'QSets';
            tagbox.valueMember = 'QSetDescription';
            // setup handlers
            tagbox.clearItems.add(clearItems);
            tagbox.removeItem.add(removeItem);
        });

        this.on('unmount', () => {
            self.criteria.qset.changed.remove(changed);

            if (tagbox) {
                // cleanup.
                tagbox.clearItems.remove(clearItems);
                tagbox.removeItem.remove(removeItem);
            }
            tagbox = null;
            elem = null;
        });
    </script>
</report-qset-criteria-view>