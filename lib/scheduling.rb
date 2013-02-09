class Scheduling
  autoload :Service, 'scheduling/service'
  autoload :ServicesRepository, 'scheduling/services_repository'
  autoload :Responce, 'scheduling/responce'
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
      resp.status = :unprocessable_entity
      resp.errors = ['code attribute required']
      return resp
    end

    service = Service.new({id: UUID.generate}.merge(attrs))
    ServicesRepository.save(service)
    resp.status = :created
    resp.entity = service
    resp
  end

  def get_service_resources(service_id)
    resp = Responce.new
    resp.status = :ok
    resp.entity = []
    resp
  end
end
