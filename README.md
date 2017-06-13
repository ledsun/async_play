# AsyncPlay

Wait for completion of the asynchronous procedure to obtain thats results.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'async_play'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install async_play

## Usage

To obtain results from asynchronous procedure, the procedure is passed as a block to AsyncPlay#opening.
The block will be given one argiment that is a Proc to return resuts.
The end of block call the proc with results then return it from AsyncPlay#opening.


```ruby
results = AsyncPlay.opening{ | curtain | Thread.new { curtain.call 1 } }
```

If you do not call the proc within 1 second, AsyncPlay#opening raise an error.

### Change wait time

The wait time is 1 second by default.
To change wait time, set the environment variable `ASYNC_PLAY_WAIT_TIME` in seconds.

## See also

[RSpecで非同期な関数をテストする - Qiita](http://qiita.com/ledsun/items/0e1dd4ece43dc56653c7) (Japanese)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ledsun/async_play.
