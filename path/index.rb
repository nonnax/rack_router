require 'mustache'

class Index
  def self.call(env)
    markup = 'Hi {{name}}!'
    data = {:name => 'Nald'}
    html = Mustache.render markup, data
    [200, {'Content-Type' => 'text/html'}, [html]]
  end
end
