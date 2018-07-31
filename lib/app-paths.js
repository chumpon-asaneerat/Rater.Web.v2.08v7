// common requires
const express = require('express');
const path = require('path');

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const publicPath = path.join(rootPath, 'public');
const assetPath = path.join(publicPath, 'assets');
const imagePath = path.join(assetPath, 'images');
const videoPath = path.join(assetPath, 'videos');
const audioPath = path.join(assetPath, 'audios');

const distPath = path.join(rootPath, 'public', 'dist');
const commonPath = path.join(rootPath, 'public', 'lib');

const distMaxAge = { maxage: '1d' };
const libMaxAge = { maxage: '15s' };

const dist_libs = [
    /* jQuery */
    { "route": "/dist/js", "path": "jquery-3.1.0" },
    /* jQuery UI */
    { "route": "/dist", "path": "jquery-ui-1.12.1" },
    /* bootstrap 4.x */
    { "route": "/dist/js", "path": "popperjs-1.14.3" },
    { "route": "/dist/js", "path": "tooltipjs-1.2.0" },
    { "route": "/dist", "path": "bootstrap-4.1.0" },
    /* font-awesome 5.x */
    { "route": "/dist", "path": "font-awesome-5.0.10" },
    /* emoji-symbols */
    { "route": "/dist/css", "path": "emoji-symbols-1.0.0" },
    /* flag-icon-css 3.x */
    { "route": "/dist", "path": "flag-icon-css-3.1.0" },
    /* animate-css */
    { "route": "/dist/css", "path": "animate-css-3.6.1" },
    /* moment */
    { "route": "/dist/js", "path": "moment-2.22.0" },
    /* client-js */
    { "route": "/dist/js", "path": "clientjs-0.1.11" },
    /* riot */
    { "route": "/dist/js", "path": "riotjs-3.10.0" },
    /* wow */
    { "route": "/dist/js", "path": "wow-1.3.0" },
    /* pace-js */
    { "route": "/dist/js", "path": "pacejs-1.0.0" },
    /* howler */
    { "route": "/dist/js", "path": "howler-2.0.3" },
    /* handlebars */
    { "route": "/dist/js", "path": "handlebars-4.0.5" },
    /* jQuery handlebars */
    { "route": "/dist/js", "path": "jquery-handlebars-1.3.7" },
    /* highcharts */
    //{ "route": "/dist", "path": "highcharts-6.0.7" },
    { "route": "/dist", "path": "highcharts-6.1.0" },
    /* preload-js */
    { "route": "/dist/js", "path": "preloadjs-1.0.0" },
    /* knockout-js */
    { "route": "/dist/js", "path": "knockout-3.4.1" },
    /* pouchdb */
    { "route": "/dist/js", "path": "pouchdb-6.4.3" },
    /* simplebar-js */
    { "route": "/dist", "path": "simplebar-2.6.1" },
    /* creative */
    { "route": "/dist", "path": "creative-1.0.0" },
    /* jquery-easing */
    { "route": "/dist/js", "path": "jquery-easing-1.4.1" },
    /* magnific-popup */
    { "route": "/dist", "path": "magnific-popup-1.1.0" },
    /* scrollreveal */
    { "route": "/dist", "path": "scrollreveal-3.4.0" },
    /* jquery-orgchart */
    { "route": "/dist", "path": "orgchart-2.1.1" },
    /* tabulator */
    { "route": "/dist", "path": "tabulator-3.4.0" },
    /* ui.tabs.overflowResize */
    { "route": "/dist", "path": "ui.tabs.overflow-resize-1.0.0" },
    /* pushy */
    { "route": "/dist", "path": "pushy-1.1.2" },
    /* chosen */
    { "route": "/dist", "path": "chosen-1.8.5" },
    /* jquery-scrolltabs */
    { "route": "/dist", "path": "jquery-scrolltabs-2.0.0" },
    /* jsTree */
    { "route": "/dist", "path": "jstree-3.3.5" },
    /* hierarchy-view */
    //{ "route": "/dist", "path": "hierarchy-view-1.0.0" },
    /* combo-tree */
    { "route": "/dist", "path": "combo-tree-1.0.0" },
    /* select2 */
    { "route": "/dist", "path": "select2-4.0.6" },
    /* org-chart (jquery) */
    { "route": "/dist", "path": "jquery-org-chart-2.1.1" },
    /* json2html 1.2.0 */
    { "route": "/dist/js", "path": "json2html-1.2.0" },
    /* jarallax */
    { "route": "/dist", "path": "jarallax-1.10.3" },
    /* tether */
    { "route": "/dist/", "path": "tether-1.3.3" },
    /* offline.js */
    { "route": "/dist/", "path": "offline-0.7.13" },  
    /* bliss.js */
    { "route": "/dist/", "path": "bliss.js-1.0.5" },  
    /* CAPTCHA */
    { "route": "/dist/", "path": "client-side-captcha-1.0.0" },
    { "route": "/dist/", "path": "js-captcha-1.1.0" },
    { "route": "/dist/", "path": "puzzle-captcha-1.0.0" },
    /* paper.js */
    { "route": "/dist/", "path": "paperjs-0.11.5" },
    /* fabric.js */
    { "route": "/dist/", "path": "fabricjs-2.3.0" },
    /* scroll magic */
    { "route": "/dist/", "path": "scroll-magic-2.0.5" },
    /* snap.js */
    { "route": "/dist/", "path": "snapjs-1.9.2" },
    /* reveal */
    { "route": "/dist", "path": "reveal-3.6.0" }
];

function dist_lib(app, exportRoute, localPath) {
    console.log('publish "' + localPath + '"');
    app.use(exportRoute, express.static(path.join(distPath, localPath), distMaxAge));
};

/**
 * init common paths.
 * 
 * @param {express} app
 */
function init_functions(app) {
    console.log('init common paths....');
    // common lib paths.
    app.use('/lib', express.static(commonPath, libMaxAge));
    // public paths.
    app.use('/public', express.static(publicPath));

    // public->assets paths.
    app.use('/images', express.static(imagePath));
    app.use('/videos', express.static(videoPath));
    app.use('/audios', express.static(audioPath));

    // dist paths.
    dist_libs.forEach(element => {
        dist_lib(app, element.route, element.path);
    });
};

exports.init = init_functions;