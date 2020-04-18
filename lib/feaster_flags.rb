require "feaster_flags/version"

require "feaster_flags/redis_adapter"
require "feaster_flags/configuration"
require "feaster_flags/keys"
require "feaster_flags/targets"
require "feaster_flags/sync"

module FeasterFlags
  class Error < StandardError; end

  class << self
    attr_reader :configuration

    def configure
      @configuration ||= FeasterFlags::Configuration.new
      yield(configuration)
      configuration.setup
    end
  end
end
