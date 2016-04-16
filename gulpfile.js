var gulp = require('gulp');

const livereload = require('gulp-livereload');
// const fs = require('node-fs');
// const fse = require('fs-extra');
const del = require('del');
const conf = require('./gulp.conf');
const requireDir = require('require-dir');
const runSequence = require('run-sequence');
// const browserSync = require('browser-sync');

requireDir('./gulp_tasks');

gulp.task('clean', clean);
gulp.task('watch', watch);

gulp.task('default', ['clean'], function(cb) {
  runSequence(
    'clean',
    ['styles:dev', 'scripts:dev'],
    'images',
    cb
  )
});

gulp.task('build', ['clean'], function(cb) {
  runSequence(
    'clean',
    ['styles', 'scripts'],
    'images',
    cb
  )
});

// gulp.task('init', ['clean'], function() {
  // fs.mkdirSync(conf.path.distDir(), 0755);
  // fse.copySync('theme-boilerplate', themeDir + '/');
// });

function clean() {
  return del([
    conf.path.distDir(),
    conf.path.tmpDir()
  ]);
}

function copy() {
  return gulp.src(conf.path.themeDir('/*.*'))
    .pipe(gulp.dest(conf.path.distDir()));
}

function watch(done) {
  livereload.listen();

  gulp.watch(conf.path.themeDir('/sass/**/*.scss'), ['styles:dev']);
  gulp.watch(conf.path.themeDir('/scripts/**.js'), ['scripts:dev']);
  gulp.watch(conf.path.themeDir('/images/*.{png,jpg,gif}'), ['images']);
  gulp.watch(conf.path.themeDir('/*.*'), ['copy']);
}
