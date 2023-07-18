# frozen_string_literal: true

source 'https://rubygems.org'
gem 'bcrypt'
ruby '2.7.6'
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
# gem 'bootstrap-will_paginate', '~> 1.0'
gem 'coffee-rails', '~> 4.2'
gem 'faker'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.6'
gem 'rails-i18n'
gem 'rinku'
gem 'rubocop', require: false
gem 'rubocop-rails', require: false
gem 'sassc-rails', '>= 2.1.0'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
# gem 'will_paginate'
gem 'will_paginate', '3.3.1'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'sqlite3', '1.3.13'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'pg', '0.20.0'
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]