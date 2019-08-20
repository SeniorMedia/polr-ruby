# frozen_string_literal: true

require 'rest-client'
require 'json'

module Polr
  API_VERSION = 'v2'.freeze

  Error = Class.new StandardError

  module Api
    def self.api_url(path = nil)
      %(#{Polr.configuration.api_url}/api/#{API_VERSION}/action/#{path})
    end

    def self.api_key
      Polr.configuration.api_key
    end

    def self.process
      JSON.parse(yield).with_indifferent_access
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => e # API unreachable
      raise Polr::Error, 'Polr API is unreachable'
    rescue RestClient::Exception => e # HTTP status error
      result = (begin
                  JSON.parse(e.response)
                rescue StandardError
                  {}
                end)
      raise Polr::Error, result['error'] || 'undefined error'
    rescue JSON::ParserError => e # JSON error
      raise Polr::Error, e.message
    end

    def self.request(path, params)
      RestClient.get(Api.api_url(path.to_s), params: params.merge(key: Api.api_key, response_type: :json), content_type: :json, accept: :json, timeout: 10)
    end
  end

  # Actions to use

  def self.shorten(url, **options)
    Api.process { Api.request(:shorten, { url: url }.merge(options)) }
  end

  def self.lookup(url_ending, **options)
    Api.process { Api.request(:lookup, { url_ending: url_ending }.merge(options)) }
  end
end
