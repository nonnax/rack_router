require_relative 'renders'

class R
  def self.call(env)
    m=env['REQUEST_METHOD'].downcase.to_sym
    new.send(m, env)
  end
end

class Router 
  def initialize
    apps = Dir[
      File.expand_path("../apps/*.rb", __dir__)
    ]
    
    @@routes = {}
      
    apps.inject(@@routes) do |acc, r| 
      path, ext = File.basename(r).split('.')
      key = path.match?(/index/) ? '/' : "/#{path}"
      acc[key] = [path, r.rpartition('.').first]
      acc
    end
  end

  def _call(env)
    # Lookup path in routes hash.
    path = env['PATH_INFO']
    # if @@routes[path] is empty, in which case, default to @@routes['/not_found']
    resolved_route, real_path = @@routes.fetch(path, @@routes['/not_found'])
    # Load controller definition.
    require_relative real_path
    # Resolve controller's class name, eg /foo : foo --> "Foo".
    # filename to class name: snake_case to SnakeCase.
    class_name = resolved_route.split('_').map(&:capitalize).join
    
    controller=Kernel.const_get(class_name)
    # Controller must respond to call and return a string obj
    @body = controller.call(env)
    finish
  end
  def call(env)
    dup._call(env)
  end
  def finish
    [200, {'Content-Type' => 'text/html'}, ["#{@body}"]]
  end
  
end

