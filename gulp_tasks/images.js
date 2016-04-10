const gulp = require('gulp');

const imagemin = require('gulp-imagemin');
const conf = require('../gulp.conf');

gulp.task('images', images);

function images() {
  gulp.src(conf.path.themeDir('/images/*.{png,jpg,gif}'))
    .pipe(imagemin({
      optimizationLevel: 7,
      progressive: true
    }))
    .pipe(gulp.dest(conf.path.distDir('/images')));
}
