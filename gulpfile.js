const gulp = require('gulp')

const paths = {
  src: [
    'etc/**/*'
  ],
  dest: 'build'
}

gulp.task('default', ['install'])

gulp.task('install', () => (
  gulp.src(paths.src)
    .pipe(gulp.dest(paths.dest))
))
