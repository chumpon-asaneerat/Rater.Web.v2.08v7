<report-question-criteria-view>
    <virtual if={(criteria !== null && criteria.question !== null && criteria.question.selectedItems != null && criteria.question.selectedItems.length > 0)}>
        <div class="tag-box">
            <div class="row">
                <div class="tag-r-col mr-0 pr-0">
                    <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a>
                    <span class="tag-caption">{caption}</span>
                </div>
                <div class="tag-c-col ml-0 pl-0">
                    <virtual each={item in criteria.question.selectedItems}>
                        <span class="tag-item">{item.QSlideText}<span class="tag-close" onclick="{removeTagItem}"></span></span>
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

        let quesionchanged = (sender, evt) => {
            //console.log('question changed.');
            self.update();
        };

        this.on('mount', () => {
            //console.log('mount: add handers.');
            self.criteria.question.changed.add(quesionchanged);
        });

        this.on('unmount', () => {
            //console.log('unmount: remove handers.');
            self.criteria.question.changed.remove(quesionchanged);
        });

        this.clearTagItems = (e) => {
            self.criteria.question.clear();
        };

        this.removeTagItem = (e) => {
            let target = e.item;
            let qseq = target.item.QSeq;
            let removeIndex = self.criteria.question.indexOf(qseq);
            self.criteria.question.remove(removeIndex);
        };
    </script>
</report-question-criteria-view>