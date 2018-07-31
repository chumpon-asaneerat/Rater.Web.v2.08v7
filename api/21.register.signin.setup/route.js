// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));
const rwc = require(path.join(rootPath, 'lib', 'rater-web-secure'));

// ================================================================
// [==== Resiger/Sign In ====]
// ================================================================
function __Register(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.Register(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __CheckUsers(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.CheckUsers(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SignIn(req, res) {    
    if (!rwc.hasAccessId(req, res)) {
        raterdb.CallSp(req, res, function (req, res, reqModel) {
            raterdb.SignIn(reqModel.data, function (dbResult) {
                reqModel.data.accessId = null;
                rwc.setAccessId(req, res, dbResult, function (url) {
                    // returns results.
                    dbResult.url = url;
                    nlib.sendJson(req, res, dbResult);
                });
            });
        });
    }
    else {
        //console.log('already has access id.');
        let rw2 = nlib.cookie2obj(req, res) || {};
        let accessId = rw2.accessId;
        rwc.getHomeUrl(accessId, function (url) {
            let result = new nlib.NResult();
            result.result([]);
            result.outputs = { accessId: accessId };
            result.url = url;
            // returns results.
            nlib.sendJson(req, res, result);
        });
    }
};
/*
function __CheckAccess(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.CheckAccess(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};
*/
function __GetAccessUser(req, res) {
    if (rwc.hasAccessId(req, res)) {
        let rw2 = nlib.cookie2obj(req, res) || {};
        let accessId = rw2.accessId;
        raterdb.CallSp(req, res, function (req, res, reqModel) {
            reqModel.data.accessId = accessId;            
            raterdb.GetAccessUser(reqModel.data, function (dbResult) {
                rwc.getHomeUrl(accessId, function (url) {                
                    nlib.sendJson(req, res, dbResult);
                });
            });
        });
    }
    else {
        rwc.getHomeUrl(null, function (url) {
            let result = new nlib.NResult();
            result.result([]);
            result.url = url;
            // returns results.
            nlib.sendJson(req, res, result);
        });
    }
};

function __SignOut(req, res) {
    if (rwc.hasAccessId(req, res)) {
        let rw2 = nlib.cookie2obj(req, res) || {};
        let accessId = rw2.accessId;        
        raterdb.CallSp(req, res, function (req, res, reqModel) {
            reqModel.data.accessId = accessId;
            raterdb.SignOut(reqModel.data, function (dbResult) {
                rwc.clearAccessId(req, res, function (url) {
                    dbResult.url = url;
                    // returns results.
                    nlib.sendJson(req, res, dbResult);
                });
            });
        });
    }
    else {
        nlib.obj2cookie(req, res, { }); // set empty object.
        rwc.clearAccessId(req, res, function (url) {
            let result = new nlib.NResult();
            result.result([]);
            result.url = url;
            // returns results.
            nlib.sendJson(req, res, result);
        });
    }
};

/**
 * Init routes.
 * 
 * @param {express} app 
 */
function init_routes(app) {
    // register-signin.
    app.all('/api/edl/register', __Register); // OK.
    app.all('/api/edl/users', __CheckUsers); // OK.
    app.all('/api/edl/signin', __SignIn); // OK.
    //app.all('/api/edl/check', __CheckAccess); // OK.
    app.all('/api/edl/user', __GetAccessUser); // OK.
    app.all('/api/edl/signout', __SignOut); // OK.
};

exports.init_routes = init_routes;
