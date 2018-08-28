<votesummary-search-box>
    <div>
        <textarea ref="jsonSearch" value="{value}"></textarea>
        <button onclick="{onXXX}">Search</button>
    </div>
    <style>
        :scope {
            margin: 0 auto;
            padding: 15px;
            font-size: 12pt;
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
            "LangId": "TH",
            "CustomerID": "EDL-C2018080001",
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

        this.onXXX = (e) => {
            e.preventDefault();
            var $jsonInput = $(this.refs['jsonSearch']);
            var criteria = JSON.parse($jsonInput.val());
            //console.log(criteria);
        };
    </script>
</votesummary-search-box>