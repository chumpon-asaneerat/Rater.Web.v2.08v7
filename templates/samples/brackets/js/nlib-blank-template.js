/**
 * module: NLib NAME.
 * version: 1.0.7
 * required: none.
 */
;(function () {
    //---- Begin of Navigator Class.
    /**
     * Constructor.
     */
    function _NAMEClass() { };
    /**
     * function1.
     * 
     * @param {any} parma1 The parma1.
     */
    _NAMEClass.prototype.function1 = function(parma1) {
    };
    //---- End of Navigator Class.

    //------------------------------------------------------
    // [==== NLib Navigator register code add-in.      ====]
    //------------------------------------------------------
    var _parent = nlib;
    var _addin = null;
    var moduleName = 'NAME';

    // Register Code Add In.
    nlib.helpers.registerCodeAddIn(_parent, moduleName, function () {
        if (!_addin)
            _addin = new _NAMEClass();
        return _addin;
    });
})();