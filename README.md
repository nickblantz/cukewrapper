# Cukewrapper

This gem allows you to glue Gherkin to tests using tags, rather than step 
definitions. In addition to tags, you can also provide information to 
scenarios using Cucumber Datatables. 

## Installation

Add this to your Gemfile:

```ruby
gem 'cukewrapper'

# Optional plugins
group :cukewrapper_plugins do
  gem 'cukewrapper_data'
  gem 'cukewrapper_inline_jsonpath'
  # ...
end
```

## Usage

Create a `cukewrapper.yml` file at the root of your directory

```yaml
logger:
  global:
    level: debug
```

Require the gem in your Cucumber test suite

```ruby
require 'cukewrapper'
```

## Example Feature

```gherkin
@ten.mock.pid=000000
Feature: Example feature

# Other Scenario Tags
# @ten.negate
# @ten.succeed
# @ten.fail

@QA @UI @Example
@ten.mock.tid=000000
@ten.data.source=./data/example.json
@ten.data.remap=./data/example_remap.rb
Scenario Outline: Example Scenario
    Given I am doing something in my app
     When I try to do it
     Then It succeeds
        | JSONPath                           | Value              |
        | $.basketName                       | <basketName>       |
        | $.date                             | <date>             |
        | $.coupons                          | <coupons>          |
        # Each item's price                  # Overriding a value #
        | $.items[*].price                   | 10.00              |
        # The item at index 1                # Merging a Hash     #
        | $.items[1]                         | ~#{'price'=>20.00} |
        # Each item named Tito's kind        # Removes the key    #
        | $.items[?(@.name == 'Lays')].kind  |                    |

Examples:
    | basketName                                                   | date                 | coupons                   |
    # Using Faker to generate initials                             # Current time         # Merging Array             #
    | #Faker::Name.initials(number: 2) + "'s Shoppe"               | #Time.now            | ~["604222ac", "eb3f6967"] |
    # Creating a Hash using Faker                                  # Tomorrow's date      # "Do Nothing" merge        #
    | #{ name: "#{Faker::Name.first_name}'s Shoppe", type: 'LLC' } | #(Date.today+1).to_s | ~                         |
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nickblantz/cukewrapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nickblantz/cukewrapper/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cukewrapper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nickblantz/cukewrapper/blob/master/CODE_OF_CONDUCT.md).
