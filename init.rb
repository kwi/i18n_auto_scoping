# encoding: utf-8
require File.join(File.dirname(__FILE__), 'lib', 'i18n_auto_scoping.rb')

if defined? ActionView
  require File.join(File.dirname(__FILE__), 'lib', 'action_view_extension.rb')
end

I18n.send :include, I18nAutoScoping::I18nExtension
I18n.extend_backend_for_i18n_auto_scoping

# Auto namespacing default in controller : controllers/controller_name
if defined? ActionController
  ActionController::Base.send :include, I18nAutoScoping::ActionControllerDefaultScope
  ActionController::Base.send :before_filter, :set_default_i18n_scope
end