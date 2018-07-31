// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __SaveLicenseFeature(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.SaveLicenseFeature(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetLicenseFeatures(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetLicenseFeatures(reqModel.data, function (dbResult) {
            nlib.sendJson(req, res, dbResult);
        });
    });
};

function __GetLicenses(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetLicenses(reqModel.data, function (dbResult) {
            if (dbResult.errors.hasError) {
                nlib.sendJson(req, res, dbResult);
            }
            else {
                var result = new nlib.NResult();
                var rows = dbResult.data;
                var rObj = {};
                rows.forEach(function (row) {
                    if (!rObj[row.LangId]) {
                        rObj[row.LangId] = {}
                        rObj[row.LangId].licenses = [];
                    }
                    var lObj = null;
                    for (var i = 0; i < rObj[row.LangId].licenses.length; ++i) {
                        var lc = rObj[row.LangId].licenses[i];
                        if (lc.LicenseTypeId === row.LicenseTypeId) {
                            lObj = lc;
                            break;
                        }
                    }

                    if (!lObj) {
                        lObj = {}
                        lObj.LangId = row.LangId;
                        lObj.LicenseTypeId = row.LicenseTypeId;
                        lObj.LicenseTypeDescriptionEn = row.LicenseTypeDescriptionEn;
                        lObj.LicenseTypeDescriptionNative = row.LicenseTypeDescriptionNative;
                        lObj.AdTextEN = row.AdTextEN;
                        lObj.AdTextNative = row.AdTextNative;
                        lObj.PeriodUnitId = row.PeriodUnitId;
                        lObj.NumberOfUnit = row.NumberOfUnit;
                        lObj.UseDefaultPrice = row.UseDefaultPrice;
                        lObj.Price = row.Price;
                        lObj.CurrencySymbol = row.CurrencySymbol;
                        lObj.CurrencyText = row.CurrencyText;
                        lObj.Enabled = row.Enabled;
                        lObj.SortOrder = row.SortOrder;
                        lObj.features = [];
                        rObj[row.LangId].licenses.push(lObj);
                    }

                    var fObj = null;
                    for (var i = 0; i < lObj.features.length; ++i) {
                        var ft = lObj.features[i];
                        if (ft.Seq === row.Seq) {
                            fObj = ft;
                            break;
                        }
                    }

                    if (!fObj) {
                        fObj = {}
                        fObj.Seq = row.Seq;
                        fObj.LimitUnitId = row.LimitUnitId;
                        fObj.NoOfLimit = row.NoOfLimit;
                        fObj.LimitUnitTextEN = row.LimitUnitTextEN;
                        fObj.LimitUnitTextNative = row.LimitUnitTextNative;
                        fObj.LimitUnitDescriptionEN = row.LimitUnitDescriptionEN;
                        fObj.LimitUnitDescriptionNative = row.LimitUnitDescriptionNative;
                        lObj.features.push(fObj);
                    }
                });

                result.data = rObj;

                nlib.sendJson(req, res, result);
            }
        });
    });
};

/**
 * Init routes.
 * 
 * @param {express} app 
 */
function init_routes(app) {
    // License Features.
    app.all('/api/edl/licensefeatures/save', __SaveLicenseFeature); // OK.
    app.all('/api/edl/licensefeatures/search', __GetLicenseFeatures); // OK.
    // Licenses.
    app.all('/api/edl/licenses/search', __GetLicenses); // OK.
};

exports.init_routes = init_routes;