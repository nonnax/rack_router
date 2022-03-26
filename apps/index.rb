class Index < R '/'
  def self.get(env)
    markup = 'Hi {{name}}!'
    data = {:name => 'Nald'}
    @html = Mustache.render markup, data
    erb :html
  end
end
