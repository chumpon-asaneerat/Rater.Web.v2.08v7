// common requires
const path = require('path');
const fs = require('fs');
const url = require('url');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

/**
 * Init routes.
 * 
 * @param {express} app 
 */
function init_routes(app) {    
    // Generalized Error Handling.
    // Using the wildcard '*' in our route, we can create a route to catch every 
    // request to a route we have not defined elsewhere.
    app.get('*', function (req, res, next) {
        // Tells us which IP tried to reach a particular URL.
        var requrl = url.format({
            protocol: req.protocol,
            host: req.get('host'),
            pathname: req.originalUrl
        });
        //var err = new Error(`The request IP: "${req.ip}" tried to reach "${req.originalUrl}"`);
        var msg = `The request IP: "${req.ip}" tried to reach "${requrl}"`;
        var err = new Error(msg);
        err.statusCode = 404;
        // New property on err so that our middleware will redirect.
        //err.shouldRedirect = true;
        err.shouldRedirect = false;

        next(err);
    });

    // Refactor our route to make it tell Express that users shouldn't just receive an error, 
    // but should be redirected to an error page.
    app.use(function (err, req, res, next) {
        console.error(err.message);

        if (!err.statusCode) {
            // Sets a generic server error status code if none is part of the err.
            err.statusCode = 500;
        }

        if (err.shouldRedirect) {
            // Renders a myErrorPage.html for the user.
            res.render('myErrorPage');
        }
        else {
            // If shouldRedirect is not defined in our error, sends our original err data.
            res.status(err.statusCode).send(err.message);
        }
    });
};

exports.init_routes = init_routes;