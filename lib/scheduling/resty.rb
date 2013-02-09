class Scheduling
  module Resty
    def get(path, params = {})
      path = [path] unless path.is_a?(Enumerable)
      self.send("get_#{path.join('_')}", params)
    end

    def post(path, params = {})
      path = [path] unless path.is_a?(Enumerable)
      self.send("post_#{path.join('_')}", params)
    end

    private

    def created(entity)
      resp = Responce.new
      resp.status = :created
      resp.entity = entity
      resp
    end

    def unprocessable_entity(errors)
      resp = Responce.new
      resp.status = :unprocessable_entity
      resp.errors = errors
      resp
    end

    def ok(entity)
      resp = Responce.new
      resp.status = :ok
      resp.entity = entity
      resp
    end

    def uuid
      UUID.generate
    end
  end
end
