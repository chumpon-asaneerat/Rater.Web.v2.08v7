// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveOrg(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveOrg(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveOrgML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveOrgML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetOrgs(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetOrgs(reqModel.data, function (dbResult) {
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
    // Orgs.
    app.all('/api/orgs/save', __SaveOrg); // OK.
    app.all('/api/orgs/save-ml', __SaveOrgML); // OK.
    app.all('/api/orgs/search', __GetOrgs); // OK.
};

exports.init_routes = init_routes;