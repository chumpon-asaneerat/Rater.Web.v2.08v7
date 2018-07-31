// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveBranch(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveBranch(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveBranchML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveBranchML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetBranchs(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetBranchs(reqModel.data, function (dbResult) {
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
    app.all('/api/branchs/save', __SaveBranch); // OK.
    app.all('/api/branchs/save-ml', __SaveBranchML); // OK.
    app.all('/api/branchs/search', __GetBranchs); // OK.
};

exports.init_routes = init_routes;