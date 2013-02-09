require 'uuid'
class Scheduling::ServicesRepository
  def self.all
    (@services ||= {}).values
  end

  def self.save(service)
    @services[service.id] = service
  end
end

