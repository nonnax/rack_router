#!/usr/bin/env ruby
# Id$ nonnax 2022-03-24 18:32:19 +0800
require 'erb'
require 'mustache'

module Renders
  def erb(view)
      render(view)
  end

  def render(view, layout: :layout)
    # __dir__ is a special method that always return the current file's directory.
    templates = []
    templates << File.expand_path("../views/#{view}.erb", __dir__)
    templates << File.expand_path("../views/#{layout}.erb", __dir__)
    
    templates.inject("") do |doc, f|
      _render(f){doc}
    end
  end
  
  def _render(f)
    # Here the binding is a special Ruby method, basically it represents
    # the context of current object self, and in this case, the Franky instance.
    #
    ERB.new( File.read(f) ).result( binding )
  end
end

include Renders
