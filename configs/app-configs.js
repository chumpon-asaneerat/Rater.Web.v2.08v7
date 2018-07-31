// Export
exports = module.exports = {
    app: {
        name: 'My Choice Rater Web',
        version: 'v2.0.8'
    },
    server: {
        portNumber: 3010
    },
    db: {
        //-- For DEV
        serverName: 'localhost',
        dbName: 'TestDb7x3',
        userName: 'sa',
        passWord: 'winnt123',
        //-- For EDL
        //dbName: 'RaterWeb2x8',
        //userName: 'sa',
        //passWord: 'P@ssw0rd',
        getDatabaseConfig: function () {
            return {
                user: this.userName,
                password: this.passWord,
                server: this.serverName,
                database: this.dbName,
                pool: {
                    max: 10,
                    min: 0,
                    idleTimeoutMillis: 30000
                }
            }
        }
    }
};