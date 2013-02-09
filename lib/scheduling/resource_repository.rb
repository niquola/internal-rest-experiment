class Scheduling::ResourceRepository
  class << self
    def resources
      @resources ||= {}
    end
    def all
      resources.values
    end

    def save(resource)
      resources[resource.id] = resource
    end

    def for_service(service_id)
      resources.values
    end
  end
end
