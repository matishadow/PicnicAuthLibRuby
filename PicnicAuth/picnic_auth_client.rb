require 'rest-client'
require 'rubygems'
require 'json'

module PicnicAuthModule
  class PicnicAuthClient
    @base_endpoint = ''
    @api_key = ''
    @authorization_header

    def initialize(base_endpoint, api_key)
      @base_endpoint = base_endpoint
      @api_key = api_key
      @authorization_header = {'Authorization': "Bearer #{api_key}" }
    end

    def create_request_url(endpoint_url)
      @base_endpoint + endpoint_url
    end

    def login(username, password)
      request_url = create_request_url('tokens')
      request = RestClient.post(request_url, {'grant_type': 'password', 'username': username, 'password': password})
      content = JSON.parse(request.body)
      @api_key = content['access_token']
      @authorization_header = {'Authorization': "Bearer #{@api_key}" }

      request
    end

    
  end
end