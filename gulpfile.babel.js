import gulp from 'gulp'

const paths = {
  src: [
    'etc/**/*'
  ],
  dest: 'dist'
}

export const install = () => (
  gulp.src(paths.src)
    .pipe(gulp.dest(paths.dest))
)

export default install
