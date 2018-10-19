<report-question-criteria-view>
    <div ref="tag-ques"></div>
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
            self.criteria.question.changed.add(changed);
        };

        let unbindEvents = () => {
            self.criteria.question.changed.remove(changed);
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
            if (!self.criteria.question) return [];
            return self.criteria.question.selectedItems;
        };

        let clearItems = (sender, evtData) => {
            if (!self.criteria) return;
            if (!self.criteria.question) return;
            self.criteria.question.clear();
        };
        let removeItem = (sender, evtData) => {
            let target = sender;
            let id = target.QSeq;
            let removeIndex = self.criteria.question.indexOf(id);
            self.criteria.question.remove(removeIndex);
        };

        // riot handlers.
        this.on('mount', () => {
            bindEvents();

            elem = this.refs["tag-ques"];
            tagbox = new NGui.TagBox(elem);
            // binding
            tagbox.caption = 'Questions';
            tagbox.valueMember = 'QSlideText';
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
</report-question-criteria-view>