require 'net/http'
require 'newyorkcoin_client/client'
require 'errors/http_error'
require 'errors/rpc_error'
require 'errors/invalid_method_error'

describe NewYorkcoinClient::Client do

  def valid_client
    # For local testing ensure you have newyorkcoind running correctly and use your own username / password here
    NewYorkcoinClient::Client.new(user: 'newyorkcoinrpc', password: '5d36c07c20a43a281f54c07d72ce78cc')
  end

  it 'rejects bad credentials' do
    bad_client = NewYorkcoinClient::Client.new(user: 'bad_username', password: 'bad_password')
    bad_client.valid?.should eql(false)
  end

  it 'connects to the rpc server' do
    valid_client.valid?.should eql(true)
  end

  it 'catches requests with bad credentials' do
    bad_client = NewYorkcoinClient::Client.new(user: 'bad_username', password: 'bad_password')
    expect { bad_client.get_info }.to raise_error(NewYorkcoinClient::HTTPError)
  end

  it 'catches requests with bad service urls' do
    bad_client = valid_client
    bad_client.options[:host] = 'not_localhost'
    expect { bad_client.get_info }.to raise_error

    bad_client2 = valid_client
    bad_client2.options[:port] = 100
    expect { bad_client2.get_info }.to raise_error
  end

  it 'works with ruby-style method names' do
    c = valid_client
    c.get_info
    c.get_block_count
  end

  it 'throws rpc_error when the params are bad' do
    expect { valid_client.get_account('bad_location') }.to raise_error(NewYorkcoinClient::RPCError)
  end

  it 'only allows listed methods' do
    expect { valid_client.not_a_real_method }.to raise_error(NewYorkcoinClient::InvalidMethodError)
  end

end