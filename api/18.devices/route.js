// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveDevice(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveDevice(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveDeviceML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveDeviceML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetDevices(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetDevices(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetDeviceTypes(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetDeviceTypes(reqModel.data, function (dbResult) {
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
    // Branchs.
    app.all('/api/devices/save', __SaveDevice); // OK.
    app.all('/api/devices/save-ml', __SaveDeviceML); // OK.
    app.all('/api/devices/search', __GetDevices); // OK.
    app.all('/api/devicetypes/search', __GetDeviceTypes); // OK.
};

exports.init_routes = init_routes;