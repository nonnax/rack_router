class NotFound
  def self.call(env)
    [404, {'Content-Type' => 'text/html'}, ['Not Found']]
  end
end
