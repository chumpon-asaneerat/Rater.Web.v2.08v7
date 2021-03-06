// common requires
const path = require('path');
const fs = require('fs');
const find = require('find');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const rwc = require(path.join(rootPath, 'lib', 'rater-web-secure'));

const workPath = path.join(rootPath, 'views', 'default', 'signin');
const baseUrl = '/signin';

function getIndex(req, res, next) {
    if (rwc.hasAccessId(req, res)) {
        let rw2 = nlib.cookie2obj(req, res) || {};
        let accessId = rw2.accessId;
        if (accessId && accessId.length > 0) {
            rwc.getHomeUrl(accessId, function (url) {
                //console.log('Request to' + baseUrl + ' but no access id: ', url);
                return res.redirect(url);
            });
            return; // detected not has access id so exit here without do the rest code.
        }
    }

    var targetFile = path.join(workPath, 'index.handlebars');
    if (fs.existsSync(targetFile)) {
        res.render(targetFile, {
            title: "SignIn Home.",
            baseUrl: baseUrl
        });
    }
    else {
        next();
    }
};

function getJSFile(req, res, next) {
    var allowFiles = ['app.js', 'model.js'];
    var fileName = req.params.fileName;
    if (allowFiles.indexOf(fileName.toLowerCase()) == -1) {
        next();
    }
    else {
        var targetFile = path.join(workPath, 'js', fileName);
        nlib.sendFile(req, res, targetFile);
    }
};

function getCSSFile(req, res, next) {
    var fileName = req.params.fileName;
    var targetFile = path.join(workPath, 'css', fileName);
    nlib.sendFile(req, res, targetFile);
};

function getJsonModelByLangId(req, res, next) {
    var reqModel = nlib.parseReq(req);
    if (!reqModel.errors.hasError) {
        var modelType = reqModel.data.modelType;
        var langId = reqModel.data.langId;
        //console.log(baseUrl, ' request model:', modelType, ' for langId:', langId);
        var targetFile = path.join(workPath, 'contents', langId, modelType + '.json');
        if (!fs.existsSync(targetFile)) {
            targetFile = path.join(workPath, 'contents', 'EN', modelType + '.json');
        }
        var result = nlib.loadJsonFile(targetFile);
        nlib.sendJson(req, res, result);
    }
    else {
        next();
    }
};

function getModelNames(req, res, next) {
    let names = [];
    let contentENPath = path.join(workPath, 'contents', 'EN');
    find.fileSync(contentENPath).forEach(file => {
        try {
            names.push(path.basename(file, '.json').toLowerCase());
        }
        catch (ex) {
            //console.error(file, ex);
        }
    });
    let result = new nlib.NResult();
    result.result(names);
    nlib.sendJson(req, res, result);
};

/**
 * Init routes.
 * 
 * @param {express} app 
 */
function init_routes(app) {
    //console.log('    + route:', baseUrl + '/');
    app.get(baseUrl + '/', getIndex);
    app.get(baseUrl + '/js/:fileName', getJSFile);
    app.get(baseUrl + '/css/:fileName', getCSSFile);
    app.all(baseUrl + '/models', getJsonModelByLangId);
    app.all(baseUrl + '/modelnames', getModelNames);
};

exports.init_routes = init_routes;