class NotFound < R '/404'
  def get(env)
    ['Oops! Nothing to see here', self.class.path_pattern, env.to_s].join("<br />")
  end
end
