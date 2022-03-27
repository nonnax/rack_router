class Default < R '/params/:id'
  def self.get(params)
    @params=params
    markup = 'Hi {{name}}!'
    @data = {:name => 'Nonnax'}
    @html = Mustache.render markup, @data
    # erb :html
    erb :default
  end
end
