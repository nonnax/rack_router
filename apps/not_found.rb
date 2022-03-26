class NotFound < R '/404'
  def self.get(env)
    ['Oops! Nothing to see here', self.path_pattern, env.to_s].join("<br />")
  end
end
