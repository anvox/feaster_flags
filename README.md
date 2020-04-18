# FeasterFlags

Small feature management lib, support model System -> Account -> User feature flags.
Support syncback to db like mysql through ActiveRecord

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'feaster_flags'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install feaster_flags

## Usage

Minimal config
```ruby
FeasterFlags.configure do |c|
  c.group_id_attribute_name = 'group_id' # user reference to group by group_id
  c.redis_options = {
    host: redis_url,
    port: redis_port,
    password: redis_password,
    thread_safe: true
  } # Any thing which Redis.new supports
end

class Account
  include FeasterFlags::Targets::Account
end

class User
  include FeasterFlags::Targets::User
end
```

Then we could query setting. There are 3 level:
  1. User account feature settings
  2. If user account settings are unset, use group feature settings
  3. If group settings are unset, use system feature settings

```ruby
user = User.first
group = user.group

FeasterFlags::Targets::System.set_feature(:live, :enabled?, true)
group = Group.sample
group.feature(:live, :enabled?)
#=> true
group.feature(:live).enabled?
#=> true
user.feature(:live, :enabled?)
#=> true
user.feature(:live).enabled?
#=> true

group.set_feature(:live, :enabled?, true)
user.feature(:live, :enabled?)
#=> true
user.set_feature(:live, :enabled?, false)
user.feature(:live, :enabled?)
#=> false
group.feature(:live, :enabled?)
#=> true
```

Persistent function. Feature management is important, if redis is not durable, we could mirror to database, using persistent function.

```ruby
FeasterFlags.configure do |c|
  c.group_id_attribute_name = 'group_id' # user reference to group by group_id
  c.redis_options = {
    host: redis_url,
    port: redis_port,
    password: redis_password,
    thread_safe: true
  } # Any thing which Redis.new supports
  # model FeatureSetting(group_id: bigint, account_id: bigint, feature: string, setting: string, value: string)
  c.persisted_class_name = 'FeatureSetting'
  c.persistent_async = :inline
  # OR
  c.persistent_async = lambda do |action, params|
    FeatureSettingSyncJob.perform_async(action, params)
  end
end
# with
class FeasterFlagsSyncJob
  include Sidekiq::Worker

  def perform(action, params)
    FeasterFlags::PersistedModel.store(action, params)
  end
end
```

There are 2 option:
  1. Inline - persist command will trigger right after set/unset settings
  2. Async - through a queue system, TFM lib doesn't manage worker or queue.
  Just ensure `FeasterFlags::PersistedModel.store` are triggered.

Persist feature settings also allow query more detail on feature setting usage, using `TinyFeatureSetting::Query`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anvox/feaster_flags. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FeasterFlags project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/anvox/feaster_flags/blob/master/CODE_OF_CONDUCT.md).
