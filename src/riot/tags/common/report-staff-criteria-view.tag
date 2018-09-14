<report-staff-criteria-view>
    <virtual if={(criteria !== null && criteria.member !== null && criteria.member.selectedItems != null && criteria.member.selectedItems.length > 0)}>
        <div class="tag-box">
            <div class="row">
                <div class="col-2 mr-0 pr-0">
                    <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a>
                    <span class="tag-caption">{caption}</span>
                </div>
                <div class="col-10 ml-0 pl-0">
                    <virtual each={item in criteria.member.selectedItems}>
                        <span class="tag-item">{item.FullName}<span class="tag-close" onclick="{removeTagItem}"></span></span>
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

        let memberchanged = (sender, evt) => {
            //console.log('member changed.');
            self.update();
        };

        this.on('mount', () => {
            //console.log('mount: add handers.');
            self.criteria.member.changed.add(memberchanged);
        });

        this.on('unmount', () => {
            //console.log('unmount: remove handers.');
            self.criteria.member.changed.remove(memberchanged);
        });
        
        this.clearTagItems = (e) => {
            self.criteria.member.clear();
        };

        this.removeTagItem = (e) => {
            let target = e.item;
            let memberid = target.item.MemberId;
            let removeIndex = self.criteria.member.indexOf(memberid);
            self.criteria.member.remove(removeIndex);
        };
    </script>
</report-staff-criteria-view>