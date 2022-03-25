class Foo < R
  def get(env)
    p self.class
    erb :index
  end
end
