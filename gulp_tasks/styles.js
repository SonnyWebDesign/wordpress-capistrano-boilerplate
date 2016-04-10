const gulp = require('gulp');

const sourcemaps = require('gulp-sourcemaps');
const sass = require('gulp-sass');
const cssnano = require('gulp-cssnano');
const livereload = require('gulp-livereload');
const conf = require('../gulp.conf');

var AUTOPREFIXER = [
  'last 2 versions',
  'safari >= 7',
  'ie >= 9',
  'ff >= 30',
  'ios 6',
  'android 4'
];

gulp.task('styles', styles);
gulp.task('styles:dev', stylesDev);

function styles() {
  gulp.src(conf.path.themeDir('/sass/**/*.scss'))
    .pipe(sourcemaps.init())
    .pipe(sass({
      outputStyle: 'compressed'
    }).on('error', sass.logError))
    .pipe(cssnano({
      discardComments: {removeAll: true},
      autoprefixer: AUTOPREFIXER,
      safe: true
    }))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest(conf.path.distDir('/sass')));
}

function stylesDev() {
  gulp.src(conf.path.themeDir('/sass/**/*.scss'))
    .pipe(sass({
      outputStyle: 'expanded',
      sourceComments: true
    }).on('error', sass.logError))
    .pipe(gulp.dest(conf.path.distDir('/sass')))
    // .pipe(gulp.dest(conf.path.tmpDir('/sass')))
    .pipe(livereload());
}
