<report-search-box>
    <div>
        <div data-is="report-qset-criteria-view" caption="QSets"></div>
        <div data-is="report-date-criteria-view" caption="Date"></div>
        <div data-is="report-question-criteria-view" caption="Questions"></div>
        <div data-is="report-branch-criteria-view" caption="Branchs"></div>
        <div data-is="report-org-criteria-view" caption="Orgs"></div>
        <div data-is="report-staff-criteria-view" caption="Staffs"></div>
        <div ref="tag-input"></div>
        
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
        /*
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
            top: 43px;
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
        */
    </style>
    <script>
        let self = this;

        let taginput = null;
        let autofill = null;
        
        // riot handlers.
        this.on('mount', () => {
            taginput = this.refs["tag-input"];
            autofill = new AutoFill(taginput);
        });

        this.on('unmount', () => {
            if (autofill) {
                // cleanup.
            }
            autofill = null;
            taginput = null;
        });
    </script>
</report-search-box>