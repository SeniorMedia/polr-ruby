# frozen_string_literal: true

require 'polr/version'
require 'polr/api'

module Polr
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_url, :api_key
  end
end
