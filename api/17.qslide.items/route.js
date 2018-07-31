// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveQSlideItem(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveQSlideItem(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveQSlideItemML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveQSlideItemML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetQSlideItems(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetQSlideItems(reqModel.data, function (dbResult) {
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
    // QSlideItems.
    app.all('/api/qslideitems/save', __SaveQSlideItem); // OK.
    app.all('/api/qslideitems/save-ml', __SaveQSlideItemML); // OK.
    app.all('/api/qslideitems/search', __GetQSlideItems); // OK.
};

exports.init_routes = init_routes;