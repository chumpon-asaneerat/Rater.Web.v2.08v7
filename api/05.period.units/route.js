// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SavePeriodUnit(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SavePeriodUnit(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SavePeriodUnitML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SavePeriodUnitML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetPeriodUnits(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetPeriodUnits(reqModel.data, function (dbResult) {
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
    // Period Units
    app.all('/api/edl/periodunits/save', __SavePeriodUnit); // OK.
    app.all('/api/edl/periodunits/save-ml', __SavePeriodUnitML); // OK.
    app.all('/api/edl/periodunits/search', __GetPeriodUnits); // OK.
};

exports.init_routes = init_routes;