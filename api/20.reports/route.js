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

//- Create New object with clone all properties with supports ignore case sensitive.
function clone(o, caseSensitive) {
    var oRet = {}
    var ignoreCase = (caseSensitive) ? false : true;
    var keys = Object.keys(o);
    keys.forEach((key) => {
        oRet[(ignoreCase) ? key.toLowerCase() : key] = o[key];
    });
    return oRet;
};

function __promiseGetVoteSummaries(param) {
    return new Promise((resolve) => {
        raterdb.GetVoteSummaries(param, function (dbResult) {
            resolve(dbResult);
        });
    });
};

function __GetSummaryReport(req, res) {
    let result = new nlib.NResult();
    result.data = []; // prepare data array.
    let reqModel = nlib.parseReq(req);
    if (!reqModel || !reqModel.data) {
        result.error('parameter is null.');
        nlib.sendJson(req, res, result);
    }
    else {
        let pData = clone(reqModel.data);
        let hasError = false;
        if (!hasError && !pData.customerid) {
            result.error('CustomerId is null or empty.');
            hasError = true;
        }
        if (!hasError && !pData.begindate) {
            result.error('BeginDate is null or empty.');
            hasError = true;
        }
        if (!hasError && !pData.enddate) {
            result.error('EndDate is null or empty.');
            hasError = true;
        }
        if (!hasError && !pData.qsetid) {
            result.error('QSetId is null or empty.');
            hasError = true;
        }
        if (!hasError && (!pData.qseq || pData.qseq.length === 0)) {
            result.error('QSeq is null or empty array.');
            hasError = true;
        }
        if (!hasError && (!pData.orgid || pData.orgid.length === 0)) {
            result.error('OrgId is null or empty array.');
            hasError = true;
        }
        if (hasError) nlib.sendJson(req, res, result);
        else {
            let oRet = {};
            oRet.CustomerId = pData.customerid;
            oRet.BeginDate = pData.begindate;
            oRet.EndDate = pData.enddate;
            oRet.QSetId = pData.qsetid;
            oRet.questions = [];

            let functions = [];
            pData.qseq.forEach(qNo => {
                // init output for each question
                let question = { 
                    QSeq: qNo, 
                    orgs: []
                };
                oRet.questions.push(question);
                pData.orgid.forEach(oId => { 
                    // init output for each org
                    let org = {
                        OrgId: oId,
                        BranchId: '',
                        UserId: '',
                        TotalCnt: 0,
                        Average: 0,
                        MaxChoice: 0,
                        items: []
                    }
                    question.orgs.push(org);

                    // create parameter for call sp.
                    let spParam = {};
                    spParam.customerid = pData.customerid;
                    spParam.begindate = pData.begindate;
                    spParam.enddate = pData.enddate;
                    spParam.qsetid = pData.qsetid;
                    spParam.qseq = qNo;
                    spParam.orgid = oId;
                    let fn = __promiseGetVoteSummaries(spParam);
                    functions.push(fn);
                });
            });
            // create map for qseq
            let quesMaps = oRet.questions.map(q => Number(q.QSeq));

            Promise.all(functions).then(results => {
                if (results) {
                    results.forEach(rObj => {
                        if (rObj && rObj.data && rObj.data.length > 0) {
                            let rows = rObj.data;
                            rows.forEach(row => {
                                //console.log(row)
                                let qidx = quesMaps.indexOf(row.QSeq);
                                let question = (qidx !== -1) ? oRet.questions[qidx] : null;
                                if (question) {
                                    let orgMaps = question.orgs.map(q => q.OrgId );
                                    let oidx = orgMaps.indexOf(row.OrgId);
                                    let org = (oidx !== -1) ? question.orgs[oidx] : null;
                                    if (org) {
                                        org.BranchId = row.BranchId;
                                        org.UserId = row.UserId;
                                        org.TotalCnt = row.TotCnt;
                                        org.Average = row.AvgTot;
                                        org.MaxChoice = row.MaxChoice;
                                        let item = {
                                            Choice: row.Choice,
                                            Cnt: row.Cnt,
                                            Pct: row.Pct,
                                            RemarkCnt: row.RemarkCnt
                                        };
                                        org.items.push(item);
                                    }
                                }
                            })
                        }
                    });
                }
                result.data.push(oRet);
                nlib.sendJson(req, res, result);
            });
        }
    }
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