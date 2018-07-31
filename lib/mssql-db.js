'use strict';

const path = require('path');
const fs = require('fs');
const find = require('find');
const sql = require('mssql');
const moment = require('moment');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const confPath = path.join(rootPath, 'configs');
const libPath = path.join(rootPath, 'lib');

const conf = require(path.join(confPath, 'app-configs'));
const nlib = require(path.join(libPath, 'nlib-core'));

const dbdefPath = path.join(rootPath, 'db', 'definitions');
const dbdefExt = '.json';

function toSqlType(sTypeVal) {
    var result = null;
    var sType = sTypeVal.toLowerCase();
    var iOpenParen = sType.indexOf('(');
    var iCloseParen = sType.indexOf(')');
    var paramStr = '';
    if (iOpenParen >= 0 || iCloseParen >= 0)
        paramStr = sType.slice(iOpenParen + 1, iCloseParen).trim();
    var firstParam = 0;
    var secondParam = 0;

    if (sType.startsWith('bit')) {
        result = sql.Bit;
    }
    else if (sType.startsWith('bigint')) {
        result = sql.BigInt;
    }
    else if (sType.startsWith('float')) {
        result = sql.Float;
    }
    else if (sType.startsWith('int')) {
        result = sql.Int;
    }
    else if (sType.startsWith('money')) {
        result = sql.Money;
    }
    else if (sType.startsWith('smallint')) {
        result = sql.SmallInt;
    }
    else if (sType.startsWith('smallmoney')) {
        result = sql.SmallMoney;
    }
    else if (sType.startsWith('real')) {
        result = sql.Real;
    }
    else if (sType.startsWith('tinyint')) {
        result = sql.TinyInt;
    }
    else if (sType.startsWith('text')) {
        result = sql.Text;
    }
    else if (sType.startsWith('ntext')) {
        result = sql.NText;
    }
    else if (sType.startsWith('xml')) {
        result = sql.Xml;
    }
    else if (sType.startsWith('datetimeoffset')) {
        result = sql.DateTimeOffset;
    }
    else if (sType.startsWith('datetime')) {
        //result = sql.DateTime;
        result = sql.DateTimeOffset;
    }
    else if (sType.startsWith('date')) {
        //result = sql.Date;
        result = sql.DateTimeOffset;
    }
    else if (sType.startsWith('smalldatetime')) {
        result = sql.SmallDateTime;
    }
    else if (sType.startsWith('uniqueidentifier')) {
        result = sql.UniqueIdentifier;
    }
    else if (sType.startsWith('binary')) {
        result = sql.Binary;
    }
    else if (sType.startsWith('image')) {
        result = sql.Image;
    }
    else if (sType.startsWith('udt')) {
        result = sql.UDT;
    }
    else if (sType.startsWith('geography')) {
        result = sql.Geography;
    }
    else if (sType.startsWith('geometry')) {
        result = sql.Geometry;
    }
    else if (sType.startsWith('char')) {
        if (paramStr !== 'max') {
            firstParam = new Number(paramStr);
            result = sql.Char(firstParam);
        }
        else result = sql.Char(sql.MAX);
    }
    else if (sType.startsWith('nchar')) {
        if (paramStr !== 'max') {
            firstParam = new Number(paramStr);
            result = sql.NChar(firstParam);
        }
        else result = sql.NChar(sql.MAX);
    }
    else if (sType.startsWith('varchar')) {
        if (paramStr !== 'max') {
            firstParam = new Number(paramStr);
            result = sql.VarChar(firstParam);
        }
        else result = sql.VarChar(sql.MAX);
    }
    else if (sType.startsWith('nvarchar')) {
        if (paramStr !== 'max') {
            firstParam = new Number(paramStr);
            result = sql.NVarChar(firstParam);
        }
        else result = sql.NVarChar(sql.MAX);
    }
    else if (sType.startsWith('time')) {
        firstParam = new Number(paramStr);
        result = sql.Time(firstParam);
    }
    else if (sType.startsWith('datetime2')) {

        firstParam = new Number(paramStr);
        result = sql.DateTime2(firstParam);
    }
    else if (sType.startsWith('datetimeoffset')) {
        firstParam = new Number(paramStr);
        result = sql.DateTimeOffset(firstParam);
    }
    else if (sType.startsWith('varbinary')) {
        if (paramStr !== 'max') {
            firstParam = new Number(paramStr);
            result = sql.VarBinary(firstParam);
        }
        else result = sql.VarBinary(sql.MAX);
    }
    else if (sType.startsWith('decimal')) {
        var args = paramStr.split(',');
        result = sql.Decimal(new Number(args[0].trim()), new Number(args[1].trim()));
    }
    else if (sType.startsWith('numeric')) {
        var args = paramStr.split(',');
        result = sql.Numeric(new Number(args[0].trim()), new Number(args[1].trim()))
    }
    else if (sType.startsWith('variant')) {
        //result = sql.Variant;
    }
    return result;
};

function formatValue(sqlType, val) {
    var result = null;
    if (sqlType === null)
        return val;

    switch (sqlType) {
        case sql.Bit:
            if (!val || (typeof val !== 'string')) {
                //console.log('is null or not string.');
                result = val;
            }
            else {
                if (val === '1' ||
                    val.toLocaleUpperCase() === 'TRUE' ||
                    val.toLocaleUpperCase() === 'YES' ||
                    val.toLocaleUpperCase() === 'Y') {
                    result = true;
                }
                else if (val === '0' ||
                    val.toLocaleUpperCase() === 'FALSE' ||
                    val.toLocaleUpperCase() === 'NO' ||
                    val.toLocaleUpperCase() === 'N') {
                    result = false;
                }
                else if (val.toLocaleUpperCase() === 'NULL') {
                    result = null;
                }
                else {
                    console.log('no match boolean string. value is :', val);
                    result = val;
                }
            }
            break;
        case sql.Date:
        case sql.DateTime:
        case sql.DateTime2:
        case sql.DateTimeOffset:
            if (!val || (val instanceof Date)) {
                console.log('DATE');
                result = val;
            }
            else {
                console.log('OTHER');
                try {
                    var dt = moment(val, 'YYYY-MM-DD HH.mm.ss.SSS');
                    result = new Date(dt.utc());
                }
                catch (ex) {
                    console.log(ex);
                }
            }
            break;
        default:
            result = val;
            break;
    }
    return result;
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

function setValues(dest, src) {
    var keys = Object.keys(dest);
    keys.forEach(key => {
        let dKey = key.toLowerCase();
        dest[key] = (!src[dKey]) ? null : src[dKey];
    })
};

// ================================================================
// [==== msSqldb class ====]
// ================================================================
/**
 * The msSqldb constructor.
 * 
 * @param {string} defFileName - The Json Definition File Name. 
 */
function msSqldb(defFileName) {
    // find file name.    
    var fileName = '';

    find.fileSync(dbdefPath).forEach(file => {
        if (path.basename(file).toLowerCase() === (defFileName + dbdefExt).toLowerCase()) {
            try {
                fileName = file;
            }
            catch (ex) {
                //console.error(file, ex);
            }
        }
    });
    
    var result = nlib.loadJsonFile(fileName);
    //console.log(def);
    if (result.errors.hasError)
        this.data = null;
    else this.data = result.data;
};
/**
 * Prepare input and output parameter from definition file.
 * 
 * @param {any} pObj - The Json object that match parameter's name in definition file. Normally
 * this value is automatically parse from GET/POST request header by nlib.
 * @param {any} conn - The mssql request instance. 
 */
msSqldb.prototype.Prepare = function (pObj, conn) {
    if (nlib.isNull(this.data) ||
        nlib.isNull(this.data.definition))
        return;
    var pObjX = clone(pObj);
    var medDef = this.data.definition;

    var p_name = '';
    var sql_type = null;
    var tsqlType = null;
    var p_value = null;
    var p_defval = null;
    // For input paramters.
    if (!nlib.isNull(medDef.inputs) && medDef.inputs.length > 0) {
        medDef.inputs.forEach(p_input => {
            // get parameter name.
            p_name = p_input.name.toLowerCase();
            // get prefer sql data type.
            sql_type = (nlib.isNull(p_input.sqlType)) ? null : p_input.sqlType;
            tsqlType = (!sql_type) ? null : toSqlType(sql_type);
            // get default value if not assigned in pObj.
            p_defval = (nlib.isNull(p_input.default)) ? null : p_input.default;

            if (p_name in pObjX || pObjX.p_name) {
                p_value = pObjX[p_name];
            }
            else {
                p_value = p_defval;
            }

            if (sql_type === null)
                conn.input(p_name, p_value);
            else conn.input(p_name, tsqlType, formatValue(tsqlType, p_value));
         });
    }
    // For output paramters.
    if (!nlib.isNull(medDef.outputs) && medDef.outputs.length > 0) {
        medDef.outputs.forEach(p_output => {
            // get parameter name.
            p_name = p_output.name.toLowerCase();
            // get prefer sql data type.
            sql_type = (nlib.isNull(p_output.sqlType)) ? null : p_output.sqlType;
            tsqlType = (!sql_type) ? null : toSqlType(sql_type);
            // get default value if not assigned in pObj.
            p_defval = (nlib.isNull(p_output.default)) ? null : p_output.default;

            if (p_name in pObjX || pObjX.p_name) {
                p_value = pObjX[p_name];
            }
            else {
                p_value = p_defval;
            }

            if (sql_type === null)
                conn.output(p_name, p_value);
            else conn.output(p_name, tsqlType, formatValue(tsqlType, p_value));
        });
    }
};
/**
 * Read output parameter from definition file after exeution.
 * 
 * @param {any} conn - The mssql request instance. 
 * @param {any} results - The result object. 
 */
msSqldb.prototype.ReadOutputs = function (conn, result) {
    if (nlib.isNull(this.data) ||
        nlib.isNull(this.data.definition))
        return;

    var medDef = this.data.definition;

    if (!nlib.isNull(medDef.outputs) && medDef.outputs.length > 0) {
        medDef.outputs.forEach(p_output => {
            var pName = p_output.name;
            var pNameLC = pName.toLowerCase();

            if (pName === 'errNum') {
                // error No.
                if (!nlib.isNull(conn.parameters[pNameLC])) {
                    result.errors.errNum = conn.parameters[pNameLC].value;
                    if (result.errors.errNum !== 0)
                        result.errors.hasError = true;
                    else result.errors.hasError = false;
                }
            }
            else if (pName === 'errMsg') {
                // error message.
                if (!nlib.isNull(conn.parameters[pNameLC])) {
                    result.errors.errMsg = conn.parameters[pNameLC].value;
                }
            }
            else if (pName === 'pageNum') {
                // Page No.
                if (!nlib.isNull(conn.parameters[pNameLC])) {
                    if (nlib.isNull(result.paging))
                        result.paging = {};
                    result.paging.pageNo = conn.parameters[pNameLC].value;
                }
            }
            else if (pName === 'rowsPerPage') {
                // Row Per Page.
                if (!nlib.isNull(conn.parameters[pNameLC])) {
                    if (nlib.isNull(result.paging))
                        result.paging = {};
                    result.paging.rowPerPage = conn.parameters[pNameLC].value;
                }
            }
            else if (pName === 'totalRecords') {
                // Total Records.
                if (!nlib.isNull(conn.parameters[pNameLC])) {
                    if (nlib.isNull(result.paging))
                        result.paging = {};
                    result.paging.totalRows = conn.parameters[pNameLC].value;
                }
            }
            else if (pName === 'maxPage') {
                // Max Page.
                if (!nlib.isNull(conn.parameters[pNameLC])) {
                    if (nlib.isNull(result.paging))
                        result.paging = {};
                    result.paging.maxPage = conn.parameters[pNameLC].value;
                }
            }
            else {
                // other output parameter results.
                var pVal = conn.parameters[pNameLC].value;
                if (nlib.isNull(result.outputs))
                    result.outputs = {};
                //result.outputs.push({ 'Name': pName, 'Value': pVal });
                result.outputs[pName] = pVal;
            }
        });
    }
};
/**
 * Execute Stored Procedure.
 * 
 * @param {any} pObj - The Json object that match parameter's name in definition file. Normally
 * this value is automatically parse from GET/POST request header by nlib.
 * @param {function} callback - The callback parameter is db_result. 
 */
msSqldb.prototype.Execute = function (pObj, callback) {
    var result = new nlib.NResult();
    if (nlib.isNull(this.data) ||
        nlib.isNull(this.data.definition)) {
        result.error('cannot find definition.');
        callback(result);
    }
    else {
        var config = conf.db.getDatabaseConfig();
        var conn = new sql.Connection(config);
        var medDef = this.data.definition;
        var self = this;

        conn.connect().then(function () {
            var req = new sql.Request(conn);
            // Prepare Inputs and outputs before execute.
            self.Prepare(pObj, req);
            // Execute
            req.execute(medDef.name).then(function (recordsets) {
                if (recordsets !== null && recordsets !== 'undefined') {
                    if (recordsets.length > 0)
                        result.data = recordsets[0];
                    else result.data = [];
                }
                // Read output after execute. 
                self.ReadOutputs(req, result);
                // send result to callback function.
                callback(result);
            });
        }).catch(function (err) {
            result.error(err.message);
            callback(result);
        });
    }
};

exports.msSqldb = module.exports.msSqldb = msSqldb;
