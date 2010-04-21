Gem::Specification.new do |s|
  s.name = "i18n_auto_scoping"
  s.version = "0.2.1"
  s.author = "Guillaume Luccisano"
  s.email = "guillaume.luccisano@gmail.com"
  s.homepage = "http://github.com/kwi/i18n_auto_scoping"
  s.summary = "I18nAutoScoping lets you easily add auto-scope in your I18n translations for your Rails' views."
  s.description = "I18nAutoScoping is a plugin for Ruby on Rails that lets you easily add auto-scope in your I18n translation. It is very useful if you do not want to add every time the scope in your views ! Especially if your are working on big projects !"

  s.add_dependency('i18n', '> 0.3.5')

  s.files = Dir["{rails,lib,spec}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end