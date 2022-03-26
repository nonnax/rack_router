class Default < R '/def'
  def self.get(env)
    @env=env
    markup = 'Hi {{name}}!'
    @data = {:name => 'Nonnax'}
    html = Mustache.render markup, @data
    erb :index
  end
end
