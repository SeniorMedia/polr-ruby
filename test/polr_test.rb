require 'test_helper'

class PolrTest < Minitest::Test
  def setup
    # If Polr provides us an API KEY on polr.me, could test that requests are OK and add HTTPS support on gem.
    ::Polr.configure do |config|
      config.api_url = '187.98.10.19' # Invalid api_url
      config.api_key = '5szd4vcre1v5e4' # Invalid api_key
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Polr::VERSION
  end

  def test_configuration
    configuration = ::Polr::configuration

    assert_equal Polr::Configuration, configuration.class
    assert_equal '187.98.10.19', configuration.api_url
    assert_equal '5szd4vcre1v5e4', configuration.api_key
  end

  def test_resource_is_set
    assert_equal "#{::Polr::configuration::api_url}/api/#{::Polr::API_VERSION}/action/", ::Polr::Api::api_url
  end

  def test_token
    assert_equal Hash[key: ::Polr::configuration.api_key], ::Polr::Api::with_token
  end

  def test_shorten_method_return_error_on_invalid_server
    exception = assert_raises(Polr::Error) { Polr::shorten("http://google.fr") }
    assert_equal('undefined error', exception.message )
  end

  def test_lookup_method_return_error_on_invalid_server
    exception = assert_raises(Polr::Error) { Polr::lookup("d5r9") }
    assert_equal('undefined error', exception.message )
  end
end
