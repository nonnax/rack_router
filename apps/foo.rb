class Foo < R '/foo'
  def self.get(env)
    p self.class
    erb :index
  end
end
