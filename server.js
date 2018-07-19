const path = require('path');
// setup root path.
process.env['ROOT_PATHS'] = path.dirname(require.main.filename);
const rootPath = process.env['ROOT_PATHS'];
const libPath = path.join(rootPath, 'lib');
