Gem::Specification.new do |s|
  s.name = 'git-manager'
  s.version = '0.1.0'
  s.summary = 'Git API for Tags'
  s.description = 'An API to retrieve the latest git tag for deployment.'
  s.authors = ['AJLA-TS']
  s.email = 'david.butts@ks.gov'
  s.files = ['lib/git-manager.rb']
  s.homepage = 'https://github.com/ajla-ts/git-manager'

  s.add_runtime_dependency 'git', '~> 1.8'
  s.add_development_dependency 'rspec', '~> 3.10'
end
