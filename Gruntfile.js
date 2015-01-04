module.exports = function (grunt) {

  // Load grunt tasks automatically
  require('load-grunt-tasks')(grunt);

  // Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt);

  grunt.initConfig({
      mxmlc: {
        options: {
          rawConfig: '+configname=air'
        },
        swf: {
          files: {
            'dist/recorder.swf': ['src/Recorder.as']
          }
        }
      },

      copy: {
          dist: {
              files: [
                  {
                      dest: 'dist/',
                      src: [
                          'swfobject.js',
                          'record.html'
                      ]
                  },
                  {
                      expand: true,
                      cwd: 'libs/mediaelement/build/',
                      dest: 'dist/',
                      src: [
                          'mediaelement-and-player.min.js',
                          'mediaelementplayer.min.css',
                          'jquery.js',
                          'flashmediaelement.swf',
                          'controls.svg',
                          'bigplay.png',
                          'controls.png'
                      ]
                  }
              ]
          }
      }
  });

  grunt.registerTask('default', [
    'mxmlc:swf', 'copy:dist'
  ]);
};
