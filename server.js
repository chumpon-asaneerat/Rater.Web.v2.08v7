const express = require('express');
const path = require('path');

// setup root path.
process.env['ROOT_PATHS'] = path.dirname(require.main.filename);
//console.log('root path: ', process.env['ROOT_PATHS']);

const conf = require('./configs/app-configs');
const middleware = require('./lib/app-middlewares');
const commonpaths = require('./lib/app-paths');
const routes = require('./lib/app-routes');
const nlib = require('./lib/nlib-core');

// create express middle ware instance.
var app = express();
// setup port
app.set('port', process.env.PORT || conf.server.portNumber);
// setup middlewares.
middleware.init(app);
// setip common path(s).
commonpaths.init(app);
// setup routes
routes.init(app);

// start server.
var server = app.listen(app.get('port'), function () {
    var appName = conf.app.name + ' ' + conf.app.version;
    var portName = server.address().port;
    console.log(appName + ' listening on port ' + portName);
});