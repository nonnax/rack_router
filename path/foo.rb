class Foo
  def self.call(env)
    [200, {'Content-Type' => 'text/plain'}, ['foo']]
  end
end
