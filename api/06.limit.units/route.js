// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveLimitUnit(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveLimitUnit(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveLimitUnitML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveLimitUnitML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetLimitUnits(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetLimitUnits(reqModel.data, function (dbResult) {
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
    // Limit Units.
    app.all('/api/edl/limitunits/save', __SaveLimitUnit); // OK.
    app.all('/api/edl/limitunits/save-ml', __SaveLimitUnitML); // OK.
    app.all('/api/edl/limitunits/search', __GetLimitUnits); // OK.
};

exports.init_routes = init_routes;