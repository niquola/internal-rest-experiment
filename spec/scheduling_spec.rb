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

    resp = subject.post:resources,
      code: {code: 'Room1', codeSystem: 'local'},
      class_code: :location,
      service: service.id

    resp.status.should == :created
    resource = resp.entity
    resource.id.should_not be_nil

    resp = subject.get([:service, :resources], service.id)

    resp.status.should == :ok
    resp.entity.first.id.should == resource.id
  end

  let(:room) do
    resp = subject.post :resources,
      roles: [:location],
      identity: {name: 'Room1',
	code: 'room1'}
    resp.entity
  end

  let(:surgeon) do
    resp = subject.post :resources,
      roles: [:surgeon],
      identity: {name: 'Dr. Ushman Pablo',
	license_number: '1111'}
    resp.entity
  end

  it "appointment" do
    resp = subject.post :appointments,
      service: service.id,
      resources: [
	{role: 'location', resource: room.id},
	{role: 'surgeon', resource: surgeon.id}],
	period: ['2013-05-05T13:00', '2013-05-05T14:30']

    resp.status.should == :created
    appointment = resp.entity

    #resp = subject.put [:approve, :appointmen],
      #{id: appointmen.id}

    resp = subject.get :appointments,
      resoures: [room.id],
      period: ['2013-05-05T00:00', '2013-05-05T23:59']

    appointments = resp.entity
  end
end
