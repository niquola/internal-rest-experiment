require 'spec_helper'

describe "Scheduling" do
  subject { Scheduling.new }

  it "should" do
    resp = subject.get(:services)
    resp.services.should be_empty

    resp = subject.post :services,
      {code: {codeSystem: 'local', code: 'Surgeries'}, description: 'Surgery operations'}

    resp.status.should == :created
    entity = resp.entity
    entity.id.should_not be_nil

    resp = subject.get(:services)
    services = resp.services
    services.should_not be_empty

    resp = subject.post :services, {}

    resp.status.should == :unprocessable_entity
    resp.errors.should == ['code attribute required']
  end

  let(:service) { subject.post(:services, {code: {codeSystem: 'local', code: 'Surgeries'}, description: 'Surgery operations'}).entity }

  it "should resources" do
    resp = subject.get([:service, :resources], service.id)
    resp.entity.should be_empty

    subject.post:resources,
		 {code: {code: 'Room1', codeSystem: 'local'}, class_code: :location, services: [service.id]}

    resp = subject.get([:service, :resources], service.id)
    resp.status.should == :ok
    resp.entity.should_not be_nil
  end

  it "appointment" do
    resp = subject.post :appointments,
      service: service.id,
      resources: [room.id, surgeon.id, nurse.id],
      period: ['2013-05-05T13:00', '2013-05-05T14:30']

    resp.should == :created
    appointment = resp.entity

    resp = subject.put [:approve, :appointmen], {id: appointmen.id}
  end
end
