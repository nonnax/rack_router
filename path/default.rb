require 'mustache'

class Default
  def self.call(env)
    markup = 'Hi {{name}}!'
    data = {:name => 'Nonnax'}
    html = Mustache.render markup, data
    [200, {'Content-Type' => 'text/html'}, [html]]
  end
end
