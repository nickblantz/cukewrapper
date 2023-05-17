@Example
Feature: Example feature


@API
@cw.rapid.tid=113fb921-f125-4717-93fe-77c0af8fcb76
@cw.data.source=./data/example.json
@cw.data.remap=./data/example_remap.rb
Scenario Outline: Example Scenario
    Given > I am doing something in my app
     When > I try to do it
     Then > It succeeds
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
    # Creating a Hash using Faker                                  # Tomorrow's date      # "Do Nothing" merge        #
    | #{ name: "#{Faker::Name.first_name}'s Shoppe", type: 'LLC' } | #(Date.today+1).to_s | ~                         |

# @cw.negate
# Examples:
#     | basketName                                                   | date                 | coupons                   |
#     # Using Faker to generate initials                             # Current time         # Merging Array             #
#     | #Faker::Name.initials(number: 2) + "'s Shoppe"               | #Time.now            | ~["604222ac", "eb3f6967"] |


# @UI
# @cw.fnze.tid=883009
# @cw.fnze.browser=72
# @cw.data.source=./data/fnze.json
# Scenario: Example Scenario
#     Given > I am doing something in my app
#      When > I try to do it
#      Then > It succeeds

Scenario:
  Given I am outside of Cukewrapper