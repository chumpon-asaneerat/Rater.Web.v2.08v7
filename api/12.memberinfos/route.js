// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveMemberInfo(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveMemberInfo(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveMemberInfoML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveMemberInfoML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetMemberInfos(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetMemberInfos(reqModel.data, function (dbResult) {
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
    // Member Infos.
    app.all('/api/members/save', __SaveMemberInfo); // OK.
    app.all('/api/members/save-ml', __SaveMemberInfoML); // OK.
    app.all('/api/members/search', __GetMemberInfos); // OK.
};

exports.init_routes = init_routes;