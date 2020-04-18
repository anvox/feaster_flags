module FeasterFlags
  module Keys
    class Account
      def self.build(feature, setting, group_id, id)
        "#{FeasterFlags::Key.prefix}/a/#{group_id}/#{id}/#{feature}/#{setting}"
      end

      def self.pattern(group_id, id)
        "#{FeasterFlags::Key.prefix}/a/#{group_id}/#{id}/*"
      end

      def self.parse(key)
        key_parts = key.to_s.split('/').last(4)

        key_parts.last(2) + key_parts.first(2).reverse
      end
    end
  end
end
