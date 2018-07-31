// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __GetRandomHexCode(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetRandomHexCode(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetUserHomeUrl(req, res) {
    var reqModel = nlib.parseReq(req);
    if (reqModel.errors.hasError) {
        nlib.sendJson(req, res, reqModel.errors.errMsg);
    }
    else {
        var result = new nlib.NResult();
        result.data = { url: '' };
        if (!nlib.isNull(reqModel.data.MemberType)) {
            switch (reqModel.data.MemberType) {
                case "100":
                    // EDL - Admin
                    result.data.url = '/edl/admin';
                    break;
                case "110":
                    // EDL - Power User
                    result.data.url = '/edl/supervisor';
                    break;
                case "180":
                    // EDL - Staff
                    result.data.url = '/edl/staff';
                    break;
                case "200":
                    // Admin
                    result.data.url = '/admin';
                    break;
                case "210":
                    // Exclusive
                    result.data.url = '/exclusive';
                    break;
                case "280":
                    // Staff
                    result.data.url = '/staff';
                    break;
                case "290":
                    // Device
                    result.data.url = '/device';
                    break;
                default:
                    result.data.url = '';
                    break;
            }
        }
        else { 
            result.error('Member Type Id is null.');
        }
        nlib.sendJson(req, res, result);
    }
};

/**
 * Init routes.
 * 
 * @param {express} app 
 */
function init_routes(app) {
    // utilities.
    app.all('/api/edl/utils/randomcode', __GetRandomHexCode); // OK.
    //app.all('/api/edl/utils/userhome', __GetUserHomeUrl); // OK.
};

exports.init_routes = init_routes;