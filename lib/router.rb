require_relative 'renders'

APPS_PATH=File.expand_path("../apps", __dir__)

class Object #:nodoc:
  def meta_def(m,&b) #:nodoc:
    (class<<self;self end).send(:define_method,m,&b)
  end
end

class String
  def snakecase
     gsub(/(?<=[a-z])([A-Z])/){|m| '_'+m.downcase}.downcase
  end
  def camelcase
    split('_').map(&:capitalize).join
  end
end

class Router
  
  @routes = Hash.new([])
  @apps = []
  
  class << self
    def apps() = @apps
    def routes() = @routes
    def status() = @status||=200
    def status=(code)
      @status=code
    end
  end
  
  def initialize
      Dir[
        File.expand_path(
          File.join(APPS_PATH, "*.rb"), 
          __dir__
        )
      ].each{ |a| require a }
  end

  def _call(env)
    @env = env
    @req = Rack::Request.new @env
    res = Rack::Response.new
    self.class.status = res.status
    
    controller,_ = self.class.apps.detect{|c, _| c.path_pattern.match @req.path_info }
    
    return controller.call(env) if controller   
    (self.class.status = 404 ) && NotFound.call(env)   
  end

  def call(env) = dup._call(env)
end

def R(url)
    # controller class and route
    Class.new {
      def self.call(env)
        m = env['REQUEST_METHOD'].downcase.to_sym
        @body = self.send(m, env)
        [Router.status, {'Content-Type' => 'text/html'}, ["#{@body}"]]
      end
      meta_def(:path_pattern){/^#{url}$/}
      meta_def(:path){ url }
      meta_def(:inherited){|x| 
        norm_name = x.to_s.snakecase
        Router.routes[url] = [x, File.join(APPS_PATH, norm_name)] 
        Router.apps << [x, File.join(APPS_PATH, norm_name)] 
      }
    }
end
