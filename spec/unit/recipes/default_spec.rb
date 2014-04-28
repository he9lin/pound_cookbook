require 'spec_helper'

describe "pound::default" do
  let(:chef_run) do
    runner = ChefSpec::Runner.new.converge(described_recipe)
  end

  it "installs the pound package" do
    expect(chef_run).to install_package 'Pound'
  end

  it "creates the pound configuration file" do
    file = '/etc/pound.cfg'
    expect(chef_run).to render_file(file).with_content <<-FILE
User "pound"
Group "pound"
Control "/var/lib/pound/pound.cfg"

ListenHTTP
    Address 0.0.0.0
    Port 80
End

Service
    BackEnd
        Address 127.0.0.1
        Port    8000
    End

    BackEnd
        Address 127.0.0.1
        Port    8001
    End
End
FILE

  end

  it "notifies pound to restart with config file" do
    resource = chef_run.template('/etc/pound.cfg')
    expect(resource).to notify('service[pound]').to(:restart).delayed
  end

  it "starts the pound service" do
    expect(chef_run).to start_service 'pound'
  end

  it "enables the pound service" do
    expect(chef_run).to enable_service 'pound'
  end
end
