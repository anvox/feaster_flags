module FeasterFlags
  module Keys
    class System
      def self.build(feature, setting)
        "#{FeasterFlags::Key.prefix}/s/#{feature}/#{setting}"
      end

      def self.pattern
        "#{FeasterFlags::Key.prefix}/s/*"
      end

      def self.parse(key)
        key.to_s.split('/').last(2)
      end
    end
  end
end
