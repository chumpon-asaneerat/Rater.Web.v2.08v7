<report-date-criteria-view>
    <virtual if={(items !==null && items.length> 0)}>
        <div class="tag-box">
            <div class="row">
                <div class="col-2 mr-0 pr-0">
                    <a href="#"><span class="tag-clear" onclick="{clearTagItems}"></span></a>
                    <span class="tag-caption">{caption}</span>
                </div>
                <div class="col-10 ml-0 pl-0">
                    <virtual each={tag in items}>
                        <span class="tag-item">{tag.text}<span class="tag-close" onclick="{removeTagItem}"></span></span>
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
        this.items = [
            { id: '1', text: '2018-08-01' },
            { id: '2', text: '2018-08-01' }
        ];
        
        this.clearTagItems = (e) => {
            if (self.items && self.items.length > 0) {
                self.items.splice(0);
                // refresh
                self.update();
            }
        };

        this.removeTagItem = (e) => {
            let target = e.item;
            if (self.items && self.items.length > 0) {
                let maps = self.items.map(item => { return item.id; });            
                let index = maps.indexOf(target.tag.id);
                self.items.splice(index, 1);
                // refresh
                self.update();
            }
        };
    </script>
</report-date-criteria-view>