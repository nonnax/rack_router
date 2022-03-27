class Foo < R '/foo'
  def self.get(params)
    @params=params    
    erb :foo
  end
end
