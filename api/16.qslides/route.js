// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveQSlide(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveQSlide(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveQSlideML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveQSlideML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetQSlides(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetQSlides(reqModel.data, function (dbResult) {
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
    // QSlides.
    app.all('/api/qslides/save', __SaveQSlide); // OK.
    app.all('/api/qslides/save-ml', __SaveQSlideML); // OK.
    app.all('/api/qslides/search', __GetQSlides); // OK.
};

exports.init_routes = init_routes;