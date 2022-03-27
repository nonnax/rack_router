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
  HEADERS_DEFAULT={'Content-type' => 'text/html; charset=UTF-8'}
  @@apps = []
  @@status = 200
  @@headers = HEADERS_DEFAULT

  def apps = @@apps
  def headers = @@headers
  def status( x = nil )
    @@status = x if x
    @@status
  end 
end

class Router
  extend Serves
  
  def initialize
      Dir[
        File.expand_path(
          File.join( APPS_PATH, "*.rb" ), 
          __dir__
        )
      ].each{ |f| require f } # fires R controller creation
  end

  def _call(env)
    controller,_ = self.class.apps.detect{|c, _| c.path_pattern.match( env['PATH_INFO'] ) }
    return controller.call(env) if controller
    self.class.status(404) && NotFound.call(env)
  end

  def call(env) = dup._call(env)
end

def R(url)
    # handles controller creation and router collection
    apps = Serves.apps
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
