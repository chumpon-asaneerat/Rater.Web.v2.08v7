/*
 * ==============================================================================
 * 3rd parties code.
 * ==============================================================================
 */
/***************************************************************
 * JavaScript Cookie v2.1.3
 * https://github.com/js-cookie/js-cookie
 *
 * Copyright 2006, 2015 Klaus Hartl & Fagner Brack
 * Released under the MIT license
 ***************************************************************/
;(function (factory) {
    var registeredInModuleLoader = false;
    if (typeof define === 'function' && define.amd) {
        define(factory);
        registeredInModuleLoader = true;
    }
    if (typeof exports === 'object') {
        module.exports = factory();
        registeredInModuleLoader = true;
    }
    if (!registeredInModuleLoader) {
        var OldCookies = window.Cookies;
        var api = window.Cookies = factory();
        api.noConflict = function () {
            window.Cookies = OldCookies;
            return api;
        };
    }
}(function () {
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
    }

    function init(converter) {
        function api(key, value, attributes) {
            var result;
            if (typeof document === 'undefined') {
                return;
            }

            // Write

            if (arguments.length > 1) {
                attributes = extend({
                    path: '/'
                }, api.defaults, attributes);

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
                } catch (e) {}

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
                        } catch (e) {}
                    }

                    if (key === name) {
                        result = cookie;
                        break;
                    }

                    if (!key) {
                        result[name] = cookie;
                    }
                } catch (e) {}
            }

            return result;
        }

        api.set = api;
        api.get = function (key) {
            return api.call(api, key);
        };
        api.getJSON = function () {
            return api.apply({
                json: true
            }, [].slice.call(arguments));
        };
        api.defaults = {};

        api.remove = function (key, attributes) {
            api(key, '', extend(attributes, {
                expires: -1
            }));
        };

        api.withConverter = init;

        return api;
    }

    return init(function () {});
}));

/***************************************************************
 * simpleStorage.js (0.2.1) -> jsStorage
 ***************************************************************/
/* jshint browser: true */
/* global define: false, module: false */

// AMD shim
(function (root, factory) {

    'use strict';

    if (typeof define === 'function' && define.amd) {
        define(factory);
    } else if (typeof exports !== 'undefined') {
        module.exports = factory();
    } else {
        root.jsStorage = factory();
    }

}(this, function () {

    'use strict';

    var VERSION = '0.2.1';

    /* This is the object, that holds the cached values */
    var _storage = false;

    /* How much space does the storage take */
    var _storage_size = 0;

    var _storage_available = false;
    var _ttl_timeout = null;

    var _lsStatus = 'OK';
    var LS_NOT_AVAILABLE = 'LS_NOT_AVAILABLE';
    var LS_DISABLED = 'LS_DISABLED';
    var LS_QUOTA_EXCEEDED = 'LS_QUOTA_EXCEEDED';

    // This method might throw as it touches localStorage and doing so
    // can be prohibited in some environments
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

    function _loadStorage() {
        var source = localStorage.getItem('jsStorage');

        try {
            _storage = JSON.parse(source) || {};
        } catch (E) {
            _storage = {};
        }

        _storage_size = _get_storage_size();
    }

    function _save() {
        try {
            localStorage.setItem('jsStorage', JSON.stringify(_storage));
            _storage_size = _get_storage_size();
        } catch (E) {
            return _formatError(E);
        }
        return true;
    }

    function _get_storage_size() {
        var source = localStorage.getItem('jsStorage');
        return source ? String(source).length : 0;
    }

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
    }

    // Sets value for _lsStatus
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
    }

    ////////////////////////// PUBLIC INTERFACE /////////////////////////

    try {
        _init();
    } catch (E) {
        _checkError(E);
    }

    return {

        version: VERSION,

        status: _lsStatus,

        canUse: function () {
            return _lsStatus === 'OK' && !!_storage_available;
        },

        set: function (key, value, options) {
            if (key === '__jsStorage_meta') {
                return false;
            }

            if (!_storage) {
                return false;
            }

            // undefined values are deleted automatically
            if (typeof value === 'undefined') {
                return this.deleteKey(key);
            }

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
        },

        hasKey: function (key) {
            return !!this.get(key);
        },

        get: function (key) {
            if (!_storage) {
                return false;
            }

            if (_storage.hasOwnProperty(key) && key !== '__jsStorage_meta') {
                // TTL value for an existing key is either a positive number or an Infinity
                if (this.getTTL(key)) {
                    return _storage[key];
                }
            }
        },

        deleteKey: function (key) {

            if (!_storage) {
                return false;
            }

            if (key in _storage) {
                delete _storage[key];

                _setTTL(key, 0);

                return _save();
            }

            return false;
        },

        setTTL: function (key, ttl) {
            if (!_storage) {
                return false;
            }

            _setTTL(key, ttl);

            return _save();
        },

        getTTL: function (key) {
            var ttl;

            if (!_storage) {
                return false;
            }

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
        },

        flush: function () {
            if (!_storage) {
                return false;
            }

            _storage = {};
            try {
                localStorage.removeItem('jsStorage');
                return true;
            } catch (E) {
                return _formatError(E);
            }
        },

        index: function () {
            if (!_storage) {
                return false;
            }

            var index = [],
                i;
            for (i in _storage) {
                if (_storage.hasOwnProperty(i) && i !== '__jsStorage_meta') {
                    index.push(i);
                }
            }
            return index;
        },

        storageSize: function () {
            return _storage_size;
        }
    };
}));

/*
 * ==============================================================================
 * NLib Core. jquery required.
 * ==============================================================================
 */
nlib = function() {
    //-------------------------------------------------
    // [==== Helper class  ====]
    //-------------------------------------------------
    /**
     * Constructor.
     */
    function _helpersClass(nlib_instance) {
        //console.log('Helpers Class Ctor call.');
        this._nlib = nlib_instance;
        this.ModuleName = 'Helpers';
    };

    _helpersClass.prototype.registerCodeAddIn = function(instance, addInName, getMethod) {
        //console.log(this._nlib);
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

    //-------------------------------------------------
    // [==== NLib class  ====]
    //-------------------------------------------------
    var _instance = null; // for singelton.

    var _helpers = null;

    function _ctor() {
        //console.log('NLib Class Ctor call.');
        // class definition
        var obj = {};
        // helpers
        Object.defineProperty(obj, 'helpers', {
            get: function() {
                if (!_helpers)
                    _helpers = new _helpersClass(obj);
                return _helpers;
            }
        });
        // returns created object.
        return obj;
    };

    function _getInstance() {
        if (!_instance)
            _instance = _ctor(); // Again no new keyword;
        return _instance;
    }

    return { getInstance: _getInstance }; // return private function to execute immediately.
}().getInstance();

/*
 * ==============================================================================
 * NLib Utils. nothing required.
 * ==============================================================================
 */
;(function() {
    //console.log('NLib Utils loading.');

    //-------------------------------------------------
    // [==== Utils class  ====]
    //-------------------------------------------------
    /**
     * Constructor.
     */
    function _utilsClass() {
        //console.log('Utils Class Ctor call.');
    };
    /**
     * Checks is valid email address text.
     */
    _utilsClass.prototype.isValidEmail = function(value) {
        if (value === null || value === 'undefined' || typeof value === 'undefined')
            return false;
        var r = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
        return (value.match(r) == null) ? false : true;
    };
    /**
     * Checks is object is null or undefined.
     */
    _utilsClass.prototype.isNull = function(value) {
        return (value === null || value === 'undefined' || typeof value === 'undefined');
    };
    /**
     * get expired date from current date by specificed expired day(s).
     * if nothing assigned 1 day returns.
     */
    _utilsClass.prototype.getExpiredDate = function(expiredDays) {
        var date = new Date();
        
        var day = expiredDays;
        if (expiredDays === null || expiredDays === 'undefined' || typeof expiredDays === 'undefined')
            day = 1;

        if (day < 1) day = 1;
        var seconds = 60 * 60 * 24 * day;

        date.setTime(date.getTime() + (seconds * 1000));
        return date;
    };
    /**
     * Checks is specificed string has white space.
     */
    _utilsClass.prototype.hasWhiteSpace = function(value) {
        if (value === null || value === 'undefined' || typeof value === 'undefined')
            return false;
        return value.indexOf(' ') >= 0;
    };

    var _parent = nlib;
    var _addin = null;
    var moduleName = 'utils';

    // Register Code Add In.
    nlib.helpers.registerCodeAddIn(_parent, moduleName, function() {
        if (!_addin)
            _addin = new _utilsClass();
        return _addin;
    });

    //console.log('NLib Utils loaded.');
}());
/*
 * ==============================================================================
 * NLib Ajax. jquery required.
 * ==============================================================================
 */
;(function() {
    //console.log('NLib Ajax loading.');
    //-------------------------------------------------
    // [==== Ajax class  ====]
    //-------------------------------------------------
    /**
     * Constructor.
     */
    function _ajaxClass() {
        //console.log('Ajax Class Ctor call.');
    };
    /**
     * call ajax to specificed url via HTTP get method.
     */
    _ajaxClass.prototype.get = function(url, data, done, error) {
        //console.log(url + ' is call.');
        // used success and error.
        /*
        $.ajax({
            'url': url,
            //'dataType': 'json',
            'success': function(result, status, xhr) {
                //console.log('success');
                //console.log(result);
                done(result);
            },
            'error': function(xhr, status, err) {
                //console.log('error');
                //console.erlogror(err);
                error(err);
            }
        });
        */
        // used done and failed.
        $.ajax({
            'type': 'GET',
            'url': url
            //'dataType': 'json'
        }).done(function(result, status, xhr) {
            //console.log('done');
            //console.log(result);
            done(result);
        }).fail(function(xhr, status, err) {
            //console.log('fail');
            //console.log(err);
            error(err);
        });
    };
    /**
     * call ajax (with json data) to specificed url via HTTP post method.
     */
    _ajaxClass.prototype.post = function(url, data, done, error) {
        //console.log(url + ' is call.');
        // used success and error.
        /*
        $.ajax({
            'type': 'POST',
            'dataType': 'json',
            'url': url,
            'data': data,
            'success': function(result, status, xhr) {
                //console.log('success');
                //console.log(result);
                done(result);
            },
            'error': function(xhr, status, err) {
                //console.log('error');
                //console.log(err);
                error(err);
            }
        });
        */
        // used done and failed.
        $.ajax({
            'type': 'POST',
            'dataType': 'json',
            'url': url,
            'data': data,
        }).done(function(result, status, xhr) {
            //console.log('done');
            //console.log(result);
            done(result);
        }).fail(function(xhr, status, err) {
            //console.log('fail');
            //console.log(err);
            error(err);
        });
    };
    /**
     * Create jQuery ajax object for HTTP get method.
     */
    _ajaxClass.prototype.createGetAjax = function(url, data) {
        return $.ajax({
            'type': 'GET',
            //'dataType': 'json',
            'url': url//,
            //'data': data,
        });
    };
    /**
     * Create jQuery ajax object for HTTP post method.
     */
    _ajaxClass.prototype.createPostAjax = function(url, data) {
        return $.ajax({
            'type': 'POST',
            'dataType': 'json',
            'url': url,
            'data': data,
        });
    };

    var _parent = nlib;
    var _addin = null;
    var moduleName = 'ajax';

    // Register Code Add In.
    nlib.helpers.registerCodeAddIn(_parent, moduleName, function() {
        if (!_addin)
            _addin = new _ajaxClass();
        return _addin;
    });
    //console.log('NLib Ajax loaded.');
}());
/*
 * ==============================================================================
 * NLib Navigator. nothing required.
 * ==============================================================================
 */
;(function() {
    //console.log('NLib Navigator loading.');
    //-------------------------------------------------
    // [==== Navigator class  ====]
    //-------------------------------------------------
    /**
     * Constructor.
     */
    function _navClass() {
        //console.log('Navigator Class Ctor call.');
    };
    /**
     * Goto specificed url.
     */
    _navClass.prototype.gotoUrl = function(url) {
        document.location.replace(url);
    };

    var _parent = nlib;
    var _addin = null;
    var moduleName = 'nav';

    // Register Code Add In.
    nlib.helpers.registerCodeAddIn(_parent, moduleName, function() {
        if (!_addin)
            _addin = new _navClass();
        return _addin;
    });
    //console.log('NLib Navigator loaded.');
}());
/*
 * ==============================================================================
 * NLib Css Inject. nothing required. (original vein.js 0.3 by Danny Povolotski)
 * ==============================================================================
 */
;(function() {
    //console.log('NLib Css Inject loading.');
    //-------------------------------------------------
    // [==== Css Inject class  ====]
    //-------------------------------------------------
    /**
     * Constructor.
     */
    function _cssInjectClass() {
        //console.log('Css Inject Class Ctor call.');
    };
    
    var extend = function(out) {
        out = out || {};
        for (var i = 1; i < arguments.length; i++) {
            if (!arguments[i])
                continue;
            for (var key in arguments[i]) {
                if (arguments[i].hasOwnProperty(key))
                    out[key] = arguments[i][key];
            }
        }
        return out;
    };

    var findOrDeleteBySelector = function (selector, stylesheet, css) {
        var matches = [],
                rulesDelete = [],
                rules = stylesheet[ document.all ? 'rules' : 'cssRules' ],
                selectorCompare = selector.replace(/\s/g, ''),
                ri, rl;

        // Since there could theoretically be multiple versions of the same rule,
        // we will first iterate
        for (ri = 0, rl = rules.length; ri < rl; ri++) {
            if ((rules[ri].selectorText === selector) || // regular style selector                
                (rules[ri].type === 4 && rules[ri].cssText.replace(/\s/g, '').substring(0, selectorCompare.length) === selectorCompare) // for media queries, remove spaces and see if the query matches
               ) {
                if (css === null) {
                    // If we set css to null, let's delete that ruleset altogether
                    rulesDelete.push(ri);
                } else {
                    // Otherwise - we push it into the matches array
                    matches.push(rules[ri]);
                }
            }
        }
        for (ri = 0, rl = rulesDelete.length; ri < rl; ri++) {
            stylesheet.deleteRule(rulesDelete[ri]);
        }
        return matches;
    };

    var cssToString = function (css) {
        var cssArray = [];
        for (var property in css) {
            if (css.hasOwnProperty(property)) {
                cssArray.push(property + ': ' + css[property] + ';');
            }
        }
        var cssText = cssArray.join('');
        return cssText;
    };
    
    // Get the stylesheet we use to inject stuff or create it if it doesn't exist yet
    var getStylesheet = function () {
        var self = this;
        if (!self.element || !document.getElementById('nlib-inject')) {
            self.element = document.createElement("style");
            self.element.setAttribute('type', 'text/css');
            self.element.setAttribute('id', 'nlib-inject');
            document.getElementsByTagName("head")[0].appendChild(self.element);
            self.stylesheet = self.element.sheet;
        }
        return self.stylesheet;
    };

    var getRulesFromStylesheet = function (stylesheet) {
        return stylesheet[document.all ? 'rules' : 'cssRules'];
    };
    
    var insertRule = function (selector, cssText, stylesheet) {
        var rules = getRulesFromStylesheet(stylesheet);
        if (stylesheet.insertRule) {
            // Supported by all modern browsers
            stylesheet.insertRule(selector + '{' + cssText + '}', rules.length);
        } else {
            // Old IE compatability
            stylesheet.addRule(selector, cssText, rules.length);
        }
    };
    
    _cssInjectClass.prototype.inject = function(selectors, css, options) {
        options = extend({}, options);
        var self = this;
        var stylesheet = options.stylesheet || getStylesheet();
        /* rules = getRulesFromStylesheet(stylesheet), */
        var si, sl, query, matches, cssText, property, mi, ml, qi, ql;
        if (typeof selectors === 'string') {
            selectors = [selectors];
        }
        for (si = 0, sl = selectors.length; si < sl; si++) {
            if (typeof selectors[si] === 'object' && stylesheet.insertRule) {
                for (query in selectors[si]) {
                    matches = findOrDeleteBySelector(query, stylesheet, css);
                    if (matches.length === 0) {
                        cssText = cssToString(css);
                        for (qi = 0, ql = selectors[si][query].length; qi < ql; qi++) {
                            insertRule(query, selectors[si][query][qi] + '{' + cssText + '}', stylesheet);
                        }
                    } else {
                        for (mi = 0, ml = matches.length; mi < ml; mi++) {
                            self.inject(selectors[si][query], css, {stylesheet: matches[mi]});
                        }
                    }
                }
            } else {
                matches = findOrDeleteBySelector(selectors[si], stylesheet, css);
                // If all we wanted is to delete that ruleset, we're done here
                if (css === null)
                    return;
                // If no rulesets have been found for the selector, we will create it below
                if (matches.length === 0) {
                    cssText = cssToString(css);
                    insertRule(selectors[si], cssText, stylesheet);
                }
                // Otherwise, we're just going to modify the property
                else {
                    for (mi = 0, ml = matches.length; mi < ml; mi++) {
                        for (property in css) {
                            if (css.hasOwnProperty(property)) {
                                // TODO: Implement priority
                                if (matches[mi].style.setProperty) {
                                    matches[mi].style.setProperty(property, css[property], '');
                                } else {
                                    //IE8
                                    matches[mi].style.setAttribute(property, css[property], '');
                                }
                            }
                        }
                    }
                }
            }
        }
        return self;
    };

    var _parent = nlib;
    var _addin = null;
    var moduleName = 'css';

    // Register Code Add In.
    nlib.helpers.registerCodeAddIn(_parent, moduleName, function() {
        if (!_addin)
            _addin = new _cssInjectClass();
        return _addin;
    });
    //console.log('NLib Css Inject loaded.');
}());
