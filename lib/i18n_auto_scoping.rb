module I18nAutoScoping
  module ActionControllerDefaultScope

    def set_default_i18n_scope
      I18n::Scope.default = "controllers/#{params[:controller]}"
    end

  end
  
  module I18nExtension

    def self.included(mod)
      mod.class_eval do
        class << self
          alias_method :i18n_auto_scoping_backend=, :backend=
        
          def backend=(backend)
            r = i18n_auto_scoping_backend=(backend)
            # When assigning a new backend, we try to extend it :
            extend_backend_for_i18n_auto_scoping
            r
          end

          def extend_backend_for_i18n_auto_scoping
            # Only extend the backend for auto scoping if it had not been already done
            if !backend.methods.include?('i18n_auto_scoping_translate')
              backend.extend ::I18nAutoScoping::BackendExtension
            end

          end
        end
      
      end
    end

  end

  module BackendExtension

    def self.extended(k)
      k.class_eval do
        alias_method :i18n_auto_scoping_translate, :translate
        
        # Override translate method in order to set autoscoping
        def translate(locale, key, options = {})
          # Set the default scope if needed
          if !options.has_key?(:scope) or options[:scope] == :autoscoping
            options[:scope] = I18n::Scope.default 
          end
          i18n_auto_scoping_translate(locale, key, options)
        end
      end
    end

  end
end

#i18n extension for having default namespacing
module I18n
  module Scope
    class << self
      # Set a default scope
      def default=(scope)
        Thread.current[:i18n_default_scope] = (scope.is_a?(String)) ? scope.gsub('/', '.') : scope
      end

      def default
        # Temporarly default scope go first
        return Thread.current[:i18n_temporarly_default_scope] if Thread.current[:i18n_temporarly_default_scope]
        
        # Then, if we are in a render, we try to get the current scope by scanning the caller stack
        if Thread.current[:last_i18n_auto_scope_render_in_render]
          # Cache the analyse of the caller stack result for performance
          return (Thread.current[:last_i18n_auto_scope_render] ||= get_scope_views_context)
        end

        # Finally, if there is no scope before, return the default scope
        Thread.current[:i18n_default_scope]
      end

      # Inspired from : http://github.com/yar/simple_loc_compat
      # Return the current view file, only work in app/views folder
      def get_scope_views_context
        stack_to_analyse = caller
        latest_app_file = caller.detect { |level| level =~ /.*\/app\/views\// }
        return nil unless latest_app_file
        
        scope = latest_app_file.match(/([^:]+):\d+.*/)[1]
        path = scope.split('/app/views/').last
        scope = File.basename(path, File.extname(path))
        # If there is a second extension we keep it, in order to work with .erb.html or .erb.iphone, etc...
        scope = "#{File.dirname(path)}/#{scope}" if File.dirname(path) != '.'

        scope.gsub!('/', '.')

        scope.to_sym
      end

      def temporarly_change(scope)
        old = Thread.current[:i18n_temporarly_default_scope]
        Thread.current[:i18n_temporarly_default_scope] = scope
        r = yield
        Thread.current[:i18n_temporarly_default_scope] = old
        return r
      end
    end
  end
end