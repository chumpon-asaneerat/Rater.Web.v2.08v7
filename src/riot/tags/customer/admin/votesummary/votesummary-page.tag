<votesummary-page>
    <div data-is="sidebars" data-simplebar></div>
    <div data-is="search-content" data-simplebar>
        <div class="tags-input" data-name="tag-input">
            <span class="tag">ชุดคำถามที่ 1<span class="close"></span></span>
            <span class="tag">ชุดคำถามที่ 2<span class="close"></span></span>
            <span class="tag">ชุดคำถามที่ 3<span class="close"></span></span>
            <input class="search-input" type="text"/>
            <span class="clear-input"></span>
        </div>
        <div id="container1" class="bar-chart"></div>
    </div>
    <style>
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
            /*position the autocomplete items to be the same width as the container:*/
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
            /*when hovering an item:*/
            background-color: #e9e9e9; 
        }
        .autocomplete-active {
            /*when navigating through the items using the arrow keys:*/
            background-color: DodgerBlue !important; 
            color: #ffffff; 
        }
    </style>
    <script>
        let self = this;
        this.sources = [];

        this.initSource = () => {
            /*
            var $root = $(self.root);
            console.log($root);
            var $inputs = $root.find('.search-content .tags-input .search-input')[0];
            console.log($inputs);
            */
           //var $inputs = $(".tags-input");
           var tagsDIV = $(".tags-input", self.root)[0];
           console.log(tagsDIV);
        };

        /*
        [].forEach.call(document.getElementsByClassName('tags-input'), function (el) {
            let hiddenInput = document.createElement('input'),
                mainInput = document.createElement('input'),
                tags = [];

            hiddenInput.setAttribute('type', 'hidden');
            hiddenInput.setAttribute('name', el.getAttribute('data-name'));

            searchInput.setAttribute('type', 'text');
            searchInput.classList.add('search-input');
            searchInput.addEventListener('input', function () {
                let enteredTags = searchInput.value.split(',');
                if (enteredTags.length > 1) {
                    enteredTags.forEach(function (t) {
                        let filteredTag = filterTag(t);
                        if (filteredTag.length > 0)
                            addTag(filteredTag);
                    });
                    searchInput.value = '';
                }
            });

            searchInput.addEventListener('keydown', function (e) {
                let keyCode = e.which || e.keyCode;
                if (keyCode === 8 && searchInput.value.length === 0 && tags.length > 0) {
                    removeTag(tags.length - 1);
                }
            });

            el.appendChild(searchInput);
            el.appendChild(hiddenInput);

            addTag('hello!');

            function addTag(text) {
                let tag = {
                    text: text,
                    element: document.createElement('span'),
                };

                tag.element.classList.add('tag');
                tag.element.textContent = tag.text;

                let closeBtn = document.createElement('span');
                closeBtn.classList.add('close');
                closeBtn.addEventListener('click', function () {
                    removeTag(tags.indexOf(tag));
                });
                tag.element.appendChild(closeBtn);

                tags.push(tag);

                el.insertBefore(tag.element, mainInput);

                refreshTags();
            }

            function removeTag(index) {
                let tag = tags[index];
                tags.splice(index, 1);
                el.removeChild(tag.element);
                refreshTags();
            }

            function refreshTags() {
                let tagsList = [];
                tags.forEach(function (t) {
                    tagsList.push(t.text);
                });
                hiddenInput.value = tagsList.join(',');
            }

            function filterTag(tag) {
                return tag.replace(/[^\w -]/g, '').trim().replace(/\W+/g, '-');
            }
        });
        */

        this.on('mount', function () {
            //console.log('mount....');
            self.initSource();
        });
        /*
        this.on('update', function () {
            console.log('update....');
            self.initSource();
        });

        this.on('updated', function () {
            console.log('updated....');
            self.initSource();
        });
        */
    </script>
</votesummary-page>