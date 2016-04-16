'use strict';

const path = require('path');
const json = require('json-file');

const src = 'content';
const themeName = json.read('./package.json').get('themeName');

const paths = {
  src: src,
  tmpDir: '.tmp',
  themeName: themeName,
  themeDir: './theme-dev',
  distDir: path.join(src, '/themes/', themeName)
};

exports.paths = paths;

exports.path = {};

for (let pathName in exports.paths) {
  exports.path[pathName] = function pathJoin() {
    const pathValue = exports.paths[pathName];
    const funcArgs = Array.prototype.slice.call(arguments);
    const joinArgs = [pathValue].concat(funcArgs);

    return path.join.apply(this, joinArgs);
  }
}
