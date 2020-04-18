require 'forwardable'
require 'redis'

module FeasterFlags
  class RedisAdapter
    extend Forwardable

    def initialize(connection_info)
      @redis = Redis.new(connection_info)
    end

    def_delegators :@redis,
      :set,
      :mget,
      :del,
      :sadd,
      :smembers,
      :srem

    # TODO: Implement for persisted function
    # def subscribe
    # end

    private

    attr_reader :redis
  end
end
