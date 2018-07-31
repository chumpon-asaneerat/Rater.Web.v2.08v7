<master>
    <div class="container-fluid">
        <h1>{ app.title }</h1>
        <p>Please use console and enter code below</p>
        <p>1. <span class="code">app.title = 'the new title'</span></p>
        <p>2. <span class="code">riot.update('*')</span></p>
    </div>
    <div class="container-fluid">
        <p>Or Used Handler.</p>
        <button onclick="{addhandler}">Add Handler</button>
        <button onclick="{removehandler}">Remove Handler</button>
        <button onclick="app.generateTitle();">Generate</button>
    </div>
    <div class="container-fluid">
        <p>Current Language: { (app.languages.selectedObject) ? app.languages.selectedObject.DescriptionNative : 'none' }</p>
        <div if={ app.languages.selectedObject !== null }>
            <select onchange={changeLanguage}>
                <option each={lang in app.languages.datasource} value={lang.langId}
                    selected={app.languages.selectedObject.langId === lang.langId}>
                    {lang.DescriptionNative}
                </option>
            </select>
        </div>
    </div>
    <style>
        .code {
            background: #CCCCCC;
            border: solid 1px #888888;
            border-radius: 5px 5px;
            margin: 0 auto;
            padding: 0px 5px 2px 5px;
        }
    </style>
    <script>
        var self = this;

        this.onpropertychanged = (sender, e) => {
            if (e.name === 'title') {
                // refresh all
                self.update();
            }
        };

        this.languages_changed = (sender, e) => {

        };

        this.selected_language_schanged = (sender, e) => {
            self.update();
        };

        this.addhandler = (e) => {
            e.preventDefault();
            app.propertychanged.add(this.onpropertychanged);
        };

        this.removehandler = (e) => {
            e.preventDefault();
            app.propertychanged.remove(this.onpropertychanged);
        };

        this.changeLanguage = (e) => {
            e.preventDefault();
            let langId = e.target.value;
            app.languages.changeLanguage(langId);
        };

        // add handlers
        app.languages.datasourcechanged.add(this.languages_changed);
        app.languages.selectedindexchanged.add(this.selected_language_schanged);
        
    </script>
</master>