// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __GetRawVotes(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetRawVotes(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetVoteSummaries(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetVoteSummaries(reqModel.data, function (dbResult) {
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
    // votes.
    app.all('/api/reports/raw-votes/search', __GetRawVotes); // OK.
    app.all('/api/reports/vote-summaries/search', __GetVoteSummaries); // OK.
};

exports.init_routes = init_routes;