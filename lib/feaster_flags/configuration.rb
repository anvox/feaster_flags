module FeasterFlags
  class Configuration
    attr_accessor :allow_missing,
      :prefix,
      :group_id_attribute_name,
      :redis_options,
      :redis,
      :persisted_class_name,
      :persistent_async,
      # :api_authenticate

    def initialize
      # General config
      self.allow_missing = true
      self.prefix = nil

      # Integrate to system
      self.group_id_attribute_name = nil

      # Redis configuretion
      self.redis_options = nil
      self.redis = nil

      # Persisted functions
      self.persisted_class_name = nil
      self.persistent_async = nil

      # TODO: Implement API functions to support client on other platforms
      # self.api_authenticate = false
    end

    def setup
      self.redis ||= FeasterFlags::RedisAdapter.new(redis_options)
    end
  end
end
