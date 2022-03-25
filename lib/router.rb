require_relative 'renders'

def R( path_match, **params)
    klass=Class.new do
      def self.call(env)
        m=env['REQUEST_METHOD'].downcase.to_sym
        @body=new.send(m, env)
        [200, {'Content-Type' => 'text/html'}, ["#{@body}"]]
      end
    end
    eval %{
      def klass.path_pattern
          [ '#{path_match}' ,  #{params} ] 
      end
    }
    klass
end

class Klass
  @@routes = {}
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
    @env = env
    @req=Rack::Request.new @env
    @res=Rack::Response.new
    # Lookup path in routes hash.
    # path = env['PATH_INFO']
    # return /path and file path or /not_found and not_found
    resolved_route, real_path = @@routes.fetch(@req.path_info, @@routes['/not_found'])
    # Load controller definition.
    require_relative real_path
    # Resolve controller's class name. e.g. class_name to ClassName
    class_name = resolved_route.split('_').map(&:capitalize).join
    
    controller=Kernel.const_get(class_name)
    # Controller must respond to call and return a string obj
    controller.call(env)
  end
  def call(env)
    dup._call(env)
  end
end

