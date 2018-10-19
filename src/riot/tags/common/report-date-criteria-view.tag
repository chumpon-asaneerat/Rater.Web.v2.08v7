<report-date-criteria-view>
    <div ref="tag-date"></div>
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
            if (!self.criteria.date) return [];
            let results = [];
            let dobj = self.criteria.date;
            if (dobj.beginDate) {
                results.push({ id: 1, text: dobj.beginDate })
                if (dobj.endDate) {
                    results.push({ id: 2, text: dobj.endDate })
                }
            }
            return results;
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.date) return;
            self.criteria.date.clear();
        };
        let removeItem = (sender, evtData) => {
            let target = sender;
            let id = target.id;
            if (id === 1) // remove begin date so clear end date too.
                self.criteria.date.clear();
            else {
                self.criteria.date.endDate = null; // remove only end date.
            }
        };

        // riot handlers.
        this.on('mount', () => {
            self.criteria.date.changed.add(changed);

            elem = this.refs["tag-date"];
            tagbox = new NGui.TagBox(elem);
            // binding
            tagbox.caption = 'Date';
            tagbox.valueMember = 'text';
            // setup handlers
            tagbox.clearItems.add(clearItems);
            tagbox.removeItem.add(removeItem);
        });

        this.on('unmount', () => {
            self.criteria.date.changed.remove(changed);

            if (tagbox) {
                // cleanup.
                tagbox.clearItems.remove(clearItems);
                tagbox.removeItem.remove(removeItem);
            }
            tagbox = null;
            elem = null;
        });
    </script>
</report-date-criteria-view>