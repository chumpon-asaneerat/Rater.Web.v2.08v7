// common requires.
const path = require('path');

//const rootPath = path.dirname(require.main.filename);
process.env['ROOT_PATHS'] = path.join(path.dirname(require.main.filename), '../');

const rootPath = process.env['ROOT_PATHS'];

const libPath = path.join(rootPath, 'lib');

const sql = require('mssql');

/*
const nlib = require(path.join(libPath, 'nlib-core'));
const mssqldb = require(path.join(libPath, 'mssql-db'));
const raterdb = require(path.join(libPath, 'rater-web-db'));

let config = {
    server: 'localhost',
    database: 'TestDb7x4',
    user: 'sa',
    password: 'winnt123',
    pool: {
        max: 10,
        min: 0,
        idleTimeoutMillis: 30000
    },
    options: {
        encrypt: false
    }
}

describe('Database', () => { 
    describe.skip('node-mssql@4.1.0', () => {
        test('Direct', () => {
            let cp = new sql.ConnectionPool(config);
            cp.connect().then((pool) => {
                // create a request
                let request = new sql.Request(pool);
                let query = 'select * from language where langId = @param1';
                let hasErr = false;

                try {
                    request.input('param1', sql.NVarChar(3), 'EN');
                }
                catch (paramErr) {
                    console.log('PARA Err:', paramErr);
                    hasErr = true;
                }

                if (hasErr) {
                    expect(false).toBe(true);
                    return;
                }

                request.query(query).then((err, result) => {
                    if (err) {
                        console.log(err);
                        return;
                    }
                    consoel.dir(result);
                    expect(true).toBe(true);
                }).catch(execErr => {
                    // query or execute problem.
                    console.log('EXEC Err:', execErr);
                    expect(false).toBe(true);
                });
            }).catch(connErr => {
                // connect problem.
                console.log('CONN Err:', connErr);
                expect(false).toBe(true);
            });
        });
    });
});
*/