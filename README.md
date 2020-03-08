# Digest::BLAKE3

BLAKE3 for Ruby.  Uses a bundled copy of the C implementation from [BLAKE3-team](https://github.com/BLAKE3-team/BLAKE3/tree/master/c) to minimize dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'digest-blake3'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install digest-blake3

## Usage

`Digest::BLAKE3` is implemented using the standard library's `Digest` wrapper, which gives you a broad API:

```ruby
require 'digest/blake3'

# Compute a complete digest
Digest::BLAKE3.digest("input data") # returns binary data in a string

blake3 = Digest::BLAKE3.new
blake3.digest "input data"

# Other encoding formats
Digest::BLAKE3.hexdigest("input data")
Digest::BLAKE3.base64digest("input data")

# Compute digest by chunks
blake3 = Digest::BLAKE3.new
blake3.update("input")
blake3 << " data"
blake3.hexdigest

# Compute digest for a file
blake3 = Digest::BLAKE3.file 'testfile'
blake3.hexdigest
```

## Alternatives

* [blake3 gem](https://github.com/Yamaguchi/blake3rb) by @Yamaguchi uses the original Rust implementation of BLAKE3. This supports even greater speed through multi-threaded hashing, but requires Rust and Cargo on the systems you install the gem on.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake compile` to compile the library and `bundle exec rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/digest-blake3.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
