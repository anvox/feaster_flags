module FeasterFlags
  module Keys
    class Group
      def self.build(feature, setting, id)
        "#{FeasterFlags::Key.prefix}/g/#{id}/#{feature}/#{setting}"
      end

      def self.pattern(id)
        "#{FeasterFlags::Key.prefix}/g/#{id}/*"
      end

      def self.parse(key)
        key.to_s.split('/').last(3).reverse
      end
    end
  end
end
