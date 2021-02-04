require 'newyorkcoin_client/version'
require 'newyorkcoin_client/client'

class NewYorkcoinClient

  def initialize(options = {})
    @client = NewYorkcoinClient::Client.new(options)
  end

  # Delegate everything to the 'real' Client
  def method_missing(name, *args)
    @client.send(name, *args)
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :host, :port, :protocol, :user, :password

    def initialize
      self.host = 'localhost'
      self.port = 18823
      self.protocol = :http
      self.user = ''
      self.password = ''
    end

  end

end
