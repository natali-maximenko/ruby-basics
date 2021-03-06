Gem::Specification.new do |s|
  s.name         = 'cinema'
  s.version      = '1.0.0'
  s.summary      = 'module Cinema'
  s.description  = 'lib emulate the behavior of two types of cinemas: Netflix (online theater) and Theatre (movie house)'
  s.author       = ['Natalia Maximenko']
  s.email        = ['natali.maximenko@gmail.com']
  s.homepage     = 'http://github.com/natali-maximenko/ruby-basics'
  s.license      = 'MIT'

  s.files        = Dir["{lib}/**/*.rb", "{lib}/**/templates/*", "bin/*", "*.md", '.rspec']
  s.require_path = 'lib'
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^spec/})

  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'timecop'

  s.add_runtime_dependency 'money'
  s.add_runtime_dependency 'virtus'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'themoviedb-api'
end
