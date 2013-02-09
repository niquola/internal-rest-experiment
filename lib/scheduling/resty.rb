module Resty
  def get(path, params = {})
    path = [path] unless path.is_a?(Enumerable)
    self.send("get_#{path.join('_')}", params)
  end

  def post(path, params = {})
    path = [path] unless path.is_a?(Enumerable)
    self.send("post_#{path.join('_')}", params)
  end
end
