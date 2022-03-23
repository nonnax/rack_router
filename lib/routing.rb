#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2022-03-23 14:17:58 +0800
def R(pattern)
  eval %{
    class BasicObject
      def self.inherited(child)
          child.extend(ClassMethods)
      end
      module ClassMethods
        def path
            @path =  Regexp.new '#{pattern}'
        end
        alias pattern path

        def get &block
            @capture=instance_eval &block if block
            @capture
        end
        def post &block
            @capture=instance_eval &block if block
            @capture
        end

        def call(env={})
          request_method=env['REQUEST_METHOD'].downcase
          p request_path=env['PATH_INFO'].match(pattern)
          body = send request_method
          [200, env, [body]]
        end
      end
      self
    end
  }
end

class Test < R '/home/(\d+)'
  get do
    @path = 'pato'
    "@param = 'parang pato'"
  end
  post do
    @path = 'pato'
    "@param = 'parang PELICAN'"
  end
end

p Test.path
puts Test.pattern
# p Test.get
# p Test.post
p Test.instance_variable_get(:@path)
p Test.instance_variables
env = {'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/'}
p Test.call env
env = {'REQUEST_METHOD' => 'POST', 'PATH_INFO' => '/home/1'}
p Test.call env

