class NotFound < R
  def get(env)
    'Oops! Nothing to see here'+env.to_s
  end
end
