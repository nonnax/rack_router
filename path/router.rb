class Router
  def initialize
    globbed=Dir[
      File.join(File.dirname(__FILE__), "*.rb")
    ]
    
    @routes = {}
    
    globbed.reject!{|e| e.match?(__FILE__) }
    
    globbed.inject(@routes){|acc, r| 
      fname, ext = File.basename(r).split('.')
      key = fname.match?(/index/) ? '/' : "/#{fname}"
      acc[key] = fname
      acc
    }
    p @routes
  end

  def call(env)
    # Lookup path in routes hash.
    path = env['PATH_INFO']
    # ... path is empty, in which case, default to root
    path = '/' if path.empty?
    resolved_route = @routes.fetch(path, 'not_found')
    # Load controller definition.
    require_relative resolved_route
    # Resolve controller's class name, eg '/foo : foo' --> "Foo".
    classified_name = resolved_route.split('_').map(&:capitalize).join
     class_name = classified_name
    # Controller must be a valid Rack app.
    Kernel.const_get(class_name).call env
  end
end
