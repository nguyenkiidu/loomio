yaml    = require('node-yaml-config')
vendor  = yaml.reload('tasks/config/vendor.yml')
glob    = require 'globby'
_       = require 'lodash'

plugins = try
  yaml.reload('tasks/config/plugins.yml')
catch
  {}

include = (file, key, p = file.path) ->
  _.map(file[key], (path) -> _.compact([p, path]).join('/'))

module.exports =
  angular:
    root:      'angular'
    main:      'angular/main.coffee'
    folders:
      vendor:     include(vendor, 'angular', '')
      config:     glob.sync('angular/config/*.coffee')
      pages:      glob.sync('angular/pages/**/*.coffee')
      components: glob.sync('angular/components/**/*.coffee')
      templates:   _.flatten([
        'angular/components/**/*.haml',
        'angular/pages/**/*.haml',
        include(plugins, 'haml')
      ])
    dependencies:
      folder:     'angular/dependencies'
      vendor:     'angular/dependencies/vendor.coffee'
      config:     'angular/dependencies/config.coffee'
      pages:      'angular/dependencies/pages.coffee'
      components: 'angular/dependencies/components.coffee'
    vendor:    include(vendor, 'angular', '') # don't force a prefix, since these will be required into the bundle
    plugin:    include plugins, 'coffee'
    scss: _.flatten([
      include(vendor, 'css'),
      'angular/css/app.scss',
      'angular/components/**/*.scss',
      'angular/pages/**/*.scss',
      include(plugins, 'scss')
    ])
    scss_include: _.flatten([
      include(vendor, 'css_includes'),
      'angular/css'
    ])

  shared:
    coffee:       'shared/**/*.coffee'
    emojis:         include(vendor, 'emoji')
    moment_locales: include(vendor, 'moment_locales')
    fonts:          include(vendor, 'fonts')

  execjs:
    main:           'execjs/main.coffee'

  dist:
    fonts:          '../public/client/fonts'
    assets:         '../public/client/development'
    emojis:         '../public/img/emojis'
    moment_locales: '../public/client/development/moment_locales'

  vue:
    main:           'vue/main.coffee'
    vue:            'vue/components/*.vue'

  protractor:
    config:       'angular/test/protractor.coffee'
    screenshots:  'angular/test/protractor/screenshots'
    specs:
      core:        'angular/test/protractor/*_spec.coffee'
      plugins:     ['../plugins/**/*_spec.coffee', 'angular/test/protractor/testing_spec.coffee']
