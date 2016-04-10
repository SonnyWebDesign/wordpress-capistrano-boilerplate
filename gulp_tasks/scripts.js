const gulp = require('gulp');

const sourcemaps = require('gulp-sourcemaps');
var concat = require('gulp-concat');
const uglify = require('gulp-uglify');
const conf = require('../gulp.conf');

gulp.task('scripts', scripts);
gulp.task('scripts:dev', scriptsDev);

function scripts() {
  return gulp.src([
    conf.path.themeDir('/scripts/main.js'),
    conf.path.themeDir('/scripts/index.js')
  ])
    .pipe(concat('main.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest(conf.path.distDir('/scripts')));
}

function scriptsDev() {
  return gulp.src(conf.path.themeDir('/scripts/*.js'))
    // .pipe(eslint())
    // .pipe(eslint.format())
    // .pipe(babel())
    .pipe(gulp.dest(conf.path.distDir('/scripts')));
    // .pipe(gulp.dest(conf.path.tmpDir('/scripts')));
}
