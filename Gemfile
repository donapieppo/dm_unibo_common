source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in dm_unibo_common.gemspec.
gemspec

gem "puma"
gem "sqlite3"
gem "sprockets-rails"

gem "dm_unibo_user_search", git: "https://github.com/donapieppo/dm_unibo_user_search.git", ref: "master", branch: "master"

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

group :test do
  gem "cucumber-rails", require: false
  # database_cleaner is not required, but highly recommended
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "rspec-rails"
end
