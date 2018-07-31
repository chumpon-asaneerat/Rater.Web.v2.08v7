/**
 * module: NLib Core.
 * version: 1.0.7
 * required: none.
 */
nlib = function () {
    //---- Begin of Helper Class.
    /**
     * Constructor.
     * 
     * @param {any} nlib_instance The instance of nlib.
     */
    function _helpersClass(nlib_instance) {
        this._nlib = nlib_instance;
        this.ModuleName = 'Helpers';
    }
    /**
     * Register code add-in.
     * 
     * @param {any} instance
     * @param {string} addInName
     * @param {method} getMethod
     */
    _helpersClass.prototype.registerCodeAddIn = function (instance, addInName, getMethod) {
        if (!instance) {
            console.log('instance is null.');
            return;
        }
        //console.log("Module Name: " + addInName);
        Object.defineProperty(instance, addInName, {
            configurable: true,
            get: getMethod
        });
    };
    //---- End of Helper Class.

    //------------------------------------------------------
    // [==== NLib Helper register code add-in.         ====]
    //------------------------------------------------------
    var _instance = null; // for singelton instance.
    var _helpers = null; // for helper instance.

    /**
     * Constructor.
     */
    function _ctor() {
        // class definition
        var obj = {};
        // define helpers
        Object.defineProperty(obj, 'helpers', {
            get: function () {
                if (!_helpers)
                    _helpers = new _helpersClass(obj);
                return _helpers;
            }
        });
        // returns created instance.
        return obj;
    };
    /**
     * Gets Instance.
     * 
     * @returns {any} new instance if no exists instance otherwise returns exists instance.
     */
    function _getInstance() {
        if (!_instance)
            _instance = _ctor(); // Again no new keyword;
        return _instance;
    };

    // return new object that contains getInsance method to execute immediately.    
    return {
        getInstance: _getInstance
    };
}().getInstance();

/**
 * module: NLib Utils.
 * version  1.0.7
 * required: none.
 */
;(function () {
    //---- Begin of Utils Class.
    /**
     * Constructor.
     */
    function _utilsClass() { };
    /**
     * Checks is object is null or undefined.
     *
     * @param {any} value The object to checks is null or undefined.
     * @returns {boolean} Returns true if value is null otherwist returns false.
     */
    _utilsClass.prototype.isNull = function (value) {
        //return (value === null || value === 'undefined' || typeof value === 'undefined');
        return (!value || value === 'undefined');
    };
    /**
     * Checks is valid email address text.
     * 
     * @param {string} value The object to checks is null or undefined.
     * @returns {boolean} Returns true if value is valid email format otherwist returns false.
     */
    _utilsClass.prototype.isValidEmail = function (value) {
        if (!value || value === 'undefined')
            return false;
        var r = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
        return (value.match(r) == null) ? false : true;
    };
    /**
     * Checks is specificed string has white space.
     *
     * @param {string} value The object to checks is null or undefined.
     * @returns {boolean} Returns true if value is contains one or more whitespace otherwise returns false.
     */
    _utilsClass.prototype.hasWhiteSpace = function (value) {
        if (value === null || value === 'undefined' || typeof value === 'undefined')
            return false;
        return value.indexOf(' ') >= 0;
    };
    /**
     * get expired date from current date by specificed expired day(s).
     * if nothing assigned 1 day returns.
     * 
     * @param {Number} value The number of expires days start from today.
     * @returns {Date} Returns expired date. If no expiredDays assigned. one day will used.
     */
    _utilsClass.prototype.getExpiredDate = function (expiredDays) {
        var date = new Date();

        var day = expiredDays;
        if (expiredDays === null || expiredDays === 'undefined' || typeof expiredDays === 'undefined')
            day = 1;

        if (day < 1) day = 1;
        var seconds = 60 * 60 * 24 * day;

        date.setTime(date.getTime() + (seconds * 1000));
        return date;
    };
    //---- End of Utils Class.

    //------------------------------------------------------
    // [==== NLib Utils register code add-in.          ====]
    //------------------------------------------------------
    var _parent = nlib;
    var _addin = null;
    var moduleName = 'utils';

    /**
     * Register Code Add In.
     */
    nlib.helpers.registerCodeAddIn(_parent, moduleName, function () {
        if (!_addin)
            _addin = new _utilsClass();
        return _addin;
    });
})();

/**
 * module: NLib Navigator.
 * version: 1.0.7
 * required: none.
 */
;(function() {
    //---- Begin of Navigator Class.
    /**
     * Constructor.
     */
    function _navClass() { };
    /**
     * Goto specificed url with supports assigned query string object.
     * 
     * @param {string} url The url to navigate.
     * @param {any} queryObject The object that all properties used as query string.
     */
    _navClass.prototype.gotoUrl = function (url, queryObject) {
        var queryString = this.getQueryString(queryObject);
        console.log(queryString);
        var newUrl = url + queryString;
        console.log(newUrl);
        
        document.location.replace(newUrl);
    };
    /**
     * Refresh url (force reload).
     */
    _navClass.prototype.refresh = function () {
        document.location.reload(true)
    };
    /**
     * Gets Query string for specificed query object.
     * @param {any} queryObject The object that all properties used as query string.
     */
    _navClass.prototype.getQueryString = function (queryObject) {
        var queryString = '';
        if (queryObject && Object.keys(queryObject).length > 0) {
            queryString = queryString + '?';
            var key;
            var prefix = '';
            for (key in queryObject) {
                if (!queryObject.hasOwnProperty(key))
                    continue;
                var paramStr = key.toString() + '=' + queryObject[key].toString();
                //console.log(paramStr);
                queryString = queryString + prefix + paramStr;
                if (prefix === '') prefix = '&';
            }
        }
        return queryString;
    };
    /**
     * Clear query string from url. (call when page loaded).
     */
    _navClass.prototype.clearQueryString = function() {
        var href = window.location.href;
        var newUrl = href.substring(0, href.indexOf('?'));
        console.log(href);
        console.log(newUrl);
        window.history.replaceState({}, document.title, newUrl);
    };
    //---- End of Navigator Class.

    //------------------------------------------------------
    // [==== NLib Navigator register code add-in.      ====]
    //------------------------------------------------------
    var _parent = nlib;
    var _addin = null;
    var moduleName = 'nav';

    // Register Code Add In.
    nlib.helpers.registerCodeAddIn(_parent, moduleName, function () {
        if (!_addin)
            _addin = new _navClass();
        return _addin;
    });
})();

/**
 * module: NLib Cookies.
 * version: 1.0.7
 * required: none.
 * Source: JavaScript Cookie v2.1.3 from https://github.com/js-cookie/js-cookie
 * Copyright 2006, 2015 Klaus Hartl & Fagner Brack.
 * Released under the MIT license.
 */
;(function () {
    //---- Begin local methods.
    /**
     * converter function.
     */
    function converter() { }
    /**
     * extended function.
     */
    function extend() {
        var i = 0;
        var result = {};
        for (; i < arguments.length; i++) {
            var attributes = arguments[i];
            for (var key in attributes) {
                result[key] = attributes[key];
            }
        }
        return result;
    };
    /**
     * api function.
     */
    function api(key, value, attributes) {
        var result;
        if (typeof document === 'undefined') {
            return;
        }
        // Write
        if (arguments.length > 1) {
            attributes = extend({ path: '/' }, this.defaults, attributes);

            if (typeof attributes.expires === 'number') {
                var expires = new Date();
                expires.setMilliseconds(expires.getMilliseconds() + attributes.expires * 864e+5);
                attributes.expires = expires;
            }

            try {
                result = JSON.stringify(value);
                if (/^[\{\[]/.test(result)) {
                    value = result;
                }
            } catch (e) { }

            if (!converter.write) {
                value = encodeURIComponent(String(value))
                    .replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeURIComponent);
            } else {
                value = converter.write(value, key);
            }

            key = encodeURIComponent(String(key));
            key = key.replace(/%(23|24|26|2B|5E|60|7C)/g, decodeURIComponent);
            key = key.replace(/[\(\)]/g, escape);

            return (document.cookie = [
                key, '=', value,
                attributes.expires ? '; expires=' + attributes.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                attributes.path ? '; path=' + attributes.path : '',
                attributes.domain ? '; domain=' + attributes.domain : '',
                attributes.secure ? '; secure' : ''
            ].join(''));
        }

        // Read
        if (!key) {
            result = {};
        }

        // To prevent the for loop in the first place assign an empty array
        // in case there are no cookies at all. Also prevents odd result when
        // calling "get()"
        var cookies = document.cookie ? document.cookie.split('; ') : [];
        var rdecode = /(%[0-9A-Z]{2})+/g;
        var i = 0;

        for (; i < cookies.length; i++) {
            var parts = cookies[i].split('=');
            var cookie = parts.slice(1).join('=');

            if (cookie.charAt(0) === '"') {
                cookie = cookie.slice(1, -1);
            }

            try {
                var name = parts[0].replace(rdecode, decodeURIComponent);
                cookie = converter.read ?
                    converter.read(cookie, name) : converter(cookie, name) ||
                    cookie.replace(rdecode, decodeURIComponent);

                if (this.json) {
                    try {
                        cookie = JSON.parse(cookie);
                    } catch (e) { }
                }

                if (key === name) {
                    result = cookie;
                    break;
                }

                if (!key) {
                    result[name] = cookie;
                }
            } catch (e) { }
        }

        return result;
    };
    //---- End local methods.
    
    //---- Begin of Cookies Class.
    /**
     * Constructor.
     */
    function _cookiesClass() { 
        this.defaults = {};
    };
    /**
     * Set Cookies value by key with attributes.
     */
    _cookiesClass.prototype.set = function (key, value, attributes) {
        return api(key, value, attributes);
    };
    /**
     * Gets cookies value and attributes by key.
     */
    _cookiesClass.prototype.get = function (key) {
        return api(key);
    };
    /**
     * Remove cookies by key.
     */
    _cookiesClass.prototype.remove = function (key, attributes) {
        api(key, '', extend(attributes, { expires: -1 }));
    };
    /**
     * Gets cookies value and attributes by key in json format.
     */
    _cookiesClass.prototype.getJSON = function () {
        return api.apply({ json: true }, [].slice.call(arguments));
    };

    // Run Test.
    /*     
    _cookiesClass.prototype.runTest = function() {
        console.log('Test Cookies.');
        console.log('Remove Cookies.');
        cookie1 = this.remove('key1');
        cookie1 = this.remove('key2');
        cookie1 = this.remove('key3');
        var cookie1;
        cookie1 = this.get('key1');
        console.log('Read Cookies value : ', cookie1);
        this.set('key1', 'joe1', { expires: 1 });
        this.set('key2', 'joe2', { expires: 1 });
        this.set('key3', 'joe3', { expires: 1 });
        console.log('Test Write Cookies.');
        cookie1 = this.get('key1');
        console.log('Read Cookies value : ', cookie1);
        var json_cookies1 = this.getJSON();
        console.log('Read Cookies in json : ', json_cookies1);
    };
    */
    //---- End of Cookies Class.

    //------------------------------------------------------
    // [==== NLib Cookies register code add-in.        ====]
    //------------------------------------------------------
    var _parent = nlib;
    var _addin = null;
    var moduleName = 'cookies';

    // Register Code Add In.
    nlib.helpers.registerCodeAddIn(_parent, moduleName, function () {
        if (!_addin)
            _addin = new _cookiesClass();
        return _addin;
    });
})();

/**
 * module: NLib (local)Storage.
 * version: 1.0.7
 * required: none.
 * Source: simpleStorage.js (0.2.1) from https://github.com/ZaDarkSide/simpleStorage
 */
;(function() {
    //---- Begin local methods.
    var VERSION = '0.2.1';
    /* This is the object, that holds the cached values */
    var _storage = false;
    /* How much space does the storage take */
    var _storage_size = 0;

    var _storage_available = false;
    var _ttl_timeout = null;
    /* Status */
    var _lsStatus = 'OK';
    /* Error Code */
    var LS_NOT_AVAILABLE = 'LS_NOT_AVAILABLE';
    var LS_DISABLED = 'LS_DISABLED';
    var LS_QUOTA_EXCEEDED = 'LS_QUOTA_EXCEEDED';
    /**
     * This method might throw as it touches localStorage and doing so
     * can be prohibited in some environments
     */
    function _init() {
        // this method throws if localStorage is not usable, otherwise returns true
        _storage_available = _checkAvailability();
        // Load data from storage
        _loadStorage();
        // remove dead keys
        _handleTTL();
        // start listening for changes
        _setupUpdateObserver();
        // handle cached navigation
        if ('addEventListener' in window) {
            window.addEventListener('pageshow', function (event) {
                if (event.persisted) {
                    _reloadData();
                }
            }, false);
        }
        _storage_available = true;
    }
    /**
     * Sets up a storage change observer
     */
    function _setupUpdateObserver() {
        if ('addEventListener' in window) {
            window.addEventListener('storage', _reloadData, false);
        } else {
            document.attachEvent('onstorage', _reloadData);
        }
    }
    /**
     * Reload data from storage when needed
     */
    function _reloadData() {
        try {
            _loadStorage();
        } catch (E) {
            _storage_available = false;
            return;
        }
        _handleTTL();
    }
    /**
     * Load.
     */
    function _loadStorage() {
        var source = localStorage.getItem('jsStorage');

        try {
            _storage = JSON.parse(source) || {};
        } catch (E) {
            _storage = {};
        }

        _storage_size = _get_storage_size();
    }
    /**
     * Save.
     */
    function _save() {
        try {
            localStorage.setItem('jsStorage', JSON.stringify(_storage));
            _storage_size = _get_storage_size();
        } catch (E) {
            return _formatError(E);
        }
        return true;
    }
    /**
     * Gets Storage Size.
     */
    function _get_storage_size() {
        var source = localStorage.getItem('jsStorage');
        return source ? String(source).length : 0;
    }
    /**
     * Handle TTL.
     */
    function _handleTTL() {
        var curtime, i, len, expire, keys, nextExpire = Infinity,
            expiredKeysCount = 0;

        clearTimeout(_ttl_timeout);

        if (!_storage || !_storage.__jsStorage_meta || !_storage.__jsStorage_meta.TTL) {
            return;
        }

        curtime = +new Date();
        keys = _storage.__jsStorage_meta.TTL.keys || [];
        expire = _storage.__jsStorage_meta.TTL.expire || {};

        for (i = 0, len = keys.length; i < len; i++) {
            if (expire[keys[i]] <= curtime) {
                expiredKeysCount++;
                delete _storage[keys[i]];
                delete expire[keys[i]];
            } else {
                if (expire[keys[i]] < nextExpire) {
                    nextExpire = expire[keys[i]];
                }
                break;
            }
        }

        // set next check
        if (nextExpire !== Infinity) {
            _ttl_timeout = setTimeout(_handleTTL, Math.min(nextExpire - curtime, 0x7FFFFFFF));
        }

        // remove expired from TTL list and save changes
        if (expiredKeysCount) {
            keys.splice(0, expiredKeysCount);

            _cleanMetaObject();
            _save();
        }
    }
    /**
     * Set TTL.
     */
    function _setTTL(key, ttl) {
        var curtime = +new Date(),
            i, len, added = false;

        ttl = Number(ttl) || 0;

        // Set TTL value for the key
        if (ttl !== 0) {
            // If key exists, set TTL
            if (_storage.hasOwnProperty(key)) {

                if (!_storage.__jsStorage_meta) {
                    _storage.__jsStorage_meta = {};
                }

                if (!_storage.__jsStorage_meta.TTL) {
                    _storage.__jsStorage_meta.TTL = {
                        expire: {},
                        keys: []
                    };
                }

                _storage.__jsStorage_meta.TTL.expire[key] = curtime + ttl;

                // find the expiring key in the array and remove it and all before it (because of sort)
                if (_storage.__jsStorage_meta.TTL.expire.hasOwnProperty(key)) {
                    for (i = 0, len = _storage.__jsStorage_meta.TTL.keys.length; i < len; i++) {
                        if (_storage.__jsStorage_meta.TTL.keys[i] === key) {
                            _storage.__jsStorage_meta.TTL.keys.splice(i);
                        }
                    }
                }

                // add key to keys array preserving sort (soonest first)
                for (i = 0, len = _storage.__jsStorage_meta.TTL.keys.length; i < len; i++) {
                    if (_storage.__jsStorage_meta.TTL.expire[_storage.__jsStorage_meta.TTL.keys[i]] > (curtime + ttl)) {
                        _storage.__jsStorage_meta.TTL.keys.splice(i, 0, key);
                        added = true;
                        break;
                    }
                }

                // if not added in previous loop, add here
                if (!added) {
                    _storage.__jsStorage_meta.TTL.keys.push(key);
                }
            } else {
                return false;
            }
        } else {
            // Remove TTL if set
            if (_storage && _storage.__jsStorage_meta && _storage.__jsStorage_meta.TTL) {

                if (_storage.__jsStorage_meta.TTL.expire.hasOwnProperty(key)) {
                    delete _storage.__jsStorage_meta.TTL.expire[key];
                    for (i = 0, len = _storage.__jsStorage_meta.TTL.keys.length; i < len; i++) {
                        if (_storage.__jsStorage_meta.TTL.keys[i] === key) {
                            _storage.__jsStorage_meta.TTL.keys.splice(i, 1);
                            break;
                        }
                    }
                }

                _cleanMetaObject();
            }
        }
        // schedule next TTL check
        clearTimeout(_ttl_timeout);
        if (_storage && _storage.__jsStorage_meta && _storage.__jsStorage_meta.TTL && _storage.__jsStorage_meta.TTL.keys.length) {
            _ttl_timeout = setTimeout(_handleTTL, Math.min(Math.max(_storage.__jsStorage_meta.TTL.expire[_storage.__jsStorage_meta.TTL.keys[0]] - curtime, 0), 0x7FFFFFFF));
        }

        return true;
    }
    /**
     * Clear Meta Object.
     */
    function _cleanMetaObject() {
        var updated = false,
            hasProperties = false,
            i;

        if (!_storage || !_storage.__jsStorage_meta) {
            return updated;
        }

        // If nothing to TTL, remove the object
        if (_storage.__jsStorage_meta.TTL && !_storage.__jsStorage_meta.TTL.keys.length) {
            delete _storage.__jsStorage_meta.TTL;
            updated = true;
        }

        // If meta object is empty, remove it
        for (i in _storage.__jsStorage_meta) {
            if (_storage.__jsStorage_meta.hasOwnProperty(i)) {
                hasProperties = true;
                break;
            }
        }

        if (!hasProperties) {
            delete _storage.__jsStorage_meta;
            updated = true;
        }

        return updated;
    }
    /**
     * Checks if localStorage is available or throws an error
     */
    function _checkAvailability() {
        var err;
        var items = 0;

        // Firefox sets localStorage to 'null' if support is disabled
        // IE might go crazy if quota is exceeded and start treating it as 'unknown'
        if (window.localStorage === null || typeof window.localStorage === 'unknown') {
            err = new Error('localStorage is disabled');
            err.code = LS_DISABLED;
            throw err;
        }

        // There doesn't seem to be any indication about localStorage support
        if (!window.localStorage) {
            err = new Error('localStorage not supported');
            err.code = LS_NOT_AVAILABLE;
            throw err;
        }

        try {
            items = window.localStorage.length;
        } catch (E) {
            throw _formatError(E);
        }

        try {
            // we try to set a value to see if localStorage is really usable or not
            window.localStorage.setItem('__jsStorageInitTest', (+new Date).toString(16));
            window.localStorage.removeItem('__jsStorageInitTest');
        } catch (E) {
            if (items) {
                // there is already some data stored, so this might mean that storage is full
                throw _formatError(E);
            } else {
                // we do not have any data stored and we can't add anything new
                // so we are most probably in Private Browsing mode where
                // localStorage is turned off in some browsers (max storage size is 0)
                err = new Error('localStorage is disabled');
                err.code = LS_DISABLED;
                throw err;
            }
        }

        return true;
    }
    /**
     * Format Error.
     */
    function _formatError(E) {
        var err;
        // No more storage:
        // Mozilla: NS_ERROR_DOM_QUOTA_REACHED, code 1014
        // WebKit: QuotaExceededError/QUOTA_EXCEEDED_ERR, code 22
        // IE number -2146828281: Out of memory
        // IE number -2147024882: Not enough storage is available to complete this operation
        if (E.code === 22 || E.code === 1014 || [-2147024882, -2146828281, -21474675259].indexOf(E.number) > 0) {
            err = new Error('localStorage quota exceeded');
            err.code = LS_QUOTA_EXCEEDED;
            return err;
        }

        // SecurityError, localStorage is turned off
        if (E.code === 18 || E.code === 1000) {
            err = new Error('localStorage is disabled');
            err.code = LS_DISABLED;
            return err;
        }

        // We are trying to access something from an object that is either null or undefined
        if (E.name === 'TypeError') {
            err = new Error('localStorage is disabled');
            err.code = LS_DISABLED;
            return err;
        }

        return E;
    };
    /**
     * Sets value for _lsStatus
     */
    function _checkError(err) {
        if (!err) {
            _lsStatus = 'OK';
            return err;
        }

        switch (err.code) {
            case LS_NOT_AVAILABLE:
            case LS_DISABLED:
            case LS_QUOTA_EXCEEDED:
                _lsStatus = err.code;
                break;
            default:
                _lsStatus = err.code || err.number || err.message || err.name;
        }

        return err;
    };    
    //---- End local methods.
    
    //---- Begin of Local Storage Class.
    /**
     * Constructor.
     */
    function _localStorageClass() {
        this.version = VERSION;
        this.status = _lsStatus;
    };
    /**
     * Checks can use local storage.
     */
    _localStorageClass.prototype.canUse = function () {
        return _lsStatus === 'OK' && !!_storage_available;
    };
    /**
     * Sets Value to specificed key.
     */
    _localStorageClass.prototype.set = function (key, value, options) {
        if (key === '__jsStorage_meta')
            return false;
        if (!_storage)
            return false;
        // undefined values are deleted automatically
        if (typeof value === 'undefined')
            return this.deleteKey(key);

        options = options || {};
        // Check if the value is JSON compatible (and remove reference to existing objects/arrays)
        try {
            value = JSON.parse(JSON.stringify(value));
        } catch (E) {
            return _formatError(E);
        }

        _storage[key] = value;
        _setTTL(key, options.TTL || 0);
        return _save();
    };
    /**
     * Checks specificed key is exists.
     */
    _localStorageClass.prototype.hasKey = function (key) {
        return !!this.get(key);
    };
    /**
     * Gets Value by specificed key.
     */
    _localStorageClass.prototype.get = function (key) {
        if (!_storage)
            return false;

        if (_storage.hasOwnProperty(key) && key !== '__jsStorage_meta') {
            // TTL value for an existing key is either a positive number or an Infinity
            if (this.getTTL(key)) {
                return _storage[key];
            }
        }
    };
    /**
     * Delete key.
     */
    _localStorageClass.prototype.deleteKey = function (key) {
        if (!_storage)
            return false;

        if (key in _storage) {
            // delete from array.
            delete _storage[key];
            // update TTL to 0.
            _setTTL(key, 0);
            // Save to storage.
            return _save();
        }

        return false;
    };
    /**
     * Sets TTL value to specificed key.
     */
    _localStorageClass.prototype.setTTL = function (key, ttl) {
        if (!_storage)
            return false;

        _setTTL(key, ttl);

        return _save();
    };
    /**
     * Gets TTL value from specificed key.
     */
    _localStorageClass.prototype.getTTL = function (key) {
        var ttl;
        if (!_storage)
            return false;

        if (_storage.hasOwnProperty(key)) {
            if (_storage.__jsStorage_meta &&
                _storage.__jsStorage_meta.TTL &&
                _storage.__jsStorage_meta.TTL.expire &&
                _storage.__jsStorage_meta.TTL.expire.hasOwnProperty(key)) {

                ttl = Math.max(_storage.__jsStorage_meta.TTL.expire[key] - (+new Date()) || 0, 0);

                return ttl || false;
            } else {
                return Infinity;
            }
        }

        return false;
    };
    /**
     * Flush all data.
     */
    _localStorageClass.prototype.flush = function () {
        if (!_storage)
            return false;

        _storage = {};
        try {
            localStorage.removeItem('jsStorage');
            return true;
        } catch (E) {
            return _formatError(E);
        }
    };
    /**
     * Retrieve all used keys as an array.
     */
    _localStorageClass.prototype.index = function () {
        if (!_storage)
            return false;

        var index = [], i;
        for (i in _storage) {
            if (_storage.hasOwnProperty(i) && i !== '__jsStorage_meta') {
                index.push(i);
            }
        }
        return index;
    };
    /**
     * Gets storage size.
     */
    _localStorageClass.prototype.storageSize = function () {
        return _storage_size;
    };

    // Run Test.
    _localStorageClass.prototype.runTest = function () {
        console.log('Supports Local Storage: ', nlib.storage.canUse());
        console.log('Set key1 to joe1');
        nlib.storage.set('key1', 'joe1', { TTL: 100000 });
        nlib.storage.set('key2', 'joe2', { TTL: 100000 });
        nlib.storage.set('key3', 'joe3', { TTL: 100000 });
        console.log('Has key1: ', nlib.storage.hasKey('key1'))
        var data1 = nlib.storage.get('key1')
        console.log('Data for key1: ', data1);
        var keys = nlib.storage.index();
        console.log('All index: ', keys);
    };

    //---- End of Local Storage Class.

    //------------------------------------------------------
    // [==== NLib Local Storage register code add-in.  ====]
    //------------------------------------------------------
    var _parent = nlib;
    var _addin = null;
    var moduleName = 'storage';

    // Register Code Add In.
    nlib.helpers.registerCodeAddIn(_parent, moduleName, function () {
        if (!_addin) {
            try {
                _init();
            } catch (E) {
                _checkError(E);
            }            
            _addin = new _localStorageClass();
        }
        return _addin;
    });
})();
