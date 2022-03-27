require_relative 'renders'
require_relative 'path_helpers'

include PathHelpers

APPS_PATH=File.expand_path("../apps", __dir__)

class Object #:nodoc:
  def meta_def(m,&b) = (class<<self;self end).send(:define_method,m,&b)
end

class Router
  attr_accessor :status, :headers, :res, :req, :env
  HEADERS_DEFAULT={'Content-type' => 'text/html; charset=UTF-8'}
  @@apps = []
  
  def self.apps = @@apps
  
  def initialize
      Dir[
        File.expand_path(
          File.join( APPS_PATH, "*.rb" ), 
          __dir__
        )
      ].each{ |f| require f } # fires R controller creation      
    @req=Rack::Request.new env
    @res=Rack::Response.new
  end

  def _call(env)
    @req=Rack::Request.new env
    @res=Rack::Response.new
    
    self.class
    .apps
    .detect{|c| c.path_pattern.match( req.path_info ) }
    .then{ |controller| 
      controller ||= NotFound
      res.status=404 if controller==NotFound

      extra_params=controller.extra_params.zip(Regexp.last_match.captures).to_h rescue {}
      req.params.merge!(extra_params)
      res.write controller.send(req.request_method.downcase.to_sym, req.params)
    }
    res.finish
  end

  def call(env) = dup._call(env)
end

def R(url)
    # handles controller creation and router collection
    compile_path_params(url) => [path_pattern, extra_params]
    Class.new {
      meta_def(:path){ url }
      meta_def(:path_pattern){ %r{^#{path_pattern}/?$} }
      meta_def(:extra_params){ extra_params }
      meta_def(:inherited){|x| Router.apps << x }
    }
end
