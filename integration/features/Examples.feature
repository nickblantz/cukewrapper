Feature: Example feature

# Other Scenario Tags
# @ten.negate
# @ten.succeed
# @ten.fail

@QA @UI @Example
@ten.rapid.tid=FILL_ME_IN
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
