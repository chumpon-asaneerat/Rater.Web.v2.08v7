// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveQSet(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveQSet(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveQSetML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveQSetML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetQSets(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetQSets(reqModel.data, function (dbResult) {
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
    // QSets.
    app.all('/api/qsets/save', __SaveQSet); // OK.
    app.all('/api/qsets/save-ml', __SaveQSetML); // OK.
    app.all('/api/qsets/search', __GetQSets); // OK.
};

exports.init_routes = init_routes;