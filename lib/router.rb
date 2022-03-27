require_relative 'renders'

APPS_PATH=File.expand_path("../apps", __dir__)

class Object #:nodoc:
  def meta_def(m,&b) = (class<<self;self end).send(:define_method,m,&b)
end

class String
  def snakecase = gsub(/(?<=[a-z])([A-Z])/){|m| '_'+m.downcase}.downcase
  def camelcase =  split('_').map(&:capitalize).join
end

module Serves
  extend self
  HEADERS_DEFAULT='Content-type: text/html; charset=UTF-8'
  @@req=nil
  @@res=Rack::Response.new
  @@status=200
  def req = @@req
  def req(x) = @@req=x
  def res = @@res
  def res(x) = @@res=x
  def status = @@status
  def status(x) = @@res.status = @@status =x
  def headers = @@res.headers || HEADERS_DEFAULT
  def headers(x) = @@res.headers = x
end

class Router
  extend Serves
  @routes = Hash.new([])
  @apps = []
  
  class << self
    def apps = @apps
    def status = @status||=200
    def status=(code)
      @status=code
    end
  end

  # def apps = self.class.apps
  # def status = self.class.status
    
  def initialize
      Dir[
        File.expand_path(
          File.join( APPS_PATH, "*.rb" ), 
          __dir__
        )
      ].each{ |f| require f } # fires R controller creation
  end

  def _call(env)
    @env = env
    self.req = Rack::Request.new @env
    p 'self.res = Rack::Response.new'
    p self.res = Rack::Response.new

    controller,_ = self.class.apps.detect{|c, _| c.path_pattern.match( req.path_info) }
    
    return controller.call(env) if controller   
    self.status(404) && NotFound.call(env)   
  end

  def call(env) = dup._call(env)
end

def R(url)
    # handles controller creation and router collection
    apps = Router.apps
    Class.new {
      extend Serves
      def self.call(env)
        m = env['REQUEST_METHOD'].downcase.to_sym
        body = self.send(m, env)
        [ self.status, self.headers, ["#{body}"] ]
      end
      meta_def(:path_pattern){/^#{url}$/}
      meta_def(:path){ url }
      meta_def(:inherited){|x| apps << x }
    }
end
