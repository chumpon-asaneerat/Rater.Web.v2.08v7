// common requires
const path = require('path');
const fs = require('fs');
const express = require('express');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const nlib = require(path.join(rootPath, 'lib', 'nlib-core'));
const mssqldb = require(path.join(rootPath, 'lib', 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function __GetCustomerQSets(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetCustomerQSets(reqModel.data, function (dbResult) {
            if (!dbResult.data) {
                console.log('has error');
                nlib.sendJson(req, res, dbResult);
                return;
            }

            let rows = dbResult.data;
            let results = [];
            rows.forEach(row => {
                let qsetmaps = results.map((value) => { return value.QSetId; });
                let qsetindex = qsetmaps.indexOf(row.QSetId);
                let qset = null;
                if (qsetindex === -1) {
                    // create new object for QSet.
                    qset = {
                        'No': results.length + 1,
                        'QSetId': row.QSetId,
                        'QSetDescriptionEN': row.QSetDescriptionEN,
                        'QSetDescriptionNative': row.QSetDescriptionNative,
                        'BeginDate': row.BeginDate,
                        'EndDate': row.EndDate,
                        'IsDefault': row.IsDefault,
                        'slides': []
                    }
                    // append to array.
                    results.push(qset);
                }
                else {
                    qset = results[qsetindex]; // set qset reference.
                }

                let qslidemaps = qset.slides.map((value) => { return value.QSeq; });
                let qslideindex = qslidemaps.indexOf(row.QSeq);
                let slide = null;
                if (qslideindex === -1) {
                    slide = {
                        'No': qset.slides.length + 1,
                        'QSeq': row.QSeq,
                        'QSlideTextEN': row.QSlideTextEN,
                        'QSlideTextNative': row.QSlideTextNative,
                        //'QSlideOrder': row.QSlideOrder,
                        'items': []
                    }
                    // append to array.
                    qset.slides.push(slide);
                }
                else {
                    slide = qset.slides[qslideindex]; // set qslide reference.
                }
                
                let qitemmaps = slide.items.map((value) => { return value.QSSeq; });
                let qitemindex = qitemmaps.indexOf(row.QSSeq);
                let slideitem = null;
                if (qitemindex === -1) {
                    slideitem = {
                        'No': slide.items.length + 1,
                        'QSSeq': row.QSSeq,
                        'QItemTextEN': row.QItemTextEN,
                        'QItemTextNative': row.QItemTextNative,
                        //'QItemOrder': row.QItemOrder
                    }
                    // append to array.
                    slide.items.push(slideitem);
                }
            });

            let result = new nlib.NResult();
            result.data = results;
            nlib.sendJson(req, res, result);
        });
    });
};

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
    // filters.
    app.all('/api/reports/qsets/search', __GetCustomerQSets); // OK.
    // votes.
    app.all('/api/reports/raw-votes/search', __GetRawVotes); // OK.
    app.all('/api/reports/vote-summaries/search', __GetVoteSummaries); // OK.
};

exports.init_routes = init_routes;