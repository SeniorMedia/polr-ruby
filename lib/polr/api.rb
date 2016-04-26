require 'rest-client'
require 'json'

module Polr
  API_VERSION = 'v2'

  Error = Class.new StandardError

  module Api
    def self.api_url
      %Q(#{Polr.configuration.api_url}/api/#{API_VERSION}/action/)
    end

    def self.resource
      RestClient::Resource.new api_url, timeout: 10
    end

    def self.with_token **params
      params.merge(key: Polr.configuration.api_key)
    end

    def self.process
      JSON.parse yield
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => e # API unreachable
      raise Polr::Error.new 'Polr API is unreachable'
    rescue RestClient::Exception => e # HTTP status error
      result = (JSON.parse(e.response) rescue {})
      raise Polr::Error.new(result['error'] || 'undefined error')
    rescue JSON::ParserError => e # JSON error
      raise Polr::Error.new e.message
    end
  end

  # Actions to use

  def self.shorten url, **options
    Api.process { Api.resource['shorten'].get( Api.with_token({ url: url }.merge(options)) ) }
  end

  def self.lookup url_ending, **options
    Api.process { Api.resource['lookup'].get( Api.with_token({ url_ending: url_ending }.merge(options)) ) }
  end
end
