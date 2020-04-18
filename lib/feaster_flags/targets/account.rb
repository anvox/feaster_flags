module FeasterFlags
  module Targets
    module Account
      include FeasterFlags::FeatureMethods

      def tfm_redis
        FeasterFlags.configuration.redis
      end

      def feature_setting_keys(feature, setting)
        [
          feature_setting_key(feature, setting),
          FeasterFlags::Keys::Group.build(feature, setting, feature_setting_group_id),
          FeasterFlags::Keys::System.build(feature, setting)
        ]
      end

      def feature_setting_key(feature, setting)
        FeasterFlags::Keys::Account.build(feature, setting, feature_setting_group_id, id)
      end

      def feature_setting_patterns
        [
          FeasterFlags::Keys::Account.pattern(feature_setting_group_id, id),
          FeasterFlags::Keys::Group.pattern(feature_setting_group_id),
          FeasterFlags::Keys::System.pattern,
        ]
      end

      def feature_setting_group_id
        public_send(FeasterFlags.configuration.group_id_attribute_name)
      end
    end
  end
end
