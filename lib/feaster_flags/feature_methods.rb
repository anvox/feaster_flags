require "feaster_flags/redis_to_persist"
require "feaster_flags/feature_object"

module FeasterFlags
  module FeatureMethods

    # Return all feature of an object
    # {
    #   :feature => {
    #     :setting => "value",
    #     :enabled? => true
    #   }
    # }
    # TODO: Implement feature, setting list management
    def features(feature_key = nil)
    end

    # Get settings of a feature or a specific setting of a feature
    #
    # ```
    # feature(:feature)
    # #=> {:setting => "value", :enabled? => true }
    # feature(:feature, :setting)
    # #=> "value"
    # feature(:feature, :enabled?)
    # #=> true
    # feature(:feature).enabled?
    # #=> true
    # feature(:feature).setting
    # #=> "value"
    # ```
    #
    # By convention, all setting keys end with "?" are treated as boolean,
    #   otherwise, treated as string
    # Value are reference by level:
    #   1. User account feature settings
    #   2. If user account settings are unset, use group feature settings
    #   3. If group settings are unset, use system feature settings
    #   4. If system feature settings are unset, depends on Configuration#allow_missing
    #       Return false for boolean or empty string "" for others.
    #
    def feature(feature_key, setting_key = nil)
      if setting_key.nil?
        return FeasterFlags::FeatureObject.new(self, feature_key)
      end

      value = tfm_redis.mget(feature_setting_keys(feature_key, setting_key)).compact.first

      if setting_key.to_s[-1] == '?'
        value == '1'
      else
        value.to_s
      end
    end

    #
    # To set value of a feature setting, or some settings of a feature
    # ```
    # set_feature(:feature, :setting, "value")
    # set_feature(:feature, :enabled?, true)
    # ```
    #
    def set_feature(feature_key, setting_key, value)
      if setting_key.to_s[-1] == '?'
        value = value ? '1' : 0
      else
        value = value.to_s
      end
      key = feature_setting_key(feature_key, setting_key)

      tfm_redis.set(key, value)
      FeasterFlags::RedisToPersist.set(key, value)
      true
    end

    #
    # To unset value of a feature setting, or some settings of a feature
    # ```
    # unset_feature(:feature, :setting)
    # unset_feature(:feature, :enabled?)
    # ```
    #
    def unset_feature(feature_key, setting_key)
      key = feature_setting_key(feature_key, setting_key)
      tfm_redis.del(key)
      FeasterFlags::RedisToPersist.del(key)
      true
    end
  end
end
