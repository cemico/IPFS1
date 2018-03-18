/** Created by daverogers on 3/15/18. */

// create reference to gulp
var gulp = require('gulp');

// reference to gulp-nodemon
var nodemon = require('gulp-nodemon');

var gulpPort = 8005

// create task
gulp.task('default', function () {

    // input is json object telling it how to run
    nodemon({
        script: 'App.js',                   // script to run
        ext: 'js',                          // look for all .js files for change
        env: {
            PORT: gulpPort                  // note: different than app.js to demonstrate being pulled from here
        },
        ignore: ['./node_modules/**']       // ignore all these

    }).on('restart', function (){
        console.log('Restarting');
    });
});