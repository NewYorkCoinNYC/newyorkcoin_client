require 'net/http'
require 'uri'
require 'json'
require 'newyorkcoin_client'
require 'newyorkcoin_client/methods'
require 'errors/http_error'
require 'errors/rpc_error'
require 'errors/invalid_method_error'


class NewYorkcoinClient
  class Client

    attr_accessor :options

    def initialize(options = {})
      @options = get_defaults.merge(options)
    end

    def valid?
      post_body = { method: 'getinfo', id: Time.now.to_i }.to_json
      http_post_request(post_body).class == Net::HTTPOK rescue false
    end

    def method_missing(name, *args)
      raise NewYorkcoinClient::InvalidMethodError.new(name) unless NewYorkcoinClient::METHODS.include?(name.to_s)

      response = http_post_request( get_post_body(name, args) )
      get_response_data(response)
    end

    def http_post_request(post_body)
      url = URI.parse "#{@options[:protocol]}://#{@options[:user]}:#{@options[:password]}@#{@options[:host]}:#{@options[:port]}/"

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')

      request = Net::HTTP::Post.new(url.path)
      request.basic_auth url.user, url.password
      request.content_type = 'application/json'
      request.body = post_body

      response = http.request(request)

      return response if response.class == Net::HTTPOK or response.class == Net::HTTPInternalServerError
      raise NewYorkcoinClient::HTTPError.new(response)
    end

    private

    def get_post_body(name, args)
      { method: de_ruby_style(name), params: args, id: Time.now.to_i }.to_json
    end

    def get_response_data(http_ok_response)
      resp = JSON.parse( http_ok_response.body )
      raise NewYorkcoinClient::RPCError.new(resp['error']['message']) if resp['error'] and http_ok_response.class == Net::HTTPInternalServerError
      resp['result']
    end

    def de_ruby_style(method_name)
       method_name.to_s.tr('_', '').downcase.to_sym
    end

    def get_defaults
      NewYorkcoinClient.configuration.instance_variables.each.inject({}) {|hash, var|
        hash[var.to_s.delete('@').to_sym] = NewYorkcoinClient.configuration.instance_variable_get(var);
        hash
      }
    end

  end
end
