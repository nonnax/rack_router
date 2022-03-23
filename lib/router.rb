class Router
  def initialize
    globbed=Dir[
      File.join(Dir.pwd, "path/*.rb")
    ]
    
    @routes = {}
    
    globbed.reject!{|e| e.match?(/__FILE__/) }
    
    globbed.inject(@routes){|acc, r| 
      path, ext = File.basename(r).split('.')
      key = path.match?(/index/) ? '/' : "/#{path}"
      acc[key] = [path, r.rpartition('.').first]
      acc
    }
    @routes
  end

  def call(env)
    # Lookup path in routes hash.
    path = env['PATH_INFO']
    # if @routes[path] is empty, in which case, default to @routes['/not_found']
    resolved_route, real_path = @routes.fetch(path, @routes['/not_found'])
    # Load controller definition.
    require_relative real_path
    # Resolve controller's class name, eg '/foo : foo' --> "Foo".
    # filename to class name: snake_case to SnakeCase.
    classified_name = resolved_route.split('_').map(&:capitalize).join
    # Controller must be a valid Rack app.
    Kernel.const_get(classified_name).call env
  end
end
