<report-search-box>
    <div>
        <div>
            <input ref="tag-input" type="text" onfocus="{onFocus}" oninput="{onInput}" onblur="{onBlur}">
            <div ref="tag-dropdown" class="autocomplete-items">
                <span class="autocomplete-item">Softbase</span>
                <span class="autocomplete-item">Marketing</span>
                <span class="autocomplete-item">Account</span>
                <span class="autocomplete-item">Manufacture</span>
                <span class="autocomplete-item">Supports</span>
            </div>
        </div>
        <div data-is="report-qset-criteria-view" caption="QSets"></div>
        <div data-is="report-date-criteria-view" caption="Date"></div>
        <div data-is="report-question-criteria-view" caption="Questions"></div>
        <div data-is="report-branch-criteria-view" caption="Branchs"></div>
        <div data-is="report-org-criteria-view" caption="Orgs"></div>
        <div data-is="report-staff-criteria-view" caption="Staffs"></div>
        <!--
        <div class="tag-box">
            <a href="#"><span class="tag-clear"></span></a>
            <span class="tag-caption">Date</span>            
            <span class="tag-item">2018-08-01 - 2018-09-30</span>
        </div>
        -->
    </div>
    <style>
        :scope {
            margin: 0 auto;
            padding: 15px;
            font-size: 14px;
        }

        input[type='text'] {
            display: inline-block;
            margin: 0 auto;
            width: 100%;
        }

        .autocomplete-items {
            display: none;
            position: absolute;
            margin: 1px auto;
            padding: 5px;
            color: silver;
            background-color: white;
            border: 1px solid dimgray;
            border-radius: 5px;
            top: 43px; /* parent-height */
            left: 15px;
            right: 15px;
            z-index: 100;
        }

        .autocomplete-items.show {
            display: inline-block;
        }

        .autocomplete-items .autocomplete-item {
            position:relative;
            padding: 2px;
            display: block;
            cursor: pointer;
        }

        .autocomplete-items .autocomplete-item:hover {
            color: white;
            background-color: cornflowerblue;
        }
    </style>
    <script>
        let self = this;

        let tagdropdown = null;
        
        this.on('mount', () => {
            tagdropdown = this.refs["tag-dropdown"];
            //console.log(tagdropdown);
        });

        this.on('unmount', () => {
            tagdropdown = null;
        });

        this.onFocus = (e) => {
            //console.log('focus', e);
            if (!tagdropdown) {
                console.log('dropdown element not found.');
                return;
            }
            let $tagdd = $(tagdropdown);
            $tagdd.addClass('show');
            //console.log($tagdd);
        };
        this.onInput = (e) => {
            //console.log('input', e);
        };
        this.onBlur = (e) => {
            //console.log('blur', e);
            if (!tagdropdown) {
                console.log('dropdown element not found.');
                return;
            }
            let $tagdd = $(tagdropdown);
            $tagdd.removeClass('show');
            //console.log($tagdd);
        };
    </script>
</report-search-box>