class Foo < R '/foo'
  def get(env)
    p self.class
    erb :index
  end
end
