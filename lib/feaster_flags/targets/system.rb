module FeasterFlags
  module Targets
    class System
      extend FeasterFlags::FeatureMethods

      class << self
        def tfm_redis
          FeasterFlags.configuration.redis
        end

        def feature_setting_keys(feature, setting)
          [
            FeasterFlags::Keys::System.build(feature, setting)
          ]
        end

        def feature_setting_key(feature, setting)
          FeasterFlags::Keys::System.build(feature, setting)
        end

        def feature_setting_patterns
          [
            FeasterFlags::Keys::System.pattern
          ]
        end
      end
    end
  end
end
