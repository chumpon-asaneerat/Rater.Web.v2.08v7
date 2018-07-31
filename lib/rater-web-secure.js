'use strict';

// common requires.
const path = require('path');
const sql = require('mssql');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

//== [ DEVLOPER SETTING ] ==

const devmode = false; // set flag to change dev mode.

//== [ DEVLOPER SETTING ] ==

const libPath = path.join(rootPath, 'lib');
const nlib = require(path.join(libPath, 'nlib-core'));
const mssqldb = require(path.join(libPath, 'mssql-db'));
const raterdb = require(path.join(rootPath, 'lib', 'rater-web-db'));

function hasAccessId(req, res) {
    let rw2 = nlib.cookie2obj(req, res) || {};
    if (!rw2.accessId) {
        // No cookies or no access Id.
        rw2.accessId = null;
    }
    return (rw2.accessId) ? true : false;
};

exports.hasAccessId = module.exports.hasAccessId = hasAccessId;

function setAccessId(req, res, dbResult, callback) {
    let accessId = (!dbResult || !dbResult.outputs) ? null : dbResult.outputs.accessId;
    // update cookies.
    let rw2 = nlib.cookie2obj(req, res) || {};
    rw2.accessId = accessId;
    let options = {
        //maxAge: 10 * 1000, // 10 seconds
        //maxAge: 1 * 60 * 1000, // 1 minite
        //maxAge: 10 * 60 * 1000, // 10 minites
        maxAge: 30 * 60 * 1000, // 30 minites
        //maxAge: 1 * 60 * 60 * 1000, // 1 hours
        //maxAge: 1 * 24 * 60 * 60 * 1000, // 1 day
        //maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
        //maxAge: 30 * 24 * 60 * 60 * 1000, // 30 days
        httpOnly: false
    };
    nlib.obj2cookie(req, res, rw2, options);
    
    getHomeUrl(accessId, function(url) {
        //console.log('setAccessId raise callback method.');
        if (callback) callback(url);
    });
};

exports.setAccessId = module.exports.setAccessId = setAccessId;

function clearAccessId(req, res, callback) {
    // update cookies.
    let rw2 = nlib.cookie2obj(req, res) || {};
    rw2.accessId = '';
    let options = {
        maxAge: 0,
        //maxAge: 10 * 1000, // 10 seconds
        //maxAge: 1 * 60 * 1000, // 1 minite
        //maxAge: 10 * 60 * 1000, // 10 minites
        //maxAge: 24 * 60 * 60 * 1000, // 1 day
        //maxAge: 30 * 24 * 60 * 60 * 1000, // 30 days
        httpOnly: false
    };
    nlib.obj2cookie(req, res, rw2, options);

    getHomeUrl(rw2.accessId, function (url) {
        //console.log('setAccessId raise callback method.');
        if (callback) callback(url);
    });
};

exports.clearAccessId = module.exports.clearAccessId = clearAccessId;

function getHomeUrl(accessId, callback) {    
    let url = (devmode) ? '/dev/signin' : '/';
    if (accessId && accessId.length > 0) {
        let data = { langId: 'EN', accessId: accessId }
        let urls = [
            { memberType: 100, url: '/edl/admin' },
            { memberType: 110, url: '/edl/supervisor' },
            { memberType: 180, url: '/edl/staff' },
            { memberType: 200, url: '/admin' },
            { memberType: 210, url: '/exclusive' },
            { memberType: 280, url: '/staff' },
            { memberType: 290, url: '/device' }
        ];
        raterdb.CheckAccess(data, function (dbResult) {
            if (dbResult && dbResult.data && dbResult.data.length > 0) {
                //console.log('GetAccessUser result: ', dbResult);
                let memberType = dbResult.data[0].MemberType;
                //console.log('MemberType: ', memberType);
                let memtypes = urls.map((item) => { return item.memberType; });
                //console.log(memtypes);
                let index = memtypes.indexOf(memberType);
                //console.log('index:', index);
                if (index !== -1) {
                    url = (devmode) ? '/dev/report' : urls[index].url;
                }
            }
            if (callback) callback(url);
        });
    }
    else {
        // access id is null or empty string.
        if (callback) callback(url);
    }
};

exports.getHomeUrl = module.exports.getHomeUrl = getHomeUrl;
