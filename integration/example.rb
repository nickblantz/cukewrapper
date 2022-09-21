require 'profile'

10.times do
  require 'cucumber/cli/main'
  Cucumber::Cli::Main.new(ARGV.dup).execute!
end