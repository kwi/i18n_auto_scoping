require 'rubygems'
require 'spec'

require 'i18n'
require 'action_controller'
require 'action_view'

# Add I18n load_path
I18n.load_path = (I18n.load_path << Dir[File.join(File.dirname(__FILE__), 'locales', '*.yml')]).uniq

require File.dirname(__FILE__) + '/../init.rb'

class FakeController
  def self.method_missing(meth)
    return nil
  end

  def params
    {:controller => :fake, :action => :show}
  end
end