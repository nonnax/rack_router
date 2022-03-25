require 'mustache'

class Default < R
  def get(env)
    @env=env
    markup = 'Hi {{name}}!'
    data = {:name => 'Nonnax'}
    html = Mustache.render markup, data
    [html, self.class]
  end
end
