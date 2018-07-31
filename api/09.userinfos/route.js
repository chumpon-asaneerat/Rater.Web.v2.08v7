// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveUserInfo(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveUserInfo(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveUserInfoML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveUserInfoML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetUserInfos(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetUserInfos(reqModel.data, function (dbResult) {
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
    // User Infos.
    app.all('/api/edl/users/save', __SaveUserInfo); // OK.
    app.all('/api/edl/users/save-ml', __SaveUserInfoML); // OK.
    app.all('/api/edl/users/search', __GetUserInfos); // OK.
};

exports.init_routes = init_routes;