module FeasterFlags
  class PersistedModel
    class << self
      def store(action, data)
        return if disabled?

        public_send(action, *data)
      end

      def set(key, value)
        return if disabled?

        feature_key, setting_key, group_id, account_id = FeasterFlags::Key.parse(key)
        item = persisted_class.find_or_initialize_by(feature: feature_key,
                                                     setting: setting_key,
                                                     group_id: group_id,
                                                     account_id: account_id)
        item.value = value
        item.save!
      end

      def del(key)
        return if disabled?

        feature_key, setting_key, group_id, account_id = FeasterFlags::Key.parse(key)
        item = persisted_class.find_by(feature: feature_key,
                                       setting: setting_key,
                                       group_id: group_id,
                                       account_id: account_id)
        item.destroy if item
      end

      private

      def disabled?
        FeasterFlags.configuration.persisted_class_name.nil?
      end

      def persisted_class
        FeasterFlags.configuration.persisted_class_name.constantize
      end
    end
  end
end
