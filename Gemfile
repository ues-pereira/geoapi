source "https://rubygems.org"

gem "active_model_serializers"
gem "rails", "~> 8.0.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "geocoder", "~> 1.3", ">= 1.3.7"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 7.0.0"
  gem "pry-byebug", "~> 3.10", ">= 3.10.1"
end

group :test do
  gem "shoulda-matchers", "~> 6.4"
  gem "vcr"
  gem "webmock"
end
