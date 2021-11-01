# Cukewrapper

does some wrapping magic

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cukewrapper'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cukewrapper

## Usage

```bash
gem build cukewrapper.gemspec && gem install --local cukewrapper-0.1.0.gem
cd integration
bundler install
cucumber
```

## Example Feature

```gherkin
@ten.fze.managed @ten.fze.pid=000000
Feature: Example feature

# Other Scenario Tags
# @ten.negate
# @ten.succeed
# @ten.fail

@QA @UI @Example
@ten.fze.tid=000000 @ten.data.source=./data/example.json @ten.data.remap=./data/example_remap.rb
Scenario Outline: Example Scenario
    Given I am doing something in my app
     When I try to do it
     Then It succeeds
        | Path                               | Change             |
        | $.basketName                       | <basketName>       |
        | $.date                             | <date>             |
        | $.coupons                          | <coupons>          |
        # Each item's price                  # Overriding a value #
        | $.items[*].price                   | 10.00              | 
        # The item at index 1                # Merging a Hash     #
        | $.items[1]                         | ~#{'price'=>20.00} | 
        # Each item named Tito's kind        # Does nothing       #
        | $.items[?(@.name == 'Titos')].kind | ~"Vodka"           | 

Examples:
    | basketName                                                   | date         | coupons                   |
    # Using Faker to generate initials                             # Current time # Merging Array             #
    | #Faker::Name.initials(number: 2) + "'s Shoppe"               | #Time.now    | ~["604222ac", "eb3f6967"] | 
    # Creating a Hash using Faker                                  #              # "Do Nothing" merge        #
    | #{ name: "#{Faker::Name.first_name}'s Shoppe", type: 'LLC' } | "10/30/2021" | ~                         | 
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cukewrapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/cukewrapper/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cukewrapper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cukewrapper/blob/master/CODE_OF_CONDUCT.md).
