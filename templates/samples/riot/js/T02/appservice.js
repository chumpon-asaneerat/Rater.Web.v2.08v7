class App {
    constructor() { 
        riot.observable(this);

        this._selectedLanguage = { "langId": "EN", "DescriptionNative": "English", "FlagIcon": "EN" };
        this._languages = this.getlanguages();
    }

    getlanguages() {
        return [
            { "langId": "EN", "DescriptionNative": "English", "FlagIcon": "EN" },
            { "langId": "TH", "DescriptionNative": "ไทย", "FlagIcon": "TH" }
        ];
    };
    
    getNavLinks(langId) {
        //console.log('Get Nav links for:', langId);
        if (langId === 'TH') {
            return [
                { "text": "ลงชื่อเข้าใช้งาน", "url": "#" },
                { "text": "ลงทะเบียน", "url": "#" }
            ];
        }
        else {
            return [
                { "text": "Sign In", "url": "#" },
                { "text": "Register", "url": "#" }
            ];
        }
    };

    changeLanguage(langId) {
        //console.log('change lang to:', langId);
        let match = null;
        let ids = this._languages.map((element) => { return element.langId });
        let index = ids.indexOf(langId);

        if (index === -1) {
            console.log('No language match langId:', langId);
            return;
        }
        else {
            this.selectedLanguage = this._languages[index];
        }
    };

    get selectedLanguage() {
        return this._selectedLanguage;
    }

    set selectedLanguage(value) {
        this._selectedLanguage = value;
        this.trigger('languagechanged');
    }

    get navLinks() {
        let results = this.getNavLinks(this._selectedLanguage.langId);
        return results
    }
}

; (function () {
    // set global app variable in window.
    window.app = window.app || new App();

    riot.compile(function () {
        var tags = riot.mount('*');
    });
})();