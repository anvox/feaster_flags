module FeasterFlags
  module Targets
    module Group
      include FeasterFlags::FeatureMethods

      def tfm_redis
        FeasterFlags.configuration.redis
      end

      def feature_setting_keys(feature, setting)
        [
          feature_setting_key(feature, setting),
          FeasterFlags::Keys::System.build(feature, setting),
        ]
      end

      def feature_setting_key(feature, setting)
        FeasterFlags::Keys::Group.build(feature, setting, id)
      end

      def feature_setting_patterns
        [
          FeasterFlags::Keys::Group.pattern(id),
          FeasterFlags::Keys::System.pattern,
        ]
      end
    end
  end
end
