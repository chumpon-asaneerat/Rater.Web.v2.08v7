<votesummary-search-box>
    <div>
        <label>Search</label>
        <textarea ref="jsonSearch" value="{value}"></textarea>
        <button onclick="{onSearch}">Search</button>
    </div>
    <style>
        :scope {
            margin: 0 auto;
            padding: 15px;
            font-size: 12pt;
        }

        label {
            display: block;
            font-size: 14pt;
            color: green;
        }

        textarea {
            width: 85%;
            height: 100px;
        }

        button {
            margin: 10px, 0 auto;
            padding: 2px 15px;
            vertical-align: top;
        }
    </style>
    <script>
        let self = this;

        this.value = JSON.stringify(JSON.parse(`{
            "QSetId": "QS00001",
            "QSeq": "1",
            "OrgId": "O0011",
            "BeginDate": "2018-08-01",
            "EndDate": "2018-08-01"
        }`), null, 4);

        let onModelLoaded = (sender, evtData) => {
            //console.log('model load...');
            self.update();
        };
        page.modelLoaded.add(onModelLoaded);

        this.onSearch = (e) => {
            e.preventDefault();
            var $jsonInput = $(this.refs['jsonSearch']);
            var criteria = JSON.parse($jsonInput.val());
            //console.log(criteria);
            report.search(criteria);
        };
    </script>
</votesummary-search-box>