// common requires
const path = require('path');
const fs = require('fs');
const url = require('url');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

function init_routes(app) {
    // common for add custom data in header.
    /*
    app.use(function (req, res, next) {
        next();
    });
    */
};

exports.init_routes = init_routes;