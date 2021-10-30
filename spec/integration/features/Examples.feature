@ten.fze.managed
@ten.fze.pid=000000
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
        | Path                               | Change           |
        | $.basketName                       | <basketName>     |
        | $.date                             | <date>           |
        | $.items[*].price                   | 10.00            |
        | $.items[1]                         | ~{"price":20.00} |
        | $.items[?(@.name == 'Titos')].kind | "Vodka"          |
        | $.foo                              | "baz"            |

Examples:
    | basketName                                     | date         |
    | ~"Trader Joe's"                                | #Time.now    |
    | #Faker::Name.initials(number: 2) + "'s Shoppe" | "10/30/2021" |