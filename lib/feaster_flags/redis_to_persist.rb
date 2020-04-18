require 'feaster_flags/persisted_model'

module FeasterFlags
  class RedisToPersist
    class << self
      def set(key, value)
        return unless enabled?

        if is_inline?
          FeasterFlags::PersistedModel.store(:set, [key, value])
        elsif is_async_block?
          FeasterFlags.configuration.persistent_async.call(:set, [key, value])
        end
      end

      def del(key)
        return unless enabled?

        if is_inline?
          FeasterFlags::PersistedModel.store(:del, [key])
        elsif is_async_block?
          FeasterFlags.configuration.persistent_async.call(:set, [key])
        end
      end

      private

      def enabled?
        is_inline? || is_async_block?
      end

      def is_inline?
        FeasterFlags.configuration.persistent_async == :inline
      end

      def is_async_block?
        FeasterFlags.configuration.persistent_async.respond_to?(:call)
      end
    end
  end
end
