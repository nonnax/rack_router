class Index < R
  def get(env)
    markup = 'Hi {{name}}!'
    data = {:name => 'Nald'}
    @html = Mustache.render markup, data
    erb :html
  end
end
