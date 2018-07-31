// common requires
const path = require('path');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const find = require('find');
const fs = require('fs');

function init_route_js(app, parentPath) {    
    find.fileSync(parentPath).forEach(file => {
        if (path.basename(file).toLowerCase() === 'route.js') {
            try {
                console.log('  + setup route:', path.dirname(file));
                require(file).init_routes(app);
            }
            catch (ex) {
                console.error('Cannot init route in file: ' + file);
                console.error(ex);
            }
        }
    });
};

/**
 * init common paths.
 * 
 * @param {express} app
 */
function init_functions(app) {
    console.log('init api routes....');
    var apiPath = path.join(rootPath, 'api');
    init_route_js(app, apiPath);
    console.log('init views routes....');
    var viewsPath = path.join(rootPath, 'views');
    init_route_js(app, viewsPath);
};

exports.init = init_functions;