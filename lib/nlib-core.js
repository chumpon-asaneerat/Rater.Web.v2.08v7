// Constants
const path = require('path');
const fs = require('fs');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

// ================================================================
// [==== NResult class ====]
// ================================================================
function NResult() {
    this.data = {};
    this.errors = {};
    this.errors.hasError = false;
    this.errors.exception = null;
    this.errors.errMsg = null;
};

/**
 * Set error message.
 */
NResult.prototype.error = function (errorMessage) {
    this.errors.hasError = true;
    this.errors.errMsg = errorMessage;
};
/**
 * Set error message and exception.
 */
NResult.prototype.error = function (errorMessage, exception) {
    this.errors.hasError = true;
    this.errors.exception = exception;
    this.errors.errMsg = errorMessage;
};
/**
 * Set data.
 */
NResult.prototype.result = function (data) {
    this.data = data;
    this.errors.hasError = false;
    this.errors.exception = null;
    this.errors.errNum = 0;
    this.errors.errMsg = '';
};

exports.NResult = module.exports.NResult = NResult;

// ================================================================
// [==== utilities functions ====]
// ================================================================
/**
 * Checks is null or undefined.
 */
function isNull(value) {
    if (!value || value === 'undefined')
        return true;
    else return false;
    /*
    if (typeof value === 'undefined' || value === null || value === 'undefined')
        return true;
    else return false;
    */
};

exports.isNull = module.exports.isNull = isNull;

// ================================================================
// [==== request/response related functions ====]
// ================================================================
/**
 * Parse request query string or request body into json object.
 */
function parseReq(req) {
    var result = new NResult();

    if (req.method === 'GET') {
        var len = 0;
        if (!isNull(Object.keys(req.query)))
            len = Object.keys(req.query).length;
        // Has Parameter(s)
        if (len > 0) {
            // Each parameter.
            for (var key in req.query) {
                // Add Property to objct with set value.
                if ((key in req.query) || req.query.hasOwnProperty(key)) {
                    if (isNull(req.query[key])) {
                        result.data[key] = null;
                    }
                    else result.data[key] = req.query[key];
                }
            }
        }
    }
    else if (req.method === 'POST') {
        var len = 0;
        // Check is Query object is null.
        if (!isNull(Object.keys(req.body)))
            len = Object.keys(req.body).length;

        if (len > 0) {
            result.data = req.body;
        }
    }
    else {
        result.error('Not Supports Operation other than GET or POST.');
    }
    return result;
};

exports.parseReq = module.exports.parseReq = parseReq;

/**
 * Write recordset result to json and send back via response object.
 */
function sendJson(req, res, result) {
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    //res.write(JSON.stringify(JSON.parse(result)));
    res.write(JSON.stringify(result));
    res.end();
};

exports.sendJson = module.exports.sendJson = sendJson;

/**
 * Send 404 (file not found).
 * 
 * @param {request} req Request object.
 * @param {response} res Response object.
 * @param {string} fileName Full File Name.
 */
function send404(req, res, fileName) {
    console.log('File not found.');
    res.status(404).send('The file "' + fileName + '" not found.');
};

exports.send404 = module.exports.send404 = send404;

/**
 * Send 500 (file not found).
 * 
 * @param {request} req Request object.
 * @param {response} res Response object.
 * @param {string} errMsg Error Message.
 */
function send500(req, res, errMsg) {
    console.log('ERROR 500: ', errMsg);
    res.status(500).send(errMsg);
};

exports.send500 = module.exports.send500 = send500;

/**
 * Send File to client.
 * 
 * @param {request} req Request object.
 * @param {response} res Response object.
 * @param {string} targetFile Full file name.
 */
function sendFile(req, res, targetFile) {
    if (fs.existsSync(targetFile)) {
        var opt = {
            maxAge: '15s'
        };
        res.sendFile(targetFile, opt);
    }
    else {
        send404(req, res, targetFile);
    }
};

exports.sendFile = module.exports.sendFile = sendFile;

// ================================================================
// [==== File I/O related functions ====]
// ================================================================
/**
 * Load Json File.
 * 
 * @param {string} targetFile Full file name.
 */
function loadJsonFile(targetFile) {
    var result = new NResult();
    try {
        var obj = fs.readFileSync(targetFile, 'utf8');
        if (!isNull(obj))
            result.result(JSON.parse(obj));
    }
    catch (err) {
        //this.data = null;
        result.error(err.message);
    };
    return result;
};

exports.loadJsonFile = module.exports.loadJsonFile = loadJsonFile;

/**
 * Load File.
 * 
 * @param {string} targetFile Full file name.
 */
function loadFile(targetFile) {
    var result = new NResult();
    try {
        var obj = fs.readFileSync(targetFile, 'utf8');
        if (!isNull(obj))
            result.result(obj);
    }
    catch (err) {
        //this.data = null;
        result.error(err.message);
    };
    return result;
};

exports.loadFile = module.exports.loadFile = loadFile;

function cookie2obj(req, res) {
    var obj = {};
    var keys = Object.keys(req.cookies);
    keys.forEach((key) => {
        if ((!(req.cookies[key] instanceof Function))) {
            obj[key] = req.cookies[key];
        }
    });
    return obj;
};

exports.cookie2obj = module.exports.cookie2obj = cookie2obj;

function obj2cookie(req, res, value, options) {
    let opts = options || {
        maxAge: 30 * 1000, // would expire after 30 second.
        httpOnly: false
    }
    var keys = Object.keys(value);
    keys.forEach((key) => {
        res.cookie(key, value[key], options);
    });
};

exports.obj2cookie = module.exports.obj2cookie = obj2cookie;
