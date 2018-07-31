//#region API Class
class API {
    /* common ajax related functions. */
    static get ajax() {
        return {
            get(url, data) {
                return $.ajax({ type: 'GET', dataType: 'json', url: url, data: data })
            },
            post(url, data) {
                return $.ajax({ type: 'POST', dataType: 'json', url: url, data: data })
            }
        }
    }

    static getUrl(relUrl) {
        let result = window.location.pathname;
        if (!result.endsWith('/')) {
            if (!relUrl.startsWith('/')) {
                result = result + '/' + relUrl;
            }
            else {
                result = result + relUrl;
            }
        }
        else {
            if (!relUrl.startsWith('/')) {
                result = result + relUrl;
            }
            else {
                result = result + relUrl.substring(1);
            }
        }
        //console.log(window.location);
        return result;
    };

    constructor() {
        let self = this;
        if (this.functions && this.functions.length > 0) {
            this.functions.forEach(fn => {
                self.__proto__[fn.name] = function (data) { return API.ajax.post(fn.url, data) };
            });
        }
    };

    get functions() { return [] };
};

; (function () {
    // Init the api namespace object.
    window.api = window.api || {};
})();

//#endregion

//#region Language API class

class LanguageAPI extends API
{
    constructor() { 
        super(); 
    };

    get functions() {
        return [
            // languages related functions.
            { name: "getLanguages", url: "/api/edl/languages/search" },
            { name: "enableLanguage", url: "/api/edl/languages/enable" },
            { name: "disableLanguage", url: "/api/edl/languages/disable" }
        ];
    };
};

; (function () {
    // Init in api namespace.
    window.api.lang = window.api.lang || new LanguageAPI();
})();

//#endregion

//#region Secure API class - move to register/signin app.js later

class SecureAPI extends API {
    constructor() { 
        super(); 
    };

    get functions() {
        return [
            // register/signin related functions.
            { name: "register", url: "/api/edl/register" },
            { name: "getUsers", url: "/api/edl/users" },
            { name: "signIn", url: "/api/edl/signin" },
            { name: "getCurrentUser", url: "/api/edl/user" },
            { name: "signOut", url: "/api/edl/signout" }
        ];
    };
};

;(function() {
    // Init in api namespace.
    window.api.secure = window.api.secure || new SecureAPI();

    // example.
    //api.secure.getUsers({ langId: 'EN', userName: 'somchai@yahoo.co.th', passWord: '1234' });
})();

//#endregion

//#region Model API class

class ModelAPI extends API {
    constructor() {
        super();
    };

    get functions() {
        return [
            // page content model.
            { name: "getModelNames", url: API.getUrl("modelnames") },
            { name: "getModel", url: API.getUrl("models") }
        ];
    };
};

; (function () {
    // Init in api namespace.
    window.api.model = window.api.model || new ModelAPI();
})();

//#endregion

; (function () {

})();
