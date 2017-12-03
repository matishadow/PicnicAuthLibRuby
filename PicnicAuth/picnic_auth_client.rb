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
    end

    def create_request_url(endpoint_url)
      @base_endpoint + endpoint_url
    end

    def login(username, password)
      request_url = create_request_url('tokens')
      request = RestClient.post(request_url, {'grant_type': 'password', 'username': username, 'password': password})
      content = JSON.parse(request.body)
      @api_key = content['access_token']

      request
    end

    def get_auth_users(page=1, page_count=10)
      request_url = create_request_url('Companies/Me/AuthUsers')
      request = RestClient.get(request_url, {params: {page: page, pageCount: page_count},
                                             :Authorization => "Bearer #{api_key}"})

      request
    end

    def add_auth_user(external_id, username, email)
      request_url = create_request_url('AuthUsers')
      request = RestClient.post(request_url, {
          'ExternalId' => external_id, 'UserName' => username, 'Email' => email
      }.to_json, :Authorization => "Bearer #{@api_key}", content_type: :json)

      request
    end

    def generate_new_secret(user_id)
      request_url = create_request_url("AuthUsers/#{user_id}/secret")
      request = RestClient.patch(request_url, NIL, :Authorization => "Bearer #{@api_key}")

      request
    end

    def get_logged_company
      request_url = create_request_url('Companies/Me')
      request = RestClient.get(request_url, :Authorization => "Bearer #{@api_key}")

      request
    end

    def add_company(email, username, password)
      request_url = create_request_url('Companies')
      request = RestClient.post(request_url, {'Email'=> email, 'UserName'=> username, 'Password'=> password,
                                              'ConfirmPassword'=> password}.to_json, content_type: :json)

      request
    end

    def get_hotp_for_authuser(user_id)
      request_url = create_request_url("AuthUsers/#{user_id}/hotp")
      request = RestClient.get(request_url, :Authorization => "Bearer #{@api_key}")

      request
    end

    def validate_hotp(user_id, hotp)
      request_url = create_request_url("AuthUsers/#{user_id}/hotp/#{hotp}")
      request = RestClient.get(request_url, :Authorization => "Bearer #{@api_key}")

      request
    end

    def get_totp_for_authuser(user_id)
      request_url = create_request_url("AuthUsers/#{user_id}/totp")
      request = RestClient.get(request_url, :Authorization => "Bearer #{@api_key}")

      request
    end

    def validate_totp(user_id, totp)
      request_url = create_request_url("AuthUsers/#{user_id}/totp/#{totp}")
      request = RestClient.get(request_url, :Authorization => "Bearer #{@api_key}")

      request
    end

  end
end