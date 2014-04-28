require 'spec_helper'

describe 'Pound Loadbalancer' do
  it 'should be listening on port 80' do
    expect(port 80).to be_listening
  end

  it 'should be running the pound service' do
    expect(service 'pound').to be_running
  end

  it 'should have two active backends' do
    expect(command 'poundctl -c /var/lib/pound/pound.cfg').to \
      return_stdout /.*Backend.*800[01].*active/
  end

  it 'should have an HTTP listener' do
    expect(command 'poundctl -c /var/lib/pound/pound.cfg').to \
      return_stdout /.*http Listener.*/
  end

  it 'should not have an HTTPS listener' do
    expect(command 'poundctl -c /var/lib/pound/pound.cfg').not_to \
      return_stdout /.*HTTPS Listener.*/
  end

  it 'should accept HTTP connections on port 80' do
    expect(command "echo 'GET / HTTP/1.1' | nc localhost 80").to \
      return_stdout /Content-Length:.*/
  end
end
