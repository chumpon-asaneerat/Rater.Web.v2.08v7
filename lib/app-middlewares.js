// common requires
//const express = require('express');
const path = require('path');

const favicon = require('serve-favicon');

const logger = require('morgan');

const helmet = require('helmet');

const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');

//const session = require('express-session');
//const passport = require('passport');
//const Strategy = require('passport-local').Strategy;

const stylus = require('stylus');
const nib = require('nib');

const exphbs = require('express-handlebars');
const hbs = exphbs.create();

const Fingerprint = require('express-fingerprint')

//const rootPath = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];

const publicPath = path.join(rootPath, 'public');
const viewPath = path.join(rootPath, 'views');

/**
 * setup view engine.
 * 
 * @param {express} app
 */
function init_view_engine(app) {
    // view engine setup
    app.set('views', viewPath);
    //app.set('view engine', 'pug');
    //app.set('view engine', 'ejs');
    app.engine('handlebars', hbs.engine)
    app.set('view engine', 'handlebars');
};

/**
 * setup favicon.
 * 
 * @param {express} app
 */
function init_favicon(app) {
    // if change favicon.ico required to restart server.
    app.use(favicon(path.join(publicPath, 'favicon.ico')));
    //app.use(favicon(path.join(publicPath, 'favicon.ico'), { maxAge: '15s' }));
};

/**
 * setup logger.
 * 
 * @param {express} app
 */
function init_logger(app) {    
    app.use(logger('dev'));
};

/**
 * setup helmet.
 * 
 * @param {express} app
 */
function init_helmet(app) {
    app.use(helmet());
};

/**
 * setup express session.
 * 
 * @param {express} app
 */
function init_session(app) {
    app.use(session({ 
        secret: 'keyboard cat', 
        resave: false, 
        saveUninitialized: false
    }));
};

/**
 * setup passport.
 * 
 * @param {express} app
 */
function init_passport(app) {
    // See: https://github.com/passport/express-4.x-local-example
    /*
    // Configure the local strategy for use by Passport.
    //
    // The local strategy require a `verify` function which receives the credentials
    // (`username` and `password`) submitted by the user.  The function must verify
    // that the password is correct and then invoke `cb` with a user object, which
    // will be set at `req.user` in route handlers after authentication.
    passport.use(new Strategy(
        function (username, password, cb) {
            db.users.findByUsername(username, function (err, user) {
                if (err) {
                    return cb(err);
                }
                if (!user) {
                    return cb(null, false);
                }
                if (user.password != password) {
                    return cb(null, false);
                }
                return cb(null, user);
            });
        }));
    // Configure Passport authenticated session persistence.
    //
    // In order to restore authentication state across HTTP requests, Passport needs
    // to serialize users into and deserialize users out of the session.  The
    // typical implementation of this is as simple as supplying the user ID when
    // serializing, and querying the user record by ID from the database when
    // deserializing.
    passport.serializeUser(function (user, cb) {
        cb(null, user.id);
    });

    passport.deserializeUser(function (id, cb) {
        db.users.findById(id, function (err, user) {
            if (err) {
                return cb(err);
            }
            cb(null, user);
        });
    });

    // Initialize Passport and restore authentication state, if any, from the
    // session.
    app.use(passport.initialize());
    app.use(passport.session());
    */
};

/**
 * setup parsers.
 * 
 * @param {express} app
 */
function init_parsers(app) {
    // body parser.
    app.use(bodyParser.json());
    // extended must be false??.
    app.use(bodyParser.urlencoded({ extended: true }));
    // cookie parser.
    app.use(cookieParser());
};

/**
 * setup express fingerprint.
 * 
 * @param {express} app
 */
function init_fingerprint(app) {
    app.use(Fingerprint({
        parameters: [
            // Defaults
            Fingerprint.useragent,
            Fingerprint.acceptHeaders,
            Fingerprint.geoip,
            // Additional parameters
            function (next) {
                // ...do something...
                next(null, {
                    'param1': 'value1'
                })
            },
            function (next) {
                // ...do something...
                next(null, {
                    'param2': 'value2'
                })
            }
        ]
    }))
};

/**
 * setup stylus.
 * 
 * @param {express} app
 */
function init_stylus(app) {
    app.use(stylus.middleware({
        src: publicPath,
        compile: function (str, path) {
            return stylus(str).set('filename', path).use(nib())
        }
    }));
};

/**
 * init common paths.
 * 
 * @param {express} app
 */
function init_functions(app) {
    console.log('init middleware....');

    init_view_engine(app);
    init_favicon(app);
    
    init_logger(app);
    init_helmet(app);    
    init_parsers(app);
    
    //init_session(app);
    //init_passport(app);

    //init_fingerprint(app);
    
    init_stylus(app);
};

exports.init = init_functions;