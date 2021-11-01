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
