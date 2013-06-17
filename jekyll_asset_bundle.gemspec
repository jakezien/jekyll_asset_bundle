Gem::Specification.new do |s|
  s.name         = 'jekyll_asset_bundle'
  s.version      = '0.0.1'
  s.date         = Time.now
  s.summary      = "CSS and JS asset bundler for Jekyll"
  s.description  = "Get revisioned, concat, and minified css and js files for production; develop with Stylus and normal JS."
  s.authors      = 'floored'
  s.email        = 'github@floored.com'
  s.files        = Dir["{lib}/**/*.rb", "*.md"]
  s.license      = 'MIT'
  s.homepage     = 'http://floored.com/blog'

  s.add_runtime_dependency 'jekyll', '>= 0.12'
  s.add_runtime_dependency 'liquid', '~> 2.4'
  s.add_runtime_dependency 'uglifier', '>=2.0'
  s.add_runtime_dependency 'stylus', '>=0.7'
end