// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveCustomer(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveCustomer(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __SaveCustomerML(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveCustomerML(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetCustomers(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetCustomers(reqModel.data, function (dbResult) {
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
    // Customers.
    app.all('/api/edl/customers/save', __SaveCustomer); // OK.
    app.all('/api/edl/customers/save-mL', __SaveCustomerML); // OK.
    app.all('/api/edl/customers/search', __GetCustomers); // OK.
};

exports.init_routes = init_routes;