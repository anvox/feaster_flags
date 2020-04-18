module FeasterFlags
  class FeatureObject
    def initialize(source, feature)
      @source, @feature = source, feature
    end

    def method_missing(setting, *args)
      if args.any?
        raise StandardError.new('No arguments allow')
      end

      @source.feature(@feature.to_sym, setting.to_sym)
    end
  end
end
