module FeasterFlags
  class Key
    DEFAULT_PREFIX = "feaster_flags".freeze

    class << self
      def key_pattern
        "#{prefix}/*"
      end

      def prefix
        FeasterFlags.configuration.prefix || DEFAULT_PREFIX
      end

      def parse(key)
        flag = key.to_s.split('/')[1]
        if flag == 's' # System
          FeasterFlags::Keys::System.parse(key)
        elsif flag == 'g' # Group
          FeasterFlags::Keys::Group.parse(key)
        elsif flag == 'a'
          FeasterFlags::Keys::Account.parse(key)
        else
          raise StandardError.new('Unknown flag')
        end
      end
    end
  end
end
