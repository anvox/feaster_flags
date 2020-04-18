module FeasterFlags
  # Sync back and forth bethween redis and db
  # It wipes all current data on target, so please back up before.
  class Sync
    class << self
      def redis_to_persistent!
        persisted_class.truncate!
        data = get_all_keys.map do |key|
          feature_key, setting_key, group_id, account_id = FeasterFlags::Key.parse(key)
          persisted_class.new(feature:    feature_key,
                              setting:    setting_key,
                              group_id:   group_id,
                              account_id: account_id,
                              value:      get(key))
        end

        persisted_class.import(data)
      end

      def persistent_to_redis!
        delete_all_keys!
        persisted_class.find_each do |item|
          set(build_key(item), item.value)
        end
      end

      private

      def persisted_class
        FeasterFlags.configuration.persisted_class_name.constantize
      end

      def get_all_keys
        FeasterFlags.configuration.redis.keys(FeasterFlags::Key.key_pattern)
      end

      def get(key)
        FeasterFlags.configuration.redis.get(key)
      end

      def set(key, value)
        FeasterFlags.configuration.redis.set(key, value)
      end

      def delete_all_keys!
        FeasterFlags.configuration.redis.del(FeasterFlags::Key.key_pattern)
      end

      def build_key(item)
        # TODO: Implement
      end
    end
  end
end
