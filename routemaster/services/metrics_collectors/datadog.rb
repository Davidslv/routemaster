require 'singleton'
require 'routemaster/services'

module Routemaster::Services::MetricsCollectors
  class Datadog
    include Singleton

    def initialize
      require 'dogapi'
      api_key = ENV.fetch('DATADOG_API_KEY')
      app_key = ENV.fetch('DATADOG_APP_KEY')
      @dog ||= Dogapi::Client.new(api_key, app_key)
    rescue KeyError
      abort 'Please install and configure datadog (or equivalent service) first!'
    end

    def perform(name, value, tags = [])
      all_tags = ["environment:#{ENV['RACK_ENV']}"] << tags
      p "#{name}, #{value}, #{tags}"
      p @dog.emit_point(name, value, tags: all_tags)
    end

  end
end
