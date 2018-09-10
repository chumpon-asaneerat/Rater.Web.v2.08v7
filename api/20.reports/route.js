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
                let langmaps = results.map((value) => { return value.LangId; });
                let langindex = langmaps.indexOf(row.LangId);
                let lang = null;
                if (langindex === -1) {
                    lang = {
                        'No': results.length + 1,
                        'LangId': row.LangId,
                        'qsets': []
                    }
                    // append to array.
                    results.push(lang);
                }
                else {
                    lang = results[langindex]; // set qset reference.
                }

                let qsetmaps = lang.qsets.map((value) => { return value.QSetId; });
                let qsetindex = qsetmaps.indexOf(row.QSetId);
                let qset = null;
                if (qsetindex === -1) {
                    // create new object for QSet.
                    qset = {
                        'No': lang.qsets.length + 1,
                        'QSetId': row.QSetId,
                        'QSetDescription': row.QSetDescription,
                        'BeginDate': row.BeginDate,
                        'EndDate': row.EndDate,
                        'IsDefault': row.IsDefault,
                        'slides': []
                    }
                    // append to array.
                    lang.qsets.push(qset);
                }
                else {
                    qset = lang.qsets[qsetindex]; // set qset reference.
                }

                let qslidemaps = qset.slides.map((value) => { return value.QSeq; });
                let qslideindex = qslidemaps.indexOf(row.QSeq);
                let slide = null;
                if (qslideindex === -1) {
                    slide = {
                        'No': qset.slides.length + 1,
                        'QSeq': row.QSeq,
                        'QSlideText': row.QSlideText,
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
                        'QItemText': row.QItemText,
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

function __GetCustomerOrgs(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetOrgs(reqModel.data, function (dbResult) {
            if (!dbResult.data) {
                console.log('has error');
                nlib.sendJson(req, res, dbResult);
                return;
            }

            let rows = dbResult.data;
            let results = [];
            rows.forEach(row => {
                let langmaps = results.map((value) => { return value.LangId; });
                let langindex = langmaps.indexOf(row.langId);
                let lang = null;
                if (langindex === -1) {
                    lang = {
                        'No': results.length + 1,
                        'LangId': row.langId,
                        'branchs': []                     
                    }
                    // append to array.
                    results.push(lang);
                }
                else {
                    lang = results[langindex]; // set qset reference.
                }

                let branchmaps = lang.branchs.map((value) => { return value.BranchId; });
                let branchindex = branchmaps.indexOf(row.branchId);
                let branch = null;
                if (branchindex === -1) {
                    // create new object for QSet.
                    branch = {
                        'No': lang.branchs.length + 1,
                        'BranchId': row.branchId,
                        'BranchName': row.BranchNameNative,
                        'orgs': []
                    }
                    // append to array.
                    lang.branchs.push(branch);
                }
                else {
                    branch = lang.branchs[branchindex]; // set qset reference.
                }

                let orgmaps = branch.orgs.map((value) => { return value.OrgId; });
                let orgindex = orgmaps.indexOf(row.orgId);
                let org = null;
                if (orgindex === -1) {
                    org = {
                        'No': branch.orgs.length + 1,
                        'OrgId': row.orgId,
                        'ParentId': row.parentId,
                        'OrgName': row.OrgNameNative,
                    };
                    // append to array.
                    branch.orgs.push(org);
                }
            });

            let result = new nlib.NResult();
            result.data = results;
            nlib.sendJson(req, res, result);
        });
    });
};

function __GetCustomerMembers(req, res) {
    raterdb.CallSp(req, res, function (req, res, reqModel) {
        raterdb.GetMemberInfos(reqModel.data, function (dbResult) {
            if (!dbResult.data) {
                console.log('has error');
                nlib.sendJson(req, res, dbResult);
                return;
            }

            let rows = dbResult.data;
            let results = [];
            rows.forEach(row => {
                let langmaps = results.map((value) => { return value.LangId; });
                let langindex = langmaps.indexOf(row.langId);
                let lang = null;
                if (langindex === -1) {
                    lang = {
                        'No': results.length + 1,
                        'LangId': row.langId,
                        'members': []
                    }
                    // append to array.
                    results.push(lang);
                }
                else {
                    lang = results[langindex]; // set qset reference.
                }

                let membermaps = lang.members.map((value) => { return value.MemberId; });
                let memberindex = membermaps.indexOf(row.memberId);
                let member = null;
                if (memberindex === -1) {
                    // create new object for QSet.
                    member = {
                        'No': lang.members.length + 1,
                        'MemberId': row.memberId,
                        'FullName': row.FullNameNative
                    }
                    // append to array.
                    lang.members.push(member);
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

function __GetSummaryReport(req, res) {
    var reqModel = nlib.parseReq(req);
    console.log(reqModel);
};

/**
 * Init routes.
 * 
 * @param {express} app 
 */
function init_routes(app) {
    // filters.
    app.all('/api/reports/qsets/search', __GetCustomerQSets); // OK.
    app.all('/api/reports/orgs/search', __GetCustomerOrgs); // OK.
    app.all('/api/reports/members/search', __GetCustomerMembers); // OK.
    // votes.
    app.all('/api/reports/raw-votes/search', __GetRawVotes); // OK.
    app.all('/api/reports/vote-summaries/search', __GetVoteSummaries); // OK.
    app.all('/api/reports/summaries/search', __GetSummaryReport); // OK.
};

exports.init_routes = init_routes;