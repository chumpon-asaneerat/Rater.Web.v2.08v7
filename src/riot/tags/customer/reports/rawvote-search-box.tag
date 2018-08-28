<rawvote-search-box>
    <!--
    <div class="tags-input" data-name="tag-input">
        <span class="tag">ชุดคำถามที่ 1<span class="close"></span></span>
        <span class="tag">ชุดคำถามที่ 2<span class="close"></span></span>
        <span class="tag">ชุดคำถามที่ 3<span class="close"></span></span>
        <input class="search-input" type="text"/>
        <span class="clear-input"></span>
    </div>
    -->
    <div>
        <textarea ref="jsonSearch" value="{value}"></textarea>
        <button onclick="{onSearch}">Search</button>
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

        .tags-input {
            margin: 0 auto;
            padding: 1px;
            border: 1px solid #333;
            display: inline-block;
            font-size: 0.5em;
        }
        .tags-input .tag {
            margin: 3px auto;
            padding: 5px;
            display: inline-block;
            color:white;
            background-color: cornflowerblue;
            cursor: pointer;
        }
        .tags-input .tag:hover {
            color:yellow;
            background-color: dimgray;
            transition: all 0.1s linear;
        }
        .tags-input .tag .close::after {
            content: 'x';
            font-weight: bold;
            display: inline-block;
            transform: scale(0.5) translateY(-5px);
            margin-left: 3px;
            color: white;
        }
        .tags-input .tag .close:hover::after {
            color:red;
            transition: all 0.1s linear;
        }
        .tags-input .search-input {
            border: 0;
            outline: 0;
            padding: 1px;
        }
        .tags-input .clear-input::after {
            margin: 5px auto;
            margin-top: 0px;
            margin-right: 10px;
            content: 'x';
            font-weight: bold;
            display: inline-block;
            color: black;
            cursor: pointer;
        }
        .tags-input .clear-input:hover::after {
            color:red;
            transition: all 0.1s linear;
        }
        .autocomplete-items {
            position: absolute;
            border: 1px solid #d4d4d4;
            border-bottom: none;
            border-top: none;
            z-index: 99;
            /* position the autocomplete items to be the same width as the container: */            
            top: 100%;
            left: 0;
            right: 0;
        }
        .autocomplete-items div {
            padding: 10px;
            cursor: pointer;
            background-color: #fff; 
            border-bottom: 1px solid #d4d4d4; 
        }
        .autocomplete-items div:hover {
            background-color: #e9e9e9; 
        }
        .autocomplete-active {
            /* when navigating through the items using the arrow keys: */
            background-color: DodgerBlue !important; 
            color: #ffffff; 
        }
    </style>
    <script>
        let self = this;
        /*
        this.sources = [];
        this.initSource = () => {
           var tagsDIV = $(".tags-input", self.root)[0];
           console.log(tagsDIV);
        };
        */

        /*
        this.on('mount', function () {
            //console.log('mount....');
            self.initSource();
        });
        */

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

        this.onSearch = (e) => {
            e.preventDefault();
            var $jsonInput = $(this.refs['jsonSearch']);
            var criteria = JSON.parse($jsonInput.val());
            //console.log(criteria);
        };
    </script>
</rawvote-search-box>