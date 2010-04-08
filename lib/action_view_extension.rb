# Auto scoping for ActionView
module ActionView
  class Base
    alias_method :i18n_auto_scoping_aliased_render, :render

    # To set a default scope for all render
    def render(opts = {}, *args)
      old_auto_scope_in_render = Thread.current[:last_i18n_auto_scope_render_in_render]
      old_auto_scope = Thread.current[:last_i18n_auto_scope_render]
      Thread.current[:last_i18n_auto_scope_render_in_render] = true
      Thread.current[:last_i18n_auto_scope_render] = nil

      i18n_auto_scoping_aliased_render(opts, *args)
    ensure
      Thread.current[:last_i18n_auto_scope_render] = old_auto_scope
      Thread.current[:last_i18n_auto_scope_render_in_render] = old_auto_scope_in_render
    end
  end
end