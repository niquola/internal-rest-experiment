class Scheduling
  autoload :Service, 'scheduling/service'
  autoload :ServicesRepository, 'scheduling/services_repository'
  autoload :Responce, 'scheduling/responce'
  autoload :Resource, 'scheduling/resource'
  autoload :ResourceRepository, 'scheduling/resource_repository'
  autoload :Resty, 'scheduling/resty'
  include Resty

  def get_services(params)
    Responce.new.tap do |resp|
      resp.status = :ok
      resp.services = ServicesRepository.all
    end
  end

  def post_services(attrs)
    resp = Responce.new

    unless attrs[:code]
      return unprocessable_entity(['code attribute required'])
    end

    service = Service.new({id: uuid}.merge(attrs))
    ServicesRepository.save(service)
    created(service)
  end

  def get_service_resources(service_id)
    ok(ResourceRepository.for_service(service_id))
  end

  def post_resources(attrs)
    resource = Resource.new({id: uuid}.merge(attrs))
    ResourceRepository.save(resource)
    created(resource)
  end

  def post_appointments(attrs)
    created(true)
  end

  def get_appointments(filter)
    ok([])
  end
end
