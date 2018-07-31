// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveLicenseType(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveLicenseType(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveLicenseTypeML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveLicenseTypeML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetLicenseTypes(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetLicenseTypes(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

/**
 * Init routes.
 * 
 * @param {express} app 
 */
function init_routes(app) {
    // License Types.
    app.all('/api/edl/licensetypes/save', __SaveLicenseType); // OK.
    app.all('/api/edl/licensetypes/save-ml', __SaveLicenseTypeML); // OK.
    app.all('/api/edl/licensetypes/search', __GetLicenseTypes); // OK.
};

exports.init_routes = init_routes;